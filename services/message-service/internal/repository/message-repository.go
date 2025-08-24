package repository

import (
	"context"
	"fmt"

	"github.com/DarkXPixel/Vibe/services/message-service/internal/model"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type MessageRepository interface {
	GetState(ctx context.Context, userID string) (int64, error)
	GetDiffernce(ctx context.Context, userID string, clientPts int64) (int64, []model.ChatState, error)
	ListMessages(ctx context.Context, chatID string, limit int32, lastMessageID string) ([]model.Message, error)
}

type messageRepository struct {
	postgresql *pgxpool.Pool
}

func CreateMessageRepository(postgresql *pgxpool.Pool) MessageRepository {
	return &messageRepository{postgresql: postgresql}
}

func (r *messageRepository) GetState(ctx context.Context, userID string) (int64, error) {
	var pts int64
	err := r.postgresql.QueryRow(ctx, "SELECT pts FROM user_pts WHERE user_id = $1", userID).Scan(&pts)
	if err == pgx.ErrNoRows {
		return 0, nil
	}

	if err != nil {
		return 0, fmt.Errorf("failed to get state: %w", err)
	}
	return pts, nil
}

func (r *messageRepository) GetDiffernce(ctx context.Context, userID string, clientPts int64) (int64, []model.ChatState, error) {
	var currentPts int64
	err := r.postgresql.QueryRow(ctx, "SELECT pts FROM user_pts WHERE user_id = $1", userID).Scan(&currentPts)
	if err == pgx.ErrNoRows {
		currentPts = 0
	} else if err != nil {
		return 0, nil, fmt.Errorf("failed to get pts: %w", err)
	}

	query := `
		SELECT id, chat_id, user_id, type, payload, timestamp
		FROM messages
		WHERE user_id = $1 AND deleted_at IS NULL and pts > $2
		ORDER BY pts ASC
		LIMIT 100
	`

	rows, err := r.postgresql.Query(ctx, query, userID, clientPts)
	if err != nil {
		return 0, nil, fmt.Errorf("failed to get messages: %w", err)
	}

	defer rows.Close()

	chatStates := make(map[string]*model.ChatState)
	for rows.Next() {
		var msg model.Message
		if err := rows.Scan(&msg.ID, &msg.ChatID, &msg.UserID, &msg.Type, &msg.Payload, &msg.Timestamp); err != nil {
			return 0, nil, fmt.Errorf("failed to scan message: %w", err)
		}
		if _, ok := chatStates[msg.ChatID]; !ok {
			chatStates[msg.ChatID] = &model.ChatState{ChatID: msg.ChatID}
		}
		chatStates[msg.ChatID].Messages = append(chatStates[msg.ChatID].Messages, msg)
	}

	query = `
		SELECT id, chat_id
		FROM messages
		WHERE user_id = $1 AND deleted_at IS NOT NULL AND pts > $2
		ORDER BY pts ASC
		LIMIT 100
	`
	rows, err = r.postgresql.Query(ctx, query, userID, clientPts)
	if err != nil {
		return 0, nil, fmt.Errorf("failed to get deleted IDs: %w", err)
	}
	defer rows.Close()

	for rows.Next() {
		var id, chatID string
		if err := rows.Scan(&id, &chatID); err != nil {
			return 0, nil, fmt.Errorf("failed to scan deleted ID: %w", err)
		}
		if _, ok := chatStates[chatID]; !ok {
			chatStates[chatID] = &model.ChatState{ChatID: chatID}
		}
		chatStates[chatID].DeletedMessageIDs = append(chatStates[chatID].DeletedMessageIDs, id)
	}

	var states []model.ChatState
	for _, state := range chatStates {
		states = append(states, *state)
	}

	return currentPts, states, nil
}

func (r *messageRepository) ListMessages(ctx context.Context, chatID string, limit int32, lastMessageID string) ([]model.Message, error) {
	query := `
		SELECT id, chat_id, user_id, type, payload, timestamp
		FROM messages
		WHERE chat_id = $1 AND deleted_at IS NULL
		AND ($2 = '' OR id > $2)
		ORDER BY id ASC
		LIMIT $3
	`
	rows, err := r.postgresql.Query(ctx, query, chatID, lastMessageID, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to list messages: %w", err)
	}
	defer rows.Close()

	var messages []model.Message
	for rows.Next() {
		var msg model.Message
		if err := rows.Scan(&msg.ID, &msg.ChatID, &msg.UserID, &msg.Type, &msg.Payload, &msg.Timestamp); err != nil {
			return nil, fmt.Errorf("failed to scan message: %w", err)
		}
		messages = append(messages, msg)
	}

	return messages, nil
}

func (r *messageRepository) DeleteMessage(ctx context.Context, chatID, messageID, userID string) (int64, error) {
	tx, err := r.postgresql.Begin(ctx)
	if err != nil {
		return 0, fmt.Errorf("failed to start transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	var currentPts int64
	err = tx.QueryRow(ctx, "SELECT pts FROM user_pts FROM user_pts WHERE user_id = $1 FOR UPDATE", userID).Scan(&currentPts)
	if err == pgx.ErrNoRows {
		currentPts = 0
	} else if err != nil {
		return 0, fmt.Errorf("failed to get pts: %w", err)
	}

	currentPts++
	_, err = tx.Exec(ctx, `
		UPDATE messages
		SET deleted_at = NOW(), pts = $1
		WHERE id = $2 AND chat_id = $3 AND deleted_at IS NULL
	`, currentPts, messageID, chatID)

	if err != nil {
		return 0, fmt.Errorf("failed to delete message: %w", err)
	}

	_, err = tx.Exec(ctx, `
		INSERT INTO user_pts (user_id, pts) VALUES ($1, $2)
		ON CONFLICT (user_id) DO UPDATE SET pts = $2
	`, userID, currentPts)
	if err != nil {
		return 0, fmt.Errorf("failed to update user_pts", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return 0, fmt.Errorf("failed to commit transaction: %w", err)
	}
	return currentPts, nil
}

func (r *messageRepository) SaveMessage(ctx context.Context, msg model.Message) (int64, error) {
	tx, err := r.postgresql.Begin(ctx)
	if err != nil {
		return 0, fmt.Errorf("failed to start transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	var currentPts int64
	err = tx.QueryRow(ctx, "SELECT pts FROM user_pts WHERE user_id = $1 FOR UPDATE").Scan(&currentPts)
	if err == pgx.ErrNoRows {
		currentPts = 0
	} else if err != nil {
		return 0, fmt.Errorf("failed to get user_pts: %w", err)
	}

	currentPts++
	_, err = tx.Exec(ctx, `
		INSERT INTO messages (id, chat_id, user_id, type, payload, timestamp, pts)
		VALUES ($1, $2, $3, $4, $5, $6, $7)
	`, msg.ID, msg.ChatID, msg.UserID, msg.Type, msg.Payload, msg.Timestamp, currentPts)
	if err != nil {
		return 0, fmt.Errorf("failed to save message: %w", err)
	}
	_, err = tx.Exec(ctx, `
		INSERT INTO user_pts (user_id, pts) VALUES ($1, $2)
		ON CONFLICT (user_id) DO UPDATE SET pts = $2
	`, msg.UserID, currentPts)
	if err != nil {
		return 0, fmt.Errorf("failed to update user_pts: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return 0, fmt.Errorf("failed to commit transaction: %w", err)
	}
	return currentPts, nil
}

// func (r *messageRepository) ListMessages(ctx context.Context, chatID string, limit int32, lastMessageID string) ([]model.Message, error) {
// 	query := `
// 		SELECT id, chat_id, user_id, content, timestamp
// 		FROM messages
// 		WHERE chat_id = $1 AND deleted_at IS NULL
// 		AND ($2 = '' OR id > $2)
// 		ORDER BY id ASC
// 		LIMIT $3
// 	`

// 	rows, err := r.postgresql.Query(ctx, query, chatID, lastMessageID, limit)
// 	if err != nil {
// 		return nil, fmt.Errorf("failed to list messages: %w", err)
// 	}

// 	defer rows.Close()
// 	var messages []model.Message

// 	for rows.Next() {
// 		var msg model.Message
// 		if err := rows.Scan(&msg.ID, &msg.ChatID, &msg.UserID, &msg.Content, &msg.Timestamp); err != nil {
// 			return nil, fmt.Errorf("failed to scan message: %w", err)
// 		}
// 		messages = append(messages, msg)
// 	}
// 	return messages, nil
// }

// func (r *messageRepository) GetDiffernce(ctx context.Context, chatID string, pts int64) ([]model.Message, []string, int64, error) {
// 	var currentPts int64

// 	query := `
// 		SELECT pts FROM chat_pts WHERE chat_id = $1
// 	`

// 	err := r.postgresql.QueryRow(ctx, query, chatID).Scan(&currentPts)

// 	if err == pgx.ErrNoRows {
// 		currentPts = 0
// 	} else if err != nil {
// 		return nil, nil, 0, fmt.Errorf("failed to get pts: %w", err)
// 	}

// 	query = `
// 		SELECT id, chat_id, user_id, content, timestamp
// 		FROM messages
// 		WHERE chat_id = $1 AND deleted_at IS NULL
// 		AND pts > $2
// 		ORDER BY pts ASC
// 	`

// 	rows, err := r.postgresql.Query(ctx, query, chatID, pts)
// 	if err != nil {
// 		return nil, nil, 0, fmt.Errorf("failed to get messages: %w", err)
// 	}

// 	defer rows.Close()

// 	var messages []model.Message
// 	for rows.Next() {
// 		var msg model.Message
// 		if err := rows.Scan(&msg.ID, &msg.ChatID, &msg.UserID, &msg.Content, &msg.Timestamp); err != nil {
// 			return nil, nil, 0, err
// 		}
// 		messages = append(messages, msg)
// 	}

// 	query = `
// 		SELECT id
// 		FROM messages
// 		WHERE chat_id = $1 AND deleted_at IS NOT NULL
// 		AND pts > $2
// 		ORDER BY pts ASC
// 		`
// 	rows, err = r.postgresql.Query(ctx, query, chatID, pts)
// 	if err != nil {
// 		return nil, nil, 0, fmt.Errorf("failed to get deleted messages: %w", err)
// 	}
// 	defer rows.Close()

// 	var deletedIds []string
// 	for rows.Next() {
// 		var id string
// 		if err := rows.Scan(&id); err != nil {
// 			return nil, nil, 0, err
// 		}
// 		deletedIds = append(deletedIds, id)
// 	}

// 	return messages, deletedIds, currentPts, nil
// }

// func (r *messageRepository) DeleteMessage(ctx context.Context, chatID, messageID string) (int64, error) {
// 	tx, err := r.postgresql.Begin(ctx)
// 	if err != nil {
// 		return 0, fmt.Errorf("failed to start transaction: %w", err)
// 	}

// 	defer tx.Rollback(ctx)

// 	var currentPts int64
// 	err = tx.QueryRow(ctx, "SELECT pts FROM chat_pts WHERE chat_id = $1 FOR UPDATE", chatID).Scan(&currentPts)
// 	if err == pgx.ErrNoRows {
// 		currentPts = 0
// 	} else if err != nil {
// 		return 0, fmt.Errorf("failed to get pts: %w", err)
// 	}

// 	currentPts++
// 	_, err = tx.Exec(ctx, `
// 		UPDATE messages
// 		SET deleted_at = NOW(), pts = $1
// 		WHERE id = $2 AND chat_id = $3 AND deleted_at IS NULL
// 	`, currentPts, messageID, chatID)
// 	if err != nil {
// 		return 0, fmt.Errorf("failed to delete message: %w", err)
// 	}
// 	return 0, nil
// }
