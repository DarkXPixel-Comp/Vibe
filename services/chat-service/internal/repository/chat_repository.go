package repository

import (
	"context"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type ChatRepository struct {
	pool *pgxpool.Pool
}

func CreateChatRepository(postgresql *pgxpool.Pool) ChatRepository {
	return ChatRepository{pool: postgresql}
}

type CreatePrivatePairParams struct {
	ChatID  string
	UserAID string
	UserBID string
}

func (r *ChatRepository) BeginTx(ctx context.Context) (pgx.Tx, error) {
	return r.pool.Begin(ctx)
}

func (r *ChatRepository) InsertChat(ctx context.Context, tx pgx.Tx, chatType string, title *string, description *string) (string, error) {
	var id string
	err := tx.QueryRow(ctx,
		`
			INSERT INTO chats (type, title, description, created_at, last_activity)
			VALUES ($1, $2, $3, NOW(), NOW())
			RETURNING id
		`, chatType, title, description).Scan(&id)
	return id, err
}

func (r *ChatRepository) InsertMemberships(ctx context.Context, tx pgx.Tx, chatID string, roles map[string]string) error {
	for uuid, role := range roles {
		_, err := tx.Exec(ctx,
			`
				INSERT INTO memberships (chat_id, user_id, role, joined_at)
				VALUES ($1, $2, $3, NOW())
			`, chatID, uuid, role)
		if err != nil {
			return err
		}
	}
	return nil
}

func (r *ChatRepository) InsertPrivatePair(ctx context.Context, tx pgx.Tx, params CreatePrivatePairParams) error {
	_, err := tx.Exec(ctx,
		`
			INSERT INTO private_chat_pairs (chat_id, user1_id, user2_id)
			VALUES ($1, $2, $3)
		`, params.ChatID, params.UserAID, params.UserBID)
	return err
}

func (r *ChatRepository) GetChatByID(ctx context.Context, chatID string) (struct {
	ID             string
	Type           string
	Title          *string
	Description    *string
	CreatedAt      time.Time
	LastActivityAt time.Time
}, error) {
	var row struct {
		ID             string
		Type           string
		Title          *string
		Description    *string
		CreatedAt      time.Time
		LastActivityAt time.Time
	}

	err := r.pool.QueryRow(ctx,
		`
		SELECT id, type, title, description, created_at, last_activity_at
		FROM chats
		WHERE id = $1
	`, chatID).Scan(
		&row.ID,
		&row.Type,
		&row.Title,
		&row.Description,
		&row.CreatedAt,
		&row.LastActivityAt,
	)
	return row, err
}

func (r *ChatRepository) ExistsPrivatePair(ctx context.Context, userA, userB string) (bool, error) {
	var exists bool
	err := r.pool.QueryRow(ctx, `
		SELECT EXISTS (
			SELECT 1 FROM private_chat_pairs
			WHERE LEAST(user1_id, user2_id) = LEAST($1,$2)
			  AND GREATEST(user1_id, user2_id) = GREATEST($1,$2)
		)
	`, userA, userB).Scan(&exists)
	return exists, err
}
