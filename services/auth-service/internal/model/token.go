package model

import "time"

type SessionToken struct {
	ID         string    `db:"id"`
	UserID     string    `db:"user_id"`
	TokenHash  string    `db:"token_hash"`
	CreatedAt  time.Time `db:"created_at"`
	LastUsetAt time.Time `db:"last_used_at"`
	Revoked    bool      `db:"revoked"`
}
