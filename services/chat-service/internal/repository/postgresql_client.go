package repository

import (
	"context"
	"fmt"
	"time"

	"github.com/DarkXPixel/Vibe/services/chat-service/internal/config"
	"github.com/jackc/pgx/v5/pgxpool"
)

func ConnectDB(config *config.PostgresqlConfig) (*pgxpool.Pool, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	dbStr := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=%s",
		config.User, config.Password, config.Host, config.Port, config.DBName, config.SSLMode)

	pool, err := pgxpool.New(ctx, dbStr)
	if err != nil {
		return nil, fmt.Errorf("failed to connect postgres: %w", err)
	}

	return pool, nil
}
