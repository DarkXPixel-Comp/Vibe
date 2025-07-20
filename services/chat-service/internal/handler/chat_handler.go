package handler

import (
	"context"

	protoChat "github.com/DarkXPixel/Vibe/proto/chat"
)

type ChatHandler struct {
	protoChat.UnimplementedChatServiceServer
}

func NewChatHandler() *ChatHandler {
	return &ChatHandler{}
}

func (h *ChatHandler) CreateChat(ctx context.Context, req *protoChat.CreateChatRequest) (*protoChat.CreateChatResponse, error) {
	return nil, nil
}
