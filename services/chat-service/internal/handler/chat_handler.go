package handler

import (
	"context"
	"time"

	chatgrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/chat/chatgrpc"
	chatproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/chat"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/service"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type ChatHandler struct {
	chatgrpc.UnimplementedChatServiceServer
	chatService service.ChatService
}

func NewChatHandler(chatService service.ChatService) *ChatHandler {
	return &ChatHandler{
		chatService: chatService,
	}
}

func (h *ChatHandler) CreateChat(ctx context.Context, req *chatproto.CreateChatRequest) (*chatproto.CreateChatResponse, error) {
	if req.GetCreatorId() != ctx.Value("user_id") {
		return nil, status.Error(codes.PermissionDenied, "you can create chat only for you")
	}

	chat, err := h.chatService.CreateChat(ctx, model.ChatType(req.GetType()), req.GetTitle(), req.GetCreatorId(), req.GetUserIds())
	if err != nil {
		return &chatproto.CreateChatResponse{
			Success:      false,
			ErrorMessage: err.Error(),
		}, nil
	}

	return &chatproto.CreateChatResponse{
		Success: true,
		Chat: &chatproto.Chat{
			Id:          chat.ID,
			Type:        chatproto.ChatType(chat.Type),
			Title:       chat.Title,
			CreatorId:   chat.CreatorID,
			CreatedAt:   chat.CreatedAt.Format(time.RFC3339),
			UpdatedAt:   chat.UpdatedAt.Format(time.RFC3339),
			UserIds:     chat.UserIds,
			MemberCount: chat.MemberCount,
		},
	}, nil
}

func (h *ChatHandler) GetChats(ctx context.Context, req *chatproto.GetChatsRequest) (*chatproto.GetChatsResponse, error) {
	if req.GetUserId() != ctx.Value("user_id") {
		return nil, status.Error(codes.PermissionDenied, "you can get chats only for you")
	}

	chats, err := h.chatService.GetChats(ctx, req.GetUserId())

	if err != nil {
		return nil, status.Error(codes.NotFound, "error get chats")
	}

	var protoChats []*chatproto.Chat
	for _, chat := range chats {
		protoChats = append(protoChats, &chatproto.Chat{
			Id:          chat.ID,
			Type:        chatproto.ChatType(chat.Type),
			Title:       chat.Title,
			CreatorId:   chat.CreatorID,
			CreatedAt:   chat.CreatedAt.Format(time.RFC3339),
			UpdatedAt:   chat.UpdatedAt.Format(time.RFC3339),
			UserIds:     chat.UserIds,
			MemberCount: chat.MemberCount,
		})
	}

	return &chatproto.GetChatsResponse{
		Chats: protoChats,
	}, nil
}
