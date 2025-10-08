package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
)

type Redis struct {
	C *redis.Client
}

func NewRedis(addr, password string, db int) *Redis {
	return &Redis{
		C: redis.NewClient(&redis.Options{
			Addr:     addr,
			Password: password,
			DB:       db,
		}),
	}
}

type OTPChallenge struct {
	Phone    string `json:"phone"`
	OTPHash  string `json:"otp_hash"`
	Attempts int    `json:"attempts"`
}

func (r *Redis) SetOTPChallengeData(ctx context.Context, challengeID string, data OTPChallenge, ttl time.Duration) error {
	b, _ := json.Marshal(data)
	return r.C.Set(ctx, "otp:challenge:"+challengeID, b, ttl).Err()
}

func (r *Redis) GetOTPChallengeData(ctx context.Context, challengeID string) (*OTPChallenge, error) {
	val, err := r.C.Get(ctx, "otp:challenge:"+challengeID).Result()
	if err != nil {
		return nil, err
	}
	var data OTPChallenge
	if err := json.Unmarshal([]byte(val), &data); err != nil {
		return nil, err
	}
	return &data, nil
}

func (r *Redis) DelOTPChallenge(ctx context.Context, challengeID string) error {
	return r.C.Del(ctx, "otp:challenge:"+challengeID).Err()
}

func (r *Redis) UpdateOTPAttempts(ctx context.Context, challengeID string, attempts int) error {
	key := "otp:challenge:" + challengeID
	ttl := r.C.TTL(ctx, key).Val()
	val, err := r.C.Get(ctx, key).Result()
	if err != nil {
		return err
	}
	var data OTPChallenge
	if err := json.Unmarshal([]byte(val), &data); err != nil {
		return err
	}
	data.Attempts = attempts
	b, _ := json.Marshal(data)
	return r.C.Set(ctx, key, b, ttl).Err()
}

// Deny-list
func (r *Redis) DenyAuthKey(ctx context.Context, authKeyID uint64, ttl time.Duration) error {
	return r.C.Set(ctx, fmt.Sprintf("deny:authkey:%d", authKeyID), "1", ttl).Err()
}
func (r *Redis) IsDeniedAuthKey(ctx context.Context, authKeyID uint64) (bool, error) {
	val, err := r.C.Get(ctx, fmt.Sprintf("deny:authkey:%d", authKeyID)).Result()
	if err == redis.Nil {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return val == "1", nil
}

// Anti-replay nonce
func (r *Redis) RememberNonce(ctx context.Context, sessionUUID string, nonce []byte, ttl time.Duration) (bool, error) {
	return r.C.SetNX(ctx, fmt.Sprintf("nonce:%s:%x", sessionUUID, nonce), "1", ttl).Result()
}

// Rate limit: phone/IP sliding window
func (r *Redis) AllowPhone(ctx context.Context, phone string, limit int, window time.Duration) (bool, error) {
	key := fmt.Sprintf("rl:phone:%s", phone)
	pipe := r.C.TxPipeline()
	incr := pipe.Incr(ctx, key)
	pipe.Expire(ctx, key, window)
	if _, err := pipe.Exec(ctx); err != nil {
		return false, err
	}
	return int(incr.Val()) <= limit, nil
}
func (r *Redis) AllowIP(ctx context.Context, ip string, limit int, window time.Duration) (bool, error) {
	key := fmt.Sprintf("rl:ip:%s", ip)
	pipe := r.C.TxPipeline()
	incr := pipe.Incr(ctx, key)
	pipe.Expire(ctx, key, window)
	if _, err := pipe.Exec(ctx); err != nil {
		return false, err
	}
	return int(incr.Val()) <= limit, nil
}
