package service

import (
	"context"
	"log"
	"time"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/database"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
	"github.com/jackc/pgx/v5"
	"github.com/redis/go-redis/v9"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type AuthService interface {
	SendCode(ctx context.Context, phone string) (string, error)
	VerifyCode(ctx context.Context, token, code string) (*model.AuthResponse, error)
	ValidateToken(ctx context.Context, token string) (string, error)
	RefreshToken(ctx context.Context, refreshToken string) (*model.AuthResponse, error)
}

type authService struct {
	redisRep   repository.RedisRepository
	jwtConfig  *config.JWTConfig
	db         database.DBPool
	userClient repository.UserClient
}

func NewAuthSevice(redisRep repository.RedisRepository, jwtConfig *config.JWTConfig, db database.DBPool, userClient repository.UserClient) AuthService {
	return &authService{
		redisRep:   redisRep,
		jwtConfig:  jwtConfig,
		db:         db,
		userClient: userClient,
	}
}

func (s *authService) SendCode(ctx context.Context, phone string) (string, error) {
	if limited, _ := s.IsSendCodeRateLimited(ctx, phone); limited {
		return "", status.Error(codes.ResourceExhausted, "too many attempts, please wait")
	}

	code, err := utils.GenerateSMSCode()
	if err != nil {
		return "", status.Errorf(codes.Internal, "failed to generate verification code: %v", err)
	}

	token, err := utils.GenerateAuthJWTToken(phone, s.jwtConfig.Secret, time.Minute*5)
	if err != nil {
		return "", status.Errorf(codes.Internal, "failed to generate auth token: %v", err)
	}
	err = s.redisRep.Set(ctx, token, code, time.Minute*5)
	log.Println(code) //<- temp
	if err != nil {
		return "", status.Errorf(codes.Internal, "failed to save verification code: %v", err)
	}

	return token, nil
}

func (s *authService) VerifyCode(ctx context.Context, token, code string) (*model.AuthResponse, error) {
	const (
		maxAttempts       = 5
		lockoutDuration   = 5 * time.Minute
		attemptsKeyPrefix = "verify_attempts:"
		lockoutKeyPrefix  = "verify_lockout:"
	)

	attemptsKey := attemptsKeyPrefix + token
	lockoutKey := lockoutKeyPrefix + token

	// 1. Check if the token is locked
	_, err := s.redisRep.Get(ctx, lockoutKey)
	if err == nil {
		return nil, status.Error(codes.ResourceExhausted, "too many attempts, please try again later")
	}
	if err != redis.Nil {
		return nil, status.Errorf(codes.Internal, "failed to check lockout status: %v", err)
	}

	// 2. Get the correct code from Redis
	correctCode, err := s.redisRep.Get(ctx, token)
	if err == redis.Nil {
		return nil, status.Error(codes.NotFound, "invalid or expired token")
	}
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to retrieve code: %v", err)
	}

	phone, err := utils.ValidateAuthJWTToken(token, s.jwtConfig.Secret)
	if err != nil {
		return nil, status.Errorf(codes.Unauthenticated, "invalid token: %v", err)
	}

	if correctCode != code {
		// Increment failure attempts
		attempts, err := s.redisRep.GetClient().Incr(ctx, attemptsKey).Result()
		if err != nil {
			return nil, status.Errorf(codes.Internal, "failed to update attempts: %v", err)
		}

		// If this is the first failure, set an expiration on the attempts key
		if attempts == 1 {
			s.redisRep.GetClient().Expire(ctx, attemptsKey, 5*time.Minute)
		}

		if attempts >= maxAttempts {
			// Lock the token and delete the code
			s.redisRep.Set(ctx, lockoutKey, "locked", lockoutDuration)
			s.redisRep.Del(ctx, token)       // Invalidate the code
			s.redisRep.Del(ctx, attemptsKey) // Clean up attempts counter
			return nil, status.Error(codes.ResourceExhausted, "too many incorrect attempts")
		}

		return nil, status.Error(codes.InvalidArgument, "invalid verification code")
	}

	s.redisRep.Del(ctx, token)
	s.redisRep.Del(ctx, attemptsKey)

	user, err := s.userClient.GetOrCreateUser(ctx, phone)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to get or create user: %v", err)
	}

	accessToken, err := utils.GenerateAccessToken(user.GetUserId(), s.jwtConfig.Secret, 15*time.Minute)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to generate access token: %v", err)
	}

	refreshToken, err := utils.GenerateToken32()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to generate refresh token: %v", err)
	}
	hashedRefreshToken := utils.HashToken(refreshToken)
	expiresAt := time.Now().Add(30 * 24 * time.Hour) // 30 days

	_, err = s.db.Exec(ctx, `
		INSERT INTO refresh_tokens (user_id, token_hash, expires_at)
		VALUES ($1, $2, $3)`,
		user.GetUserId(), hashedRefreshToken, expiresAt)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to save refresh token: %v", err)
	}

	return &model.AuthResponse{
		AccessToken:  accessToken,
		RefreshToken: refreshToken,
		UserID:       user.UserId,
	}, nil
}

func (s *authService) RefreshToken(ctx context.Context, refreshToken string) (*model.AuthResponse, error) {
	hashedRefreshToken := utils.HashToken(refreshToken)

	var (
		userID    string
		expiresAt time.Time
		revoked   bool
	)
	err := s.db.QueryRow(ctx, `
		SELECT user_id, expires_at, revoked FROM refresh_tokens WHERE token_hash = $1`,
		hashedRefreshToken).Scan(&userID, &expiresAt, &revoked)

	if err == pgx.ErrNoRows {
		return nil, status.Error(codes.Unauthenticated, "invalid refresh token")
	}
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to query refresh token: %v", err)
	}

	if revoked {
		return nil, status.Error(codes.Unauthenticated, "refresh token has been revoked")
	}

	if time.Now().After(expiresAt) {
		return nil, status.Error(codes.Unauthenticated, "refresh token has expired")
	}

	// Token is valid, proceed with rotation
	// Invalidate the old token
	_, err = s.db.Exec(ctx, `UPDATE refresh_tokens SET revoked = TRUE WHERE token_hash = $1`, hashedRefreshToken)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to revoke old refresh token: %v", err)
	}

	// Generate new access token
	newAccessToken, err := utils.GenerateAccessToken(userID, s.jwtConfig.Secret, 15*time.Minute)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to generate access token: %v", err)
	}

	// Generate and store new refresh token
	newRefreshToken, err := utils.GenerateToken32()
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to generate new refresh token: %v", err)
	}
	newHashedRefreshToken := utils.HashToken(newRefreshToken)
	newExpiresAt := time.Now().Add(30 * 24 * time.Hour)

	_, err = s.db.Exec(ctx, `
		INSERT INTO refresh_tokens (user_id, token_hash, expires_at)
		VALUES ($1, $2, $3)`,
		userID, newHashedRefreshToken, newExpiresAt)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to save new refresh token: %v", err)
	}

	return &model.AuthResponse{
		AccessToken:  newAccessToken,
		RefreshToken: newRefreshToken,
		UserID:       userID,
	}, nil
}

func (s *authService) ValidateToken(ctx context.Context, token string) (string, error) {
	userID, err := utils.ValidateAccessToken(token, s.jwtConfig.Secret)
	if err != nil {
		return "", status.Errorf(codes.Unauthenticated, "invalid access token: %v", err)
	}
	return userID, nil
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
		s.redisRep.GetClient().Expire(ctx, key, time.Minute*1)
	}

	if count > 1 {
		return true, nil
	}

	return false, nil
}
