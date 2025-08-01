package service

import (
	"context"
	"fmt"

	//"time"

	"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/utils"
	//"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
)

type ChatService interface {
	CreateChat(ctx context.Context, chatType model.ChatType, title string, creatorId string, userIds []string) (*model.Chat, error)
}

type chatService struct {
	chatRepository repository.ChatRepository
}

func NewChatService() ChatService {
	return &chatService{}
}

func (c *chatService) CreateChat(ctx context.Context, chatType model.ChatType, title string, creatorId string, userIds []string,
) (*model.Chat, error) {
	if !utils.Contains(userIds, creatorId) {
		return nil, fmt.Errorf("chat must have creatorId")
	}

	if chatType == model.ChatType_PRIVATE {
		if len(userIds) != 2 || userIds[0] != creatorId {
			return nil, fmt.Errorf("private chat can have only 2 user")
		}
		title = ""
	}

	chat := &model.Chat{
		Type:      chatType,
		Title:     title,
		CreatorID: creatorId,
		UserIds:   userIds,
	}

	_, err := c.chatRepository.CreateChat(ctx, chat)
	if err != nil {
		return nil, fmt.Errorf("error create chat: %w", err)
	}

	return chat, nil
}
