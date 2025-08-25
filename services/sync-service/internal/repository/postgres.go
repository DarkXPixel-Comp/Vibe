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

func NewSyncRepository(postgresql *pgxpool.Pool) SyncRepository {
	return &syncRepository{postgresql: postgresql}
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

func (r *syncRepository) SaveUpdate(ctx context.Context, update model.Update) (model.UserSync, string, error) {
	tx, err := r.postgresql.Begin(ctx)
	if err != nil {
		return model.UserSync{}, "", fmt.Errorf("failed to begin transaction: %w", err)
	}
	defer tx.Rollback(ctx)

	var newPts, newUnordoredPts int64
	if update.Type == "profile" {
		err = tx.QueryRow(ctx, `
			SELECT COALESCE(MAX(unordored_pts), 0) + 1
			FROM events
			WHERE user_id = $1 AND type = 'profile'
		`, update.UserID).Scan(&newUnordoredPts)
		if err != nil {
			return model.UserSync{}, "", fmt.Errorf("failed to get new unordored_pts: %w", err)
		}
	} else {
		err = tx.QueryRow(ctx, `
			SELECT COALSCE(MAX(pts), 0) + 1
			FROM events
			WHERE user_id = $1 AND type != 'profile'
		`, update.UserID).Scan(&newPts)
		if err != nil {
			return model.UserSync{}, "", fmt.Errorf("failed to get new pts: %w", err)
		}
	}

	var generatedID string
	err = tx.QueryRow(ctx, `
		INSERT INTO events (user_id, type, payload, pts, unordored_pts, timestamp)
		VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING id
	`, update.UserID, update.Type, update.Payload, newPts, newUnordoredPts, update.Timestamp).Scan(&generatedID)

	if err != nil {
		return model.UserSync{}, "", fmt.Errorf("failed to insert event")
	}

	_, err = tx.Exec(ctx, `
		INSERT INTO user_sync (user_id, pts, unordored_pts)
		VALUES ($1, $2, $3)
		ON CONFLICT (user_id)
		DO UPDATE SET pts = GREATEST(user_sync.pts, $2), unordored_pts = GREATEST(user_sync.unordored_pts, $3)
	`, update.UserID, newPts, newUnordoredPts)
	if err != nil {
		return model.UserSync{}, "", fmt.Errorf("failed to update user_sync: %w", err)
	}

	if err := tx.Commit(ctx); err != nil {
		return model.UserSync{}, "", fmt.Errorf("failed to commit transaction: %w", err)
	}

	return model.UserSync{UserID: update.UserID, Pts: newPts, UnordoredPts: newUnordoredPts}, generatedID, nil
}
