package service

import (
	"context"
	"fmt"

	"github.com/DarkXPixel/Vibe/services/message-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/message-service/internal/repository"
)

type MessageService interface {
	GetState(ctx context.Context, userID string) (int64, error)
}

type messageService struct {
	repo      repository.MessageRepository
	cfg       *config.Config
	redisRepo repository.RedisRepository
}

func NewMessageService(cfg *config.Config, repo repository.MessageRepository, redisRepo repository.RedisRepository) MessageService {
	return &messageService{cfg: cfg, repo: repo}
}

func (s *messageService) GetState(ctx context.Context, userID string) (int64, error) {
	pts, err := s.redisRepo.GetPts(ctx, userID)
	if err == nil && pts >= 0 {
		return pts, nil
	}

	pts, err = s.repo.GetState(ctx, userID)
	if err != nil {
		return -1, fmt.Errorf("error getState: %w", err)
	}
	s.redisRepo.SetPts(ctx, userID, pts)
	return pts, nil
}
