package handler

import (
	"context"
	"time"

	protoChat "github.com/DarkXPixel/Vibe/proto/chat"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/service"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ChatHandler struct {
	protoChat.UnimplementedChatServiceServer
	chatService service.ChatService
}

func NewChatHandler() *ChatHandler {
	return &ChatHandler{}
}

func (h *ChatHandler) CreateChat(ctx context.Context, req *protoChat.CreateChatRequest) (*protoChat.CreateChatResponse, error) {
	if req.GetCreatorId() != ctx.Value("user_id") {
		return nil, status.Error(codes.PermissionDenied, "you can create chat only for you")
	}

	chat, err := h.chatService.CreateChat(ctx, model.ChatType(req.GetType()), req.GetTitle(), req.GetCreatorId(), req.GetUserIds())
	if err != nil {
		return &protoChat.CreateChatResponse{
			Success:      false,
			ErrorMessage: err.Error(),
		}, nil
	}

	return &protoChat.CreateChatResponse{
		Success: true,
		Chat: &protoChat.Chat{
			Id:          chat.ID,
			Type:        protoChat.ChatType(chat.Type),
			Title:       chat.Title,
			CreatorId:   chat.CreatorID,
			CreatedAt:   chat.CreatedAt.Format(time.RFC3339),
			UpdatedAt:   chat.UpdatedAt.Format(time.RFC3339),
			UserIds:     chat.UserIds,
			MemberCount: chat.MemberCount,
		},
	}, nil
}
