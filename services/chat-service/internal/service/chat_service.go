package service

import (
	"context"
	//"time"

	protoChat "github.com/DarkXPixel/Vibe/proto/chat"
	//"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
)

type ChatService interface {
}

type chatService struct {
}

func NewChatService() ChatService {
	return &chatService{}
}

func (c *chatService) CreateChat(ctx context.Context, req *protoChat.CreateChatRequest) (*protoChat.Chat, error) {
	// chat := &model.Chat{
	// 	Type: req.Type.String(),
	// 	Title: req.Title,
	// 	CreateID: req.CreatorId,
	// 	CreatedAt: time.Now().UTC(),
	// }

	return nil, nil

}
