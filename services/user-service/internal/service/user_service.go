package service

import (
	"context"
	"errors"

	"github.com/DarkXPixel/Vibe/services/user-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/repository"
	"github.com/jackc/pgx/v5"
)

type UserService interface {
	GetOrCreateUser(ctx context.Context, phone string) (*model.User, error)
}

type userService struct {
	repo repository.UserRepository
}

func NewUserService(repo repository.UserRepository) UserService {
	return &userService{
		repo: repo,
	}
}

func (s *userService) GetOrCreateUser(ctx context.Context, phone string) (*model.User, error) {
	user, err := s.repo.GetUserByPhone(ctx, phone)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return s.repo.CreateUser(ctx, phone)
		}
		return nil, err
	}

	return user, nil
}
