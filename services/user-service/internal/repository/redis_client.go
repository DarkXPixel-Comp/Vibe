package repository

import "github.com/redis/go-redis/v9"

type RedisRepository interface {
}

type redisRepository struct {
	redisClient *redis.Client
}

func NewRedisRepository() RedisRepository {
	redisClient := redis.NewClient(&redis.Options{})

	return &redisRepository{
		redisClient: redisClient,
	}
}
