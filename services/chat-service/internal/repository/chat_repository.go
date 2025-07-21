package repository

import (
	"context"
	"fmt"
	"time"

	"github.com/DarkXPixel/Vibe/services/chat-service/internal/model"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type ChatRepository interface {
	CreateChat(ctx context.Context, chat *model.Chat) (*model.Chat, error)
	AddUserChat(ctx context.Context, chatID string, userID string, role string) error
}

func CreateChatRepository(postgresql *pgxpool.Pool) ChatRepository {
	return &chatRepository{postgres: postgresql}
}

type chatRepository struct {
	postgres *pgxpool.Pool
}

func (r *chatRepository) CreateChat(ctx context.Context, chat *model.Chat) (*model.Chat, error) {
	// Валидация типа чата
	validTypes := []string{"private", "group", "channel"}
	if int(chat.Type) > len(validTypes) {
		return nil, fmt.Errorf("error type")
	}
	ctype := validTypes[chat.Type]

	// Начало транзакции
	tx, err := r.postgres.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback(ctx)

	// Вставка чата
	query := `
        INSERT INTO chats (type, title, creator_id, created_at, updated_at)
        VALUES ($1, $2, $3, $4, $4)
        RETURNING id, created_at, updated_at
    `
	now := time.Now()
	err = tx.QueryRow(ctx, query, ctype, chat.Title, chat.CreatorID, now).
		Scan(&chat.ID, &chat.CreatedAt, &chat.UpdatedAt)
	if err != nil {
		return nil, err
	}

	err = r.addUserChatTx(ctx, tx, chat.ID, chat.CreatorID, "owner")
	if err != nil {
		return nil, err
	}

	for _, userID := range chat.UserIds {
		if userID != chat.CreatorID {
			err = r.addUserChatTx(ctx, tx, chat.ID, userID, "member")
			if err != nil {
				return nil, err
			}
		}
	}

	var memberCount int32
	err = tx.QueryRow(ctx, `SELECT COUNT(*) FROM chat_users WHERE chat_id = $1`, chat.ID).Scan(&memberCount)
	if err != nil {
		return nil, err
	}
	chat.MemberCount = memberCount

	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}

	return chat, nil
}

func (r *chatRepository) AddUserChat(ctx context.Context, chatID string, userID string, role string) error {
	tx, err := r.postgres.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	err = r.addUserChatTx(ctx, tx, chatID, userID, role)
	if err != nil {
		return err
	}

	query := `UPDATE chats SET updated_at = $1 WHERE id = $2`
	if _, err := tx.Exec(ctx, query, time.Now(), chatID); err != nil {
		return err
	}

	return tx.Commit(ctx)
}

func (r *chatRepository) addUserChatTx(ctx context.Context, tx pgx.Tx, chatID string, userID string, role string) error {
	query := `
        INSERT INTO chat_users (chat_id, user_id, role, status)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (chat_id, user_id) DO NOTHING
        RETURNING joined_at
    `
	var joinedAt time.Time
	err := tx.QueryRow(ctx, query, chatID, userID, role, "active", time.Now()).Scan(&joinedAt)
	if err == pgx.ErrNoRows {
		return nil
	}
	return err
}
