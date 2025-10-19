package database

import (
	"context"
	"fmt"
	"time"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/jackc/pgx/v5/pgxpool"
)

func ConnectDB(dbConfig config.DBConfig) (*pgxpool.Pool, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	dbStr := fmt.Sprintf("postgres://%s:%s@%s:%s/%s?sslmode=%s",
		dbConfig.User, dbConfig.Password, dbConfig.Host, dbConfig.Port, dbConfig.DBName, dbConfig.SSLMode)

	pool, err := pgxpool.New(ctx, dbStr)
	if err != nil {
		return nil, fmt.Errorf("failed to connect db: %w", err)
	}

	if err := pool.Ping(ctx); err != nil {
		return nil, fmt.Errorf("failed to ping db: %w", err)
	}

	return pool, err
}
