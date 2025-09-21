package service

import (
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/repository"
)

type SyncService interface {
}

type syncService struct {
	repo *repository.SyncRepository
	cfg  *config.Config
}

func NewSyncService() SyncService {
	return &syncService{}
}
