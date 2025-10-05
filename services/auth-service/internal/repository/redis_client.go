package repository

import (
	"context"
	"fmt"
	"time"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/redis/go-redis/v9"
)

type RedisRepository interface {
	PingRedis(ctx context.Context) error
	GetClient() *redis.Client
	Set(ctx context.Context, key, value string, ttl time.Duration) error
	Get(ctx context.Context, key string) (string, error)
	Del(ctx context.Context, key string) error
}

type redisRepository struct {
	redisClient *redis.Client
	conf        *config.RedisConfig
}

func NewRedisRepository(conf *config.RedisConfig) RedisRepository {
	redisClient := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%s", conf.Host, conf.Port),
		Password: conf.Passowrd,
		DB:       0,
	})

	return &redisRepository{
		conf:        conf,
		redisClient: redisClient,
	}
}

func (s *redisRepository) GetClient() *redis.Client {
	return s.redisClient
}

func (s *redisRepository) Get(ctx context.Context, key string) (string, error) {
	return s.redisClient.Get(ctx, key).Result()
}
func (s *redisRepository) Set(ctx context.Context, key, value string, ttl time.Duration) error {
	return s.redisClient.Set(ctx, key, value, ttl).Err()
}

func (s *redisRepository) Del(ctx context.Context, key string) error {
	return s.redisClient.Del(ctx, key).Err()
}

func (s *redisRepository) PingRedis(ctx context.Context) error {
	return s.redisClient.Ping(ctx).Err()
}
