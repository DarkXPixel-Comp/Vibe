package handler

import (
	"context"
	"time"

	chatgrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/chat/chatgrpc"
	chatproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/chat"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/service"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type ChatGRPCHandler struct {
	chatgrpc.UnimplementedChatServiceServer
	chatService *service.ChatService
}

func NewChatGRPCHandler(chatService *service.ChatService) *ChatGRPCHandler {
	return &ChatGRPCHandler{
		chatService: chatService,
	}
}

func (h *ChatGRPCHandler) CreateChat(ctx context.Context, req *chatproto.CreateChatRequest) (*chatproto.CreateChatResponse, error) {
	md, ok := metadata.FromIncomingContext(ctx)

	if !ok {
		return nil, status.Error(codes.Unauthenticated, "missing metadata")
	}
	values := md.Get("x-user-id")
	if len(values) == 0 {
		return nil, status.Error(codes.Unauthenticated, "missing x-user-id in metadata")
	}

	callerID := values[0]
	if callerID == "" {
		return nil, status.Error(codes.Unauthenticated, "empty x-user-id in metadata")
	}
	var ct model.ChatType
	switch req.Type {
	case chatproto.ChatType_PRIVATE:
		ct = model.ChatTypePrivate
	case chatproto.ChatType_GROUP:
		ct = model.ChatTypeGroup
	case chatproto.ChatType_CHANNEL:
		ct = model.ChatTypeChannel
	default:
		return nil, status.Error(codes.InvalidArgument, "invalid chat type")
	}

	params := model.CreateChatParams{
		CallerUserID: callerID,
		Type:         ct,
		Title:        nilIfEmpty(req.Title),
		Description:  nil,
		UserIDs:      req.UserIds,
	}
	chat, svcErr := h.chatService.CreateChat(ctx, params)
	if svcErr != nil {
		return nil, svcErr
	}

	return &chatproto.CreateChatResponse{
		Success: true,
		Chat: &chatproto.Chat{
			Id:             chat.ID,
			Type:           req.GetType(),
			Title:          strOrEmpty(chat.Title),
			CreatedAt:      chat.CreatedAt.UTC().Format(time.RFC3339),
			LastActivityAt: chat.LastActivity.UTC().Format(time.RFC3339),
		},
	}, nil

}

func nilIfEmpty(s string) *string {
	if s == "" {
		return nil
	}
	return &s
}

func strOrEmpty(p *string) string {
	if p == nil {
		return ""
	}
	return *p
}
