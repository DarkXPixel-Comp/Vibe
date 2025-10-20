package service

import (
	"context"

	//"time"

	"github.com/DarkXPixel/Vibe/services/chat-service/internal/errors"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/repository"
	//"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
)

type ChatService struct {
	chatRepo *repository.ChatRepository
}

func NewChatService(chatRepo *repository.ChatRepository) *ChatService {
	return &ChatService{
		chatRepo: chatRepo,
	}
}

func (s *ChatService) CreateChat(ctx context.Context, p model.CreateChatParams) (*model.Chat, error) {
	switch p.Type {
	case model.ChatTypePrivate, model.ChatTypeGroup, model.ChatTypeChannel:
	default:
		return nil, errors.ErrInvalidChatType
	}
	// defaultRole := "member"

	var roles = make(map[string]string)

	switch p.Type {
	case model.ChatTypePrivate:
		if len(p.UserIDs) != 1 {
			return nil, errors.ErrInvalidUserCountForPrivateChat
		}
		peer := p.UserIDs[0]
		if peer == p.CallerUserID {
			return nil, errors.ErrCannotCreatePrivateChatWithSelf
		}

		exists, err := s.chatRepo.ExistsPrivatePair(ctx, p.CallerUserID, peer)
		if err != nil {
			return nil, err
		}
		if exists {
			return nil, errors.ErrPrivateChatAlreadyExists
		}
		roles[p.CallerUserID] = "member"
		roles[peer] = "member"

	case model.ChatTypeGroup:
		for _, uid := range p.UserIDs {
			roles[uid] = "member"
		}
		roles[p.CallerUserID] = "owner"
	case model.ChatTypeChannel:
		for _, uid := range p.UserIDs {
			roles[uid] = "member"
		}
		roles[p.CallerUserID] = "owner"
	}

	tx, err := s.chatRepo.BeginTx(ctx)
	if err != nil {
		return nil, err
	}

	defer tx.Rollback(ctx)

	var chatId string
	if chatId, err = s.chatRepo.InsertChat(ctx, tx, string(p.Type), p.Title, p.Description); err != nil {
		return nil, err
	}

	if err := s.chatRepo.InsertMemberships(ctx, tx, chatId, roles); err != nil {
		return nil, err
	}

	if p.Type == model.ChatTypePrivate {
		if err := s.chatRepo.InsertPrivatePair(ctx, tx, repository.CreatePrivatePairParams{
			ChatID:  chatId,
			UserAID: p.CallerUserID,
			UserBID: p.UserIDs[0],
		}); err != nil {
			return nil, err
		}
	}

	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}

	row, err := s.chatRepo.GetChatByID(ctx, chatId)
	if err != nil {
		return nil, err
	}

	return &model.Chat{
		ID:           row.ID,
		Type:         model.ChatType(row.Type),
		Title:        row.Title,
		Description:  row.Description,
		CreatedAt:    row.CreatedAt,
		LastActivity: row.LastActivityAt,
	}, nil
}
