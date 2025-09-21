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
	GetChats(ctx context.Context, userId string) ([]model.Chat, error)
}

func CreateChatRepository(postgresql *pgxpool.Pool) ChatRepository {
	return &chatRepository{postgres: postgresql}
}

type chatRepository struct {
	postgres *pgxpool.Pool
}

func (r *chatRepository) CreateChat(ctx context.Context, chat *model.Chat) (*model.Chat, error) {
	validTypes := []string{"private", "group", "channel"}
	if int(chat.Type) > len(validTypes) {
		return nil, fmt.Errorf("error type")
	}
	ctype := validTypes[chat.Type]

	tx, err := r.postgres.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback(ctx)

	// Вставка чата
	query := `
        INSERT INTO chats (type, title, creator_id)
        VALUES ($1, $2, $3)
        RETURNING id, created_at, updated_at
    `

	err = tx.QueryRow(ctx, query, ctype, chat.Title, chat.CreatorID).
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
	err := tx.QueryRow(ctx, query, chatID, userID, role, "active").Scan(&joinedAt)
	if err == pgx.ErrNoRows {
		return nil
	}
	return err
}

func (r *chatRepository) GetChats(ctx context.Context, userId string) ([]model.Chat, error) {
	query := `
		SELECT 
		c.id,
		c.type,
		c.title,
		c.creator_id,
		c.created_at,
		c.updated_at,
		ARRAY_AGG(cu2.user_id) AS user_ids,
		COUNT(cu2.user_id) AS member_count
		FROM chat_users cu
		JOIN chats c ON cu.chat_id = c.id
		JOIN chat_users cu2 ON cu2.chat_id = c.id AND cu2.status = 'active'
		WHERE cu.user_id = $1 AND cu.status = 'active'
		GROUP BY c.id;
	`
	rows, err := r.postgres.Query(ctx, query, userId)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var chats []model.Chat
	for rows.Next() {
		var chat model.Chat
		var ctype string
		err := rows.Scan(
			&chat.ID,
			&ctype,
			&chat.Title,
			&chat.CreatorID,
			&chat.CreatedAt,
			&chat.UpdatedAt,
			&chat.UserIds,
			&chat.MemberCount,
		)
		if err != nil {
			return nil, err
		}
		validTypes := map[string]int{"private": 0, "group": 1, "channel": 2}
		chat.Type = model.ChatType(validTypes[ctype])
		chats = append(chats, chat)
	}

	return chats, nil
}
