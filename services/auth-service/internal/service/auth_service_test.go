package service

import (
	"context"
	"testing"
	"time"

	userproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/user"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/mocks"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
	"github.com/alicebob/miniredis/v2"
	"github.com/jackc/pgx/v5"
	"github.com/pashagolub/pgxmock/v2"
	"github.com/stretchr/testify/assert"
	"go.uber.org/mock/gomock"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

// setup is a helper function to create a new authService with mocked dependencies.
func setup(t *testing.T) (AuthService, repository.RedisRepository, *mocks.MockUserClient, pgxmock.PgxPoolIface, *gomock.Controller) {
	ctrl := gomock.NewController(t)
	t.Helper()

	// Mock Redis with miniredis for more realistic behavior
	mr, err := miniredis.Run()
	if err != nil {
		t.Fatalf("an error '%s' was not expected when opening a stub redis connection", err)
	}
	t.Cleanup(mr.Close)

	redisRepo := repository.NewRedisRepository(&config.RedisConfig{
		Host: mr.Host(),
		Port: mr.Port(),
	})

	mockUserClient := mocks.NewMockUserClient(ctrl)
	mockPool, err := pgxmock.NewPool()
	if err != nil {
		t.Fatalf("failed to create mock pool: %v", err)
	}
	t.Cleanup(mockPool.Close)

	jwtConfig := &config.JWTConfig{
		Secret: "test-secret",
	}

	authSvc := NewAuthSevice(redisRepo, jwtConfig, mockPool, mockUserClient)

	return authSvc, redisRepo, mockUserClient, mockPool, ctrl
}

func TestSendCode_Success(t *testing.T) {
	authSvc, redisRepo, _, _, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	phone := "+15551234567"

	token, err := authSvc.SendCode(ctx, phone)

	assert.NoError(t, err)
	assert.NotEmpty(t, token)

	// Verify the code was actually set in miniredis
	code, err := redisRepo.Get(ctx, token)
	assert.NoError(t, err)
	assert.NotEmpty(t, code)
}

func TestSendCode_RateLimited(t *testing.T) {
	authSvc, _, _, _, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	phone := "+15551234567"

	// First call should succeed
	_, err := authSvc.SendCode(ctx, phone)
	assert.NoError(t, err)

	// Second call should be rate limited
	_, err = authSvc.SendCode(ctx, phone)
	assert.Error(t, err)
	st, ok := status.FromError(err)
	assert.True(t, ok)
	assert.Equal(t, codes.ResourceExhausted, st.Code())
}

func TestVerifyCode_Success(t *testing.T) {
	authSvc, redisRepo, mockUserClient, mockPool, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	phone := "+15551234567"
	userID := "test-user-id"
	verificationCode := "123456"

	// 1. Send a code first to get a valid temp token
	tempToken, err := authSvc.SendCode(ctx, phone)
	assert.NoError(t, err)
	// Overwrite the random code with a known one for the test
	err = redisRepo.Set(ctx, tempToken, verificationCode, 5*time.Minute)
	assert.NoError(t, err)

	// 2. Mock dependencies
	mockUserClient.EXPECT().GetOrCreateUser(ctx, phone).Return(&userproto.User{UserId: userID}, nil)
	mockPool.ExpectExec("INSERT INTO refresh_tokens").
		WithArgs(userID, pgxmock.AnyArg(), pgxmock.AnyArg()).
		WillReturnResult(pgxmock.NewResult("INSERT", 1))

	// 3. Verify the code
	authResp, err := authSvc.VerifyCode(ctx, tempToken, verificationCode)

	assert.NoError(t, err)
	assert.NotNil(t, authResp)
	assert.NotEmpty(t, authResp.AccessToken)
	assert.NotEmpty(t, authResp.RefreshToken)
	assert.Equal(t, userID, authResp.UserID)

	// Ensure the temp code is deleted after use
	_, err = redisRepo.Get(ctx, tempToken)
	assert.Error(t, err, "expected temp token to be deleted")
}

func TestVerifyCode_InvalidCode(t *testing.T) {
	authSvc, redisRepo, _, _, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	phone := "+15551234567"
	correctCode := "123456"
	wrongCode := "654321"

	// Send a code first to get a valid temp token
	tempToken, err := authSvc.SendCode(ctx, phone)
	assert.NoError(t, err)
	err = redisRepo.Set(ctx, tempToken, correctCode, 5*time.Minute)
	assert.NoError(t, err)

	// Attempt to verify with the wrong code
	_, err = authSvc.VerifyCode(ctx, tempToken, wrongCode)

	assert.Error(t, err)
	st, ok := status.FromError(err)
	assert.True(t, ok)
	assert.Equal(t, codes.InvalidArgument, st.Code())
}

func TestVerifyCode_BruteForceLockout(t *testing.T) {
	authSvc, redisRepo, _, _, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	phone := "+15551234567"
	correctCode := "123456"
	wrongCode := "654321"
	maxAttempts := 5

	// Send a code first to get a valid temp token
	tempToken, err := authSvc.SendCode(ctx, phone)
	assert.NoError(t, err)
	err = redisRepo.Set(ctx, tempToken, correctCode, 5*time.Minute)
	assert.NoError(t, err)

	// Fail verification `maxAttempts` times
	for i := 0; i < maxAttempts; i++ {
		_, err = authSvc.VerifyCode(ctx, tempToken, wrongCode)
		assert.Error(t, err)
	}

	// The next attempt should fail with a resource exhausted error
	_, err = authSvc.VerifyCode(ctx, tempToken, correctCode)
	assert.Error(t, err)
	st, ok := status.FromError(err)
	assert.True(t, ok)
	assert.Equal(t, codes.ResourceExhausted, st.Code())

	// The original verification code should also be gone
	_, err = redisRepo.Get(ctx, tempToken)
	assert.Error(t, err, "expected temp token to be deleted after lockout")
}

func TestRefreshToken_Success(t *testing.T) {
	authSvc, _, _, mockPool, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	userID := "test-user-id"
	refreshToken := "valid-refresh-token"
	hashedToken := utils.HashToken(refreshToken)

	// Mock the database select for the valid token
	rows := pgxmock.NewRows([]string{"user_id", "expires_at", "revoked"}).
		AddRow(userID, time.Now().Add(24*time.Hour), false)
	mockPool.ExpectQuery("SELECT user_id, expires_at, revoked FROM refresh_tokens").
		WithArgs(hashedToken).
		WillReturnRows(rows)

	// Mock the database update to revoke the old token
	mockPool.ExpectExec("UPDATE refresh_tokens SET revoked = TRUE").
		WithArgs(hashedToken).
		WillReturnResult(pgxmock.NewResult("UPDATE", 1))

	// Mock the database insert for the new rotated token
	mockPool.ExpectExec("INSERT INTO refresh_tokens").
		WithArgs(userID, pgxmock.AnyArg(), pgxmock.AnyArg()).
		WillReturnResult(pgxmock.NewResult("INSERT", 1))

	resp, err := authSvc.RefreshToken(ctx, refreshToken)

	assert.NoError(t, err)
	assert.NotNil(t, resp)
	assert.Equal(t, userID, resp.UserID)
	assert.NotEmpty(t, resp.AccessToken)
	assert.NotEmpty(t, resp.RefreshToken)
	assert.NotEqual(t, refreshToken, resp.RefreshToken, "a new refresh token should be issued")

	// Ensure all expectations were met
	assert.NoError(t, mockPool.ExpectationsWereMet())
}

func TestRefreshToken_InvalidToken(t *testing.T) {
	authSvc, _, _, mockPool, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	invalidToken := "invalid-token"
	hashedToken := utils.HashToken(invalidToken)

	// Mock the database to return no rows
	mockPool.ExpectQuery("SELECT user_id, expires_at, revoked FROM refresh_tokens").
		WithArgs(hashedToken).
		WillReturnError(pgx.ErrNoRows)

	_, err := authSvc.RefreshToken(ctx, invalidToken)

	assert.Error(t, err)
	st, ok := status.FromError(err)
	assert.True(t, ok)
	assert.Equal(t, codes.Unauthenticated, st.Code())
}

func TestRefreshToken_ExpiredToken(t *testing.T) {
	authSvc, _, _, mockPool, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	userID := "test-user-id"
	expiredToken := "expired-token"
	hashedToken := utils.HashToken(expiredToken)

	// Mock the database to return an expired token
	rows := pgxmock.NewRows([]string{"user_id", "expires_at", "revoked"}).
		AddRow(userID, time.Now().Add(-24*time.Hour), false) // Expired yesterday
	mockPool.ExpectQuery("SELECT user_id, expires_at, revoked FROM refresh_tokens").
		WithArgs(hashedToken).
		WillReturnRows(rows)

	_, err := authSvc.RefreshToken(ctx, expiredToken)

	assert.Error(t, err)
	st, ok := status.FromError(err)
	assert.True(t, ok)
	assert.Equal(t, codes.Unauthenticated, st.Code())
}

func TestRefreshToken_RevokedToken(t *testing.T) {
	authSvc, _, _, mockPool, ctrl := setup(t)
	defer ctrl.Finish()

	ctx := context.Background()
	userID := "test-user-id"
	revokedToken := "revoked-token"
	hashedToken := utils.HashToken(revokedToken)

	// Mock the database to return a revoked token
	rows := pgxmock.NewRows([]string{"user_id", "expires_at", "revoked"}).
		AddRow(userID, time.Now().Add(24*time.Hour), true) // Revoked
	mockPool.ExpectQuery("SELECT user_id, expires_at, revoked FROM refresh_tokens").
		WithArgs(hashedToken).
		WillReturnRows(rows)

	_, err := authSvc.RefreshToken(ctx, revokedToken)

	assert.Error(t, err)
	st, ok := status.FromError(err)
	assert.True(t, ok)
	assert.Equal(t, codes.Unauthenticated, st.Code())
}