package repository

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/DarkXPixel/Vibe/services/sync-service/internal/model"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type SyncRepository interface {
}

type syncRepository struct {
	postgresql *pgxpool.Pool
}

func (r *syncRepository) GetState(ctx context.Context, userID string) (model.UserSync, error) {
	var state model.UserSync
	err := r.postgresql.QueryRow(ctx, `
		SELECT user_id, pts, unordored_pts
		FROM user_sync
		WHERE user_id = $1
	`, userID).Scan(&state.UserID, &state.Pts, &state.UnordoredPts)
	if err == pgx.ErrNoRows {
		return model.UserSync{UserID: userID}, nil
	} else if err != nil {
		return model.UserSync{}, fmt.Errorf("failed to get state: %w", err)
	}
	return state, nil
}

func (r *syncRepository) GetDiffernce(ctx context.Context, userID string, clientPts, clientUnordoredPts int64) (model.UserSync, []model.Update, error) {
	currentState, err := r.GetState(ctx, userID)
	if err != nil {
		return model.UserSync{}, nil, fmt.Errorf("failed to get state: %w", err)
	}
	rows, err := r.postgresql.Query(ctx, `
		SELECT id, user_id, type, payload, pts, unordored_pts, timestamp
		FROM events
		WHERE user_id = $1 AND (
			(pts > $2 AND pts != 0) OR
			(unordored_pts > $3 AND unordered_pts != 0)
		)
		ORDER BY timestamp ASC
		LIMIT 100
	`, userID, clientPts, clientUnordoredPts)
	if err != nil {
		return model.UserSync{}, nil, fmt.Errorf("failed to query difference: %w", err)
	}
	defer rows.Close()
	var updates []model.Update
	for rows.Next() {
		var update model.Update
		var payload json.RawMessage
		if err := rows.Scan(&update.ID, &update.UserID, &update.Type, &payload, &update.Pts, &update.UnordoredPts, &update.Timestamp); err != nil {
			return model.UserSync{}, nil, fmt.Errorf("failed to scan update: %w", err)
		}
		update.Payload = string(payload)
		updates = append(updates, update)
	}
	if err := rows.Err(); err != nil {
		return model.UserSync{}, nil, err
	}
	return currentState, updates, nil
}

func (r *syncRepository) GetSnapshot(ctx context.Context, userID string, limitPerChat int32) (model.UserSync, []model.ChatState, model.ProfileState, error) {
	currentState, err := r.GetState(ctx, userID)
	if err != nil {
		return model.UserSync{}, nil, model.ProfileState{}, err
	}

	rows, err := r.postgresql.Query(ctx, `
		SELECT DISTINCT chat_id
		FROM events
		WHERE user_id = $1 AND type IN ('message', 'chat')
	`, userID)
	if err != nil {
		return model.UserSync{}, nil, model.ProfileState{}, fmt.Errorf("failed to query chat IDs: %w", err)
	}
	defer rows.Close()

	var chatIDs []string
	for rows.Next() { // change to grpc call to chat_service
		var chatID string
		if err := rows.Scan(&chatID); err != nil {
			return model.UserSync{}, nil, model.ProfileState{}, err
		}
		chatIDs = append(chatIDs, chatID)
	}

}
