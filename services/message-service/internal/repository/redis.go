package repository

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/DarkXPixel/Vibe/services/message-service/internal/config"
	"github.com/redis/go-redis/v9"
)

type RedisRepository interface {
	GetPts(ctx context.Context, userID string) (int64, error)
	SetPts(ctx context.Context, userID string, pts int64) error
	RateLimit(ctx context.Context, userID string, limit int) (bool, error)
	Close() error
}

type redisRepository struct {
	client *redis.Client
}

func NewRedisRepository(cfg *config.RedisConfig) (RedisRepository, error) {
	client := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", cfg.Host, cfg.Port),
		Password: cfg.Password,
		DB:       cfg.DB,
	})
	_, err := client.Ping(context.Background()).Result()
	if err != nil {
		return nil, fmt.Errorf("failed to connect to Redis: %w", err)
	}
	return &redisRepository{client: client}, nil
}

func (r *redisRepository) GetPts(ctx context.Context, userID string) (int64, error) {
	key := fmt.Sprintf("user_pts:%s", userID)
	val, err := r.client.Get(ctx, key).Result()
	if err == redis.Nil {
		return -1, nil
	}

	pts, err := strconv.ParseInt(val, 10, 64)
	if err != nil {
		return -1, fmt.Errorf("failed to parse pts form redis: %w", err)
	}
	return pts, nil
}

func (r *redisRepository) SetPts(ctx context.Context, userID string, pts int64) error {
	key := fmt.Sprintf("user_pts:%s", userID)
	err := r.client.Set(ctx, key, pts, 24*time.Hour)
	if err != nil {
		return fmt.Errorf("failed to set pts in redis: %w", err)
	}
	return nil
}

func (r *redisRepository) RateLimit(ctx context.Context, userID string, limit int) (bool, error) {
	key := fmt.Sprintf("rate_limit:%s", userID)
	count, err := r.client.Incr(ctx, key).Result()
	if err != nil {
		return false, fmt.Errorf("failed to increment rate limit in redis: %w", err)
	}
	if count == 1 {
		err = r.client.Expire(ctx, key, time.Second).Err()
		if err != nil {
			return false, fmt.Errorf("failed to set ttl for rate limit")
		}
	}

	allowed := count <= int64(limit)
	return allowed, nil
}

func (r *redisRepository) Close() error {
	if err := r.client.Close(); err != nil {
		return fmt.Errorf("failed to close redis connection: %w", err)
	}
	return nil
}
