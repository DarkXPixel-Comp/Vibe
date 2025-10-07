package service

import (
	"context"
	"testing"
	"time"

	"github.com/DarkXPixel/Vibe/proto/user"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
	"github.com/alicebob/miniredis/v2"
	"github.com/pashagolub/pgxmock/v3"
	"github.com/redis/go-redis/v9"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// MockUserClient is a mock implementation of the UserClientInterface.
type MockUserClient struct {
	User    *user.User
	Err     error
	Phone   string
	Context context.Context
}

func (m *MockUserClient) GetOrCreateUser(ctx context.Context, phone string) (*user.User, error) {
	m.Context = ctx
	m.Phone = phone
	if m.Err != nil {
		return nil, m.Err
	}
	return m.User, nil
}

func setup(t *testing.T) (
	authService AuthService,
	mock pgxmock.PgxPoolIface,
	miniRedis *miniredis.Miniredis,
	mockUserClient *MockUserClient,
) {
	mock, err := pgxmock.NewPool()
	require.NoError(t, err)

	mr, err := miniredis.Run()
	require.NoError(t, err)

	redisClient := redis.NewClient(&redis.Options{
		Addr: mr.Addr(),
	})

	redisRepo := repository.NewRedisRepositoryWithClient(redisClient)

	mockUserClient = &MockUserClient{}

	jwtConfig := &config.JWTConfig{
		Secret: "test-secret",
	}

	sessionConfig := &config.SessionConfig{
		EncryptionKey: "12345678901234567890123456789012",
	}

	authService = NewAuthSevice(redisRepo, jwtConfig, sessionConfig, mock, mockUserClient)

	return authService, mock, mr, mockUserClient
}

func TestAuthService_VerifyCode(t *testing.T) {
	s, mock, miniRedis, mockUserClient := setup(t)

	ctx := context.Background()
	phone := "+1234567890"
	code := "123456"
	deviceID := "test-device-id"
	deviceName := "test-device"
	userID := "a-valid-user-id"

	// 1. Generate a valid JWT token for the test
	jwtToken, err := utils.GenerateAuthJWTToken(phone, "test-secret", 5*time.Minute)
	require.NoError(t, err)

	// 2. Set the verification code in Redis
	err = miniRedis.Set(jwtToken, code)
	require.NoError(t, err)
	miniRedis.SetTTL(jwtToken, 5*time.Minute)

	// 3. Mock the GetOrCreateUser call
	mockUserClient.User = &user.User{UserId: userID}
	mockUserClient.Err = nil

	// 4. Mock the database insertion
	mock.ExpectQuery(`INSERT INTO session_tokens`).
		WithArgs(userID, pgxmock.AnyArg(), pgxmock.AnyArg(), deviceID, deviceName).
		WillReturnRows(pgxmock.NewRows([]string{"id"}).AddRow("new-session-id"))

	// 5. Call the method
	resp, err := s.VerifyCode(ctx, jwtToken, code, deviceID, deviceName)

	// 6. Assert the results
	require.NoError(t, err)
	assert.NotNil(t, resp)
	assert.Equal(t, userID, resp.User_id)
	assert.NotEmpty(t, resp.Token)
	assert.NotEmpty(t, resp.SessionKey)

	// Ensure all expectations were met
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestAuthService_ListSessions(t *testing.T) {
	s, mock, _, _ := setup(t)

	ctx := context.Background()
	userID := "a-valid-user-id"
	currentToken := "current-session-token"

	rows := pgxmock.NewRows([]string{"id", "token_hash", "device_name", "last_used_at", "created_at"}).
		AddRow("session1", utils.HashToken("some-other-token"), "Device 1", time.Now(), time.Now().Add(-24*time.Hour)).
		AddRow("session2", utils.HashToken(currentToken), "Device 2", time.Now().Add(-48*time.Hour), time.Now().Add(-72*time.Hour))

	mock.ExpectQuery(`SELECT id, token_hash, device_name, last_used_at, created_at`).
		WithArgs(userID).
		WillReturnRows(rows)

	sessions, err := s.ListSessions(ctx, userID, currentToken)

	require.NoError(t, err)
	assert.Len(t, sessions, 2)
	assert.Equal(t, "session1", sessions[0].ID)
	assert.False(t, sessions[0].IsCurrent)
	assert.Equal(t, "session2", sessions[1].ID)
	assert.True(t, sessions[1].IsCurrent)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestAuthService_RevokeSession(t *testing.T) {
	s, mock, _, _ := setup(t)

	ctx := context.Background()
	sessionID := "session-to-revoke"
	userID := "a-valid-user-id"

	mock.ExpectExec(`UPDATE session_tokens SET revoked = true WHERE id = \$1 AND user_id = \$2`).
		WithArgs(sessionID, userID).
		WillReturnResult(pgxmock.NewResult("UPDATE", 1))

	err := s.RevokeSession(ctx, sessionID, userID)

	require.NoError(t, err)
	assert.NoError(t, mock.ExpectationsWereMet())
}

func TestAuthService_RevokeSession_NotFound(t *testing.T) {
	s, mock, _, _ := setup(t)

	ctx := context.Background()
	sessionID := "non-existent-session"
	userID := "a-valid-user-id"

	mock.ExpectExec(`UPDATE session_tokens`).
		WithArgs(sessionID, userID).
		WillReturnResult(pgxmock.NewResult("UPDATE", 0))

	err := s.RevokeSession(ctx, sessionID, userID)

	require.Error(t, err)
	assert.Contains(t, err.Error(), "session not found or permission denied")
	assert.NoError(t, mock.ExpectationsWereMet())
}