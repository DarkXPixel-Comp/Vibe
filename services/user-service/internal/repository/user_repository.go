package repository

import (
	"context"
	"database/sql"

	"github.com/DarkXPixel/Vibe/services/user-service/internal/model"
	"github.com/jackc/pgx/v5/pgxpool"
)

type UserRepository interface {
	GetUserByPhone(ctx context.Context, phone string) (*model.User, error)
	CreateUser(ctx context.Context, phone string) (*model.User, error)
}

type userRepository struct {
	postgres *pgxpool.Pool
}

func NewUserRepository(postgres *pgxpool.Pool) UserRepository {
	return &userRepository{
		postgres: postgres,
	}
}

func (r *userRepository) GetUserByPhone(ctx context.Context, phone string) (*model.User, error) {
	user := &model.User{}
	var userName sql.NullString

	query := `
		SELECT user_id, phone, user_name, created_at, updated_at
		FROM users WHERE phone = $1
	`
	err := r.postgres.QueryRow(ctx, query, phone).Scan(&user.UserID, &user.Phone, &userName, &user.Created_at, &user.Updated_at)
	if err != nil {
		return nil, err
	}

	if userName.Valid {
		user.UserName = userName.String
	} else {
		user.UserName = ""
	}

	return user, nil
}

func (r *userRepository) CreateUser(ctx context.Context, phone string) (*model.User, error) {
	user := &model.User{
		Phone:    phone,
		UserName: "",
	}

	query := `
		INSERT INTO users (phone, user_name)
		VALUES ($1, NULLIF($2, ''))
		RETURNING user_id, created_at, updated_at	
	`
	err := r.postgres.QueryRow(ctx, query, user.Phone, user.UserName).Scan(&user.UserID, &user.Created_at, &user.Updated_at)
	if err != nil {
		return nil, err
	}

	return user, nil
}
