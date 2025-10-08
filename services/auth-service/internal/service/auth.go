package service

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"net"
	"time"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
)

type AuthService struct {
	PG                    *repository.Postgres
	Redis                 *repository.Redis
	Now                   func() time.Time
	ServerPriv, ServerPub []byte

	UserClient UserServiceClient

	MaxOTPAttempts int
	StartPerPhone  int
	StartPerIP     int
	Window         time.Duration
}

type UserServiceClient interface {
	ResolveUserByPhone(ctx context.Context, phone string) (string /*userUUID*/, error)
}

func NewAuthService(pg *repository.Postgres, r *repository.Redis, priv, pub []byte, uc UserServiceClient) *AuthService {
	return &AuthService{PG: pg, Redis: r, ServerPriv: priv, ServerPub: pub, UserClient: uc,
		MaxOTPAttempts: 5, StartPerPhone: 5, StartPerIP: 20, Window: 10 * time.Minute}
}

func (s *AuthService) SendVerificationCode(ctx context.Context, phone, ip string) (string, int32, string, error) {
	ok, err := s.Redis.AllowPhone(ctx, phone, s.StartPerPhone, s.Window)
	if err != nil {
		return "", 0, "", err
	}
	if !ok {
		return "", 0, "", fmt.Errorf("rate limit phone")
	}
	if ip != "" {
		if p := net.ParseIP(ip); p != nil {
			okIP, err := s.Redis.AllowIP(ctx, ip, s.StartPerIP, s.Window)
			if err != nil {
				return "", 0, "", err
			}
			if !okIP {
				return "", 0, "", fmt.Errorf("rate limit ip")
			}
		}
	}

	chID, err := utils.NewUUIDv4()
	if err != nil {
		return "", 0, "", err
	}
	otp := utils.RandOTP()
	h := sha256.Sum256([]byte(otp))
	data := repository.OTPChallenge{Phone: phone, OTPHash: hex.EncodeToString(h[:]), Attempts: 0}
	if err := s.Redis.SetOTPChallengeData(ctx, chID, data, 5*time.Minute); err != nil {
		return "", 0, "", err
	}
	return chID, 30, otp, nil
}

func (s *AuthService) VerifyCode(ctx context.Context, challengeID, phone, otp, deviceName, devicePlatform string, devicePub []byte) (userUUID, deviceUUID string, authKeyID uint64, sessionUUID string, salt uint64, srvPub []byte, err error) {
	data, err := s.Redis.GetOTPChallengeData(ctx, challengeID)

	if err != nil {
		return "", "", 0, "", 0, nil, fmt.Errorf("challenge not found or expired")
	}

	if data.Phone != phone {
		return "", "", 0, "", 0, nil, fmt.Errorf("phone mismatch")
	}
	if data.Attempts >= s.MaxOTPAttempts {
		return "", "", 0, "", 0, nil, fmt.Errorf("too many attempts")
	}

	h := sha256.Sum256([]byte(otp))
	if hex.EncodeToString(h[:]) != data.OTPHash {
		_ = s.Redis.UpdateOTPAttempts(ctx, challengeID, data.Attempts+1)
		return "", "", 0, "", 0, nil, fmt.Errorf("invalid otp")
	}

	_ = s.Redis.DelOTPChallenge(ctx, challengeID)
	userUUID, err = s.UserClient.ResolveUserByPhone(ctx, phone)
	if err != nil {
		return "", "", 0, "", 0, nil, err
	}

	shared, err := utils.ECDH_X25519(s.ServerPriv, devicePub)
	if err != nil {
		return "", "", 0, "", 0, nil, err
	}
	authKey, err := utils.HKDF_SHA256(shared, []byte(challengeID), []byte("mt/auth_key"), 32)
	authKeyID = utils.AuthKeyID(authKey)
	salt, err = utils.RandUint64()
	if err != nil {
		return "", "", 0, "", 0, nil, err
	}

	deviceUUID, err = utils.NewUUIDv4()
	if err != nil {
		return "", "", 0, "", 0, nil, err
	}

	sessionUUID, err = utils.NewUUIDv4()
	if err != nil {
		return "", "", 0, "", 0, nil, err
	}

	err = s.PG.CreateDeviceAuthKeySession(ctx, userUUID, deviceUUID, sessionUUID, devicePlatform, deviceName, authKeyID, authKey, salt, "chacha20-poly1305", nil)
	if err != nil {
		return "", "", 0, "", 0, nil, err
	}

	return userUUID, deviceUUID, authKeyID, sessionUUID, salt, s.ServerPub, nil
}

func (s *AuthService) ValidateToken(ctx context.Context, authKeyID uint64, sessionUUID string) (*model.TokenValidation, error) {
	denied, err := s.Redis.IsDeniedAuthKey(ctx, authKeyID)
	if err != nil {
		return nil, err
	}
	if denied {
		return &model.TokenValidation{
			Valid:  false,
			Status: "revoked",
		}, nil
	}

	sess, err := s.PG.GetSession(ctx, authKeyID, sessionUUID)
	if err != nil {
		return nil, err
	}

	return &model.TokenValidation{
		Valid:          sess.Status == "active",
		UserUUID:       sess.UserID,
		Status:         sess.Status,
		DevicePlatform: sess.DevicePlatform,
		DeviceName:     sess.DeviceName,
		LastSeen:       sess.LastSeen,
	}, nil
}
