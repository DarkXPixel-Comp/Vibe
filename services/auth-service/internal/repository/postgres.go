package repository

import (
	"context"
	"time"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/model"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

type Postgres struct {
	Pool *pgxpool.Pool
}

func NewPostgres(ctx context.Context, dsn string) (*Postgres, error) {
	cfg, err := pgxpool.ParseConfig(dsn)
	if err != nil {
		return nil, err
	}

	pool, err := pgxpool.NewWithConfig(ctx, cfg)
	if err != nil {
		return nil, err
	}

	if err := pool.Ping(ctx); err != nil {
		return nil, err
	}

	return &Postgres{Pool: pool}, nil
}

func (p *Postgres) Close() {
	p.Pool.Close()
}

func createDeviceTx(ctx context.Context, tx pgx.Tx, userID, platform, name, deviceUUID string) error {
	_, err := tx.Exec(ctx,
		`INSERT INTO devices (id, user_id, platform, name, created_at)
		VALUES ($1, $2, $3, now())`, deviceUUID, userID, platform, name)
	return err
}

func upsertAuthKeyTx(ctx context.Context, tx pgx.Tx, userUUID, deviceUUID string, authKeyID uint64, authKeyEnc []byte) error {
	_, err := tx.Exec(ctx,
		`INSERT INTO auth_keys (auth_key_id, user_id, device_id, auth_key_enc, created_at)
		 VALUES ($1, $2, $3, $4, now())
		 ON CONFLICT (auth_key_id) DO UPDATE
		 SET revoked_at=NULL, revoked_reason=NULL`,
		authKeyID, userUUID, deviceUUID, authKeyEnc)
	return err
}

func createSessionTx(ctx context.Context, tx pgx.Tx, userUUID, deviceUUID string, authKeyID uint64, sessionUUID string, salt uint64, cipher string, expiresAt *time.Time) error {
	_, err := tx.Exec(ctx,
		`INSERT INTO sessions (session_id, user_id, device_id, auth_key_id, salt, status, aead_cipher, created_at, expires_at)
		 VALUES ($1, $2, $3, $4, $5, 'active', $6, now(), $7)`, sessionUUID, userUUID, deviceUUID, authKeyID, salt, cipher, expiresAt)
	return err
}

func (p *Postgres) CreateDeviceAuthKeySession(ctx context.Context, userUUID, deviceUUID, sessionUUID, platform, name string, authKeyID uint64, authKeyEnc []byte, salt uint64, cipher string, expiresAt *time.Time) error {
	tx, err := p.Pool.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	if err = createDeviceTx(ctx, tx, userUUID, platform, name, deviceUUID); err != nil {
		return err
	}
	if err = upsertAuthKeyTx(ctx, tx, userUUID, deviceUUID, authKeyID, authKeyEnc); err != nil {
		return err
	}
	if err = createSessionTx(ctx, tx, userUUID, deviceUUID, authKeyID, sessionUUID, salt, cipher, expiresAt); err != nil {
		return err
	}

	return tx.Commit(ctx)
}

func (p *Postgres) CreateDevice(ctx context.Context, userID, platform, name, deviceUUID string) error {
	tx, err := p.Pool.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	err = createDeviceTx(ctx, tx, userID, platform, name, deviceUUID)
	if err != nil {
		return err
	}
	return tx.Commit(ctx)
}

func (p *Postgres) UpsertAuthKey(ctx context.Context, userUUID, deviceUUID string, authKeyID uint64, authKeyEnc []byte) error {
	tx, err := p.Pool.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	err = upsertAuthKeyTx(ctx, tx, userUUID, deviceUUID, authKeyID, authKeyEnc)
	if err != nil {
		return err
	}
	return tx.Commit(ctx)
}

func (p *Postgres) GetAuthKeyByID(ctx context.Context, authKeyID uint64) (*model.AuthKey, error) {
	row := p.Pool.QueryRow(ctx,
		`SELECT auth_key_id, user_id, device_id, auth_key_enc, revoked_at
		 FROM auth_keys WHERE auth_key_id=$1`, authKeyID)
	var ak model.AuthKey
	err := row.Scan(&ak.AuthKeyID, &ak.UserID, &ak.DeviceID, &ak.AuthKeyEnc, &ak.RevokedAt)
	if err != nil {
		return nil, err
	}
	return &ak, nil
}

func (p *Postgres) RevokeAuthKey(ctx context.Context, authKeyID uint64, reason string) error {
	_, err := p.Pool.Exec(ctx,
		`UPDATE auth_keys SET revoked_at=now(), revoked_reason=$2 WHERE auth_key_id=$1`,
		authKeyID, reason)
	return err
}

func (p *Postgres) CreateSession(ctx context.Context, userUUID, deviceUUID string, authKeyID uint64, sessionUUID string, salt uint64, cipher string, expiresAt *time.Time) error {
	tx, err := p.Pool.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	err = createSessionTx(ctx, tx, userUUID, deviceUUID, authKeyID, sessionUUID, salt, cipher, expiresAt)

	if err != nil {
		return err
	}
	return tx.Commit(ctx)
}

func (p *Postgres) GetSession(ctx context.Context, authKeyID uint64, sessionUUID string) (*model.Session, error) {
	row := p.Pool.QueryRow(ctx,
		`SELECT s.session_id, s.user_id, s.device_id, s.auth_key_id, s.salt, s.status,
		        d.platform, d.name, s.last_seen
		 FROM sessions s
		 JOIN devices d ON s.device_id=d.id
		 WHERE s.auth_key_id=$1 AND s.session_id=$2`,
		authKeyID, sessionUUID)
	var s model.Session
	err := row.Scan(&s.SessionID, &s.UserID, &s.DeviceID, &s.AuthKeyID, &s.Salt, &s.Status, &s.DevicePlatform, &s.DeviceName, &s.LastSeen)
	if err != nil {
		return nil, err
	}
	return &s, nil
}

func (p *Postgres) TouchSession(ctx context.Context, sessionUUID string) error {
	_, err := p.Pool.Exec(ctx, `UPDATE sessions SET last_seen=now() WHERE session_id=$1`, sessionUUID)
	return err
}

func (p *Postgres) ListSessions(ctx context.Context, userUUID string) ([]model.Session, error) {
	rows, err := p.Pool.Query(ctx,
		`SELECT s.session_id, s.user_id, s.device_id, s.auth_key_id, s.salt, s.status,
		 		d.platform, d.name, s.last_seen
		 FROM sessions s
		 JOIN devices d ON s.device_id=d.id
		 WHERE s.user_id=$1`, userUUID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []model.Session
	for rows.Next() {
		var s model.Session
		if err := rows.Scan(&s.SessionID, &s.UserID, &s.DeviceID, &s.AuthKeyID, &s.Salt, &s.Status, &s.DevicePlatform, &s.DeviceName, &s.LastSeen); err != nil {
			return nil, err
		}
		out = append(out, s)
	}
	return out, rows.Err()
}

func (p *Postgres) RevokeSession(ctx context.Context, sessionUUID, reason string) error {
	_, err := p.Pool.Exec(ctx,
		`UPDATE sessions SET status='revoked', revoked_at=now(), revoked_reason=$2 WHERE session_id=$1`,
		sessionUUID, reason)
	return err
}
