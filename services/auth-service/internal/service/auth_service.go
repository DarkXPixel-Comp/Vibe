package service

import (
	"context"
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type AuthService interface {
	SendCode(ctx context.Context, phone string) (string, error)
	VerifyCode(ctx context.Context, token, code string) (*model.AuthResponse, error)
	ValidateToken(ctx context.Context, token string) (string, error)
}

type authService struct {
	redisRep   repository.RedisRepository
	jwtConfig  *config.JWTConfig
	db         *pgxpool.Pool
	userClient *repository.UserClient
}

func NewAuthSevice(redisRep repository.RedisRepository, jwtConfig *config.JWTConfig, db *pgxpool.Pool, userClient *repository.UserClient) AuthService {
	return &authService{
		redisRep:   redisRep,
		jwtConfig:  jwtConfig,
		db:         db,
		userClient: userClient,
	}
}

func (s *authService) SendCode(ctx context.Context, phone string) (string, error) {
	// if limited, _ := s.IsSendCodeRateLimited(ctx, phone); limited {
	// 	return "", fmt.Errorf("too many attempts, please wait")
	// }

	code, err := utils.GenerateSMSCode()
	if err != nil {
		return "", fmt.Errorf("error generate code")
	}

	token, err := utils.GenerateAuthJWTToken(phone, s.jwtConfig.Secret, time.Minute*5)
	if err != nil {
		return "", fmt.Errorf("error generate auth token: %w", err)
	}
	err = s.redisRep.Set(ctx, token, code, time.Minute*5)
	log.Println(code) //<- temp
	if err != nil {
		return "", fmt.Errorf("error save token: %w", err)
	}

	return token, nil
}

func (s *authService) VerifyCode(ctx context.Context, token, code string) (*model.AuthResponse, error) {
	// if limited, _ := s.IsVerifyCodeRateLimited(ctx, token); limited {
	// 	return nil, fmt.Errorf("too many attempts, please wait")
	// }
	val, err := s.redisRep.Get(ctx, token)
	if err != nil {
		return nil, fmt.Errorf("invalid code")
	}

	phone, err := utils.ValidateAuthJWTToken(token, s.jwtConfig.Secret)
	if err != nil {
		return nil, fmt.Errorf("invalid token")
	}

	if val != code {
		return nil, fmt.Errorf("invalid code")
	}

	user, err := s.userClient.GetOrCreateUser(ctx, phone)
	if err != nil {
		return nil, fmt.Errorf("error getorcreateuser: %w", err)
	}

	tok, err := utils.GenerateToken32()
	if err != nil {
		return nil, fmt.Errorf("error generate token")
	}

	hashedToken := utils.HashToken(tok)

	query := `
		INSERT INTO session_tokens (user_id, token_hash, created_at, last_used_at, revoked)
		VALUES ($1, $2, NOW(), NOW(), false)
	`
	_, err = s.db.Exec(ctx, query, user.GetUserId(), hashedToken)
	if err != nil {
		return nil, fmt.Errorf("failed to save token: %w", err)
	}

	return &model.AuthResponse{
		Token:   tok,
		User_id: user.UserId,
	}, nil
}

func (s *authService) ValidateToken(ctx context.Context, token string) (string, error) {
	hashed := utils.HashToken(token)
	var tokenData struct {
		UserID     string
		LastUsedAt time.Time
		Revoked    bool
	}

	query := `
		SELECT user_id, last_used_at, revoked
		FROM session_tokens
		WHERE token_hash = $1
	`
	row := s.db.QueryRow(ctx, query, hashed)
	err := row.Scan(&tokenData.UserID, &tokenData.LastUsedAt, &tokenData.Revoked)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", status.Error(codes.InvalidArgument, "invalid token")
		}
		return "", status.Errorf(codes.Internal, "error db: %s", err.Error())
	}
	if tokenData.Revoked {
		return "", status.Error(codes.InvalidArgument, "invalid token")
	}
	if time.Since(tokenData.LastUsedAt) > 7*24*time.Hour {
		return "", status.Error(codes.InvalidArgument, "invalid token")
	}
	updateQuery := `
		UPDATE session_tokens
		SET last_used_at = NOW()
		WHERE token_hash = $1
	`
	_, err = s.db.Exec(ctx, updateQuery, hashed)
	if err != nil {
		return "", status.Errorf(codes.Internal, "%s", err.Error())
	}

	return tokenData.UserID, nil
}

func (s *authService) IsVerifyCodeRateLimited(ctx context.Context, phone string) (bool, error) {
	const rateLimitKeyPrefix = "verify_limit:"
	key := rateLimitKeyPrefix + phone

	count, err := s.redisRep.GetClient().Incr(ctx, key).Result()
	if err != nil {
		return false, err
	}

	if count == 1 {
		s.redisRep.GetClient().Expire(ctx, key, time.Minute*1)
	}

	if count > 3 {
		return true, nil
	}

	return false, nil
}

func (s *authService) IsSendCodeRateLimited(ctx context.Context, phone string) (bool, error) {
	const rateLimitKeyPrefix = "send_code_limit:"
	key := rateLimitKeyPrefix + phone

	count, err := s.redisRep.GetClient().Incr(ctx, key).Result()
	if err != nil {
		return false, err
	}

	if count == 1 {
		s.redisRep.GetClient().Expire(ctx, key, time.Minute*5)
	}

	if count > 1 {
		return true, nil
	}

	return false, nil
}
