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
	"github.com/jackc/pgx/v5/pgconn"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// DBPool defines the interface for database operations, allowing for mocking.
type DBPool interface {
	Exec(context.Context, string, ...interface{}) (pgconn.CommandTag, error)
	Query(context.Context, string, ...interface{}) (pgx.Rows, error)
	QueryRow(context.Context, string, ...interface{}) pgx.Row
}

type AuthService interface {
	SendCode(ctx context.Context, phone string) (string, error)
	VerifyCode(ctx context.Context, token, code, deviceID, deviceName string) (*model.AuthResponse, error)
	ValidateToken(ctx context.Context, token string) (string, error)
	ListSessions(ctx context.Context, userID, currentSessionToken string) ([]*model.Session, error)
	RevokeSession(ctx context.Context, sessionID, userID string) error
}

type authService struct {
	redisRep      repository.RedisRepository
	jwtConfig     *config.JWTConfig
	sessionConfig *config.SessionConfig
	db            DBPool
	userClient    repository.UserClientInterface
}

func NewAuthSevice(redisRep repository.RedisRepository, jwtConfig *config.JWTConfig, sessionConfig *config.SessionConfig, db DBPool, userClient repository.UserClientInterface) AuthService {
	return &authService{
		redisRep:      redisRep,
		jwtConfig:     jwtConfig,
		sessionConfig: sessionConfig,
		db:            db,
		userClient:    userClient,
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

func (s *authService) VerifyCode(ctx context.Context, token, code, deviceID, deviceName string) (*model.AuthResponse, error) {
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

	sessionKey, err := utils.GenerateRandomKey(32)
	if err != nil {
		return nil, fmt.Errorf("failed to generate session key: %w", err)
	}

	encryptedSessionKey, err := utils.Encrypt(sessionKey, []byte(s.sessionConfig.EncryptionKey))
	if err != nil {
		return nil, fmt.Errorf("failed to encrypt session key: %w", err)
	}

	var tok string
	const maxRetries = 5
	for i := 0; i < maxRetries; i++ {
		tok, err = utils.GenerateToken32()
		if err != nil {
			return nil, fmt.Errorf("error generate token: %w", err)
		}

		hashedToken := utils.HashToken(tok)

		var id string
		err = s.db.QueryRow(ctx, `
			INSERT INTO session_tokens (user_id, token_hash, encrypted_session_key, device_id, device_name, created_at, last_used_at, revoked)
			VALUES ($1, $2, $3, $4, $5, NOW(), NOW(), false)
			ON CONFLICT (token_hash) DO NOTHING
			RETURNING id`, user.GetUserId(), hashedToken, encryptedSessionKey, deviceID, deviceName).Scan(&id)

		if err == nil {
			break // Success
		}
		if err != pgx.ErrNoRows {
			return nil, fmt.Errorf("failed to insert session token: %w", err)
		}
		// If pgx.ErrNoRows, it was a collision, so we continue the loop.
	}

	if tok == "" {
		return nil, fmt.Errorf("failed to generate a unique session token after %d retries", maxRetries)
	}

	return &model.AuthResponse{
		Token:      tok,
		User_id:    user.UserId,
		SessionKey: sessionKey,
	}, nil
}

func (s *authService) ValidateToken(ctx context.Context, token string) (string, error) {
	hashed := utils.HashToken(token)
	var tokenData struct {
		UserID              string
		LastUsedAt          time.Time
		Revoked             bool
		EncryptedSessionKey []byte
	}

	query := `
		SELECT user_id, last_used_at, revoked, encrypted_session_key
		FROM session_tokens
		WHERE token_hash = $1
	`
	row := s.db.QueryRow(ctx, query, hashed)
	err := row.Scan(&tokenData.UserID, &tokenData.LastUsedAt, &tokenData.Revoked, &tokenData.EncryptedSessionKey)
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

	// Decrypt the session key to ensure it's valid, fulfilling the requirement to use the key for validation.
	_, err = utils.Decrypt(tokenData.EncryptedSessionKey, []byte(s.sessionConfig.EncryptionKey))
	if err != nil {
		// This could indicate a problem with the session key or a potential attack.
		return "", status.Errorf(codes.Internal, "failed to validate session key: %s", err.Error())
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

func (s *authService) ListSessions(ctx context.Context, userID, currentSessionToken string) ([]*model.Session, error) {
	hashedCurrentToken := utils.HashToken(currentSessionToken)
	rows, err := s.db.Query(ctx, `
        SELECT id, token_hash, device_name, last_used_at, created_at
        FROM session_tokens
        WHERE user_id = $1 AND revoked = false
        ORDER BY last_used_at DESC
    `, userID)
	if err != nil {
		return nil, status.Errorf(codes.Internal, "failed to query sessions: %s", err.Error())
	}
	defer rows.Close()

	var sessions []*model.Session
	for rows.Next() {
		var session model.Session
		var tokenHash string
		var lastUsedAt, createdAt time.Time
		if err := rows.Scan(&session.ID, &tokenHash, &session.DeviceName, &lastUsedAt, &createdAt); err != nil {
			return nil, status.Errorf(codes.Internal, "failed to scan session: %s", err.Error())
		}
		session.IsCurrent = (tokenHash == hashedCurrentToken)
		session.LastUsedAt = lastUsedAt.Format(time.RFC3339)
		session.CreatedAt = createdAt.Format(time.RFC3339)
		sessions = append(sessions, &session)
	}

	return sessions, nil
}

func (s *authService) RevokeSession(ctx context.Context, sessionID, userID string) error {
	cmdTag, err := s.db.Exec(ctx, `
        UPDATE session_tokens
        SET revoked = true
        WHERE id = $1 AND user_id = $2
    `, sessionID, userID)
	if err != nil {
		return status.Errorf(codes.Internal, "failed to revoke session: %s", err.Error())
	}
	if cmdTag.RowsAffected() == 0 {
		return status.Errorf(codes.NotFound, "session not found or permission denied")
	}
	return nil
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