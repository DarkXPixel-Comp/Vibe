package handler

import (
	protoSync "github.com/DarkXPixel/Vibe/proto/sync"
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/service"
)

type SyncHandler struct {
	protoSync.UnimplementedSyncServiceServer
	syncService service.SyncService
}

func NewSyncHandler(syncService service.SyncService) *SyncHandler {
	return &SyncHandler{
		syncService: syncService,
	}
}
