package model

import (
	"time"
)

type ChatType string

const (
	ChatTypePrivate ChatType = "private"
	ChatTypeGroup   ChatType = "group"
	ChatTypeChannel ChatType = "channel"
)

type Chat struct {
	ID           string
	Type         ChatType
	Title        *string
	Description  *string
	CreatedAt    time.Time
	LastActivity time.Time
}

type Membership struct {
	ChatID   string
	UserID   string
	Role     string
	JoinedAt time.Time
}

type CreateChatParams struct {
	CallerUserID string
	Type         ChatType
	Title        *string
	Description  *string
	UserIDs      []string
}
