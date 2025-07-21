package model

import (
	"time"
)

type ChatType int32

const (
	ChatType_PRIVATE ChatType = 0
	ChatType_GROUP   ChatType = 1
	ChatType_CHANNEL ChatType = 2
)

type Chat struct {
	ID          string
	Type        ChatType
	Title       string
	CreatorID   string
	CreatedAt   time.Time
	UpdatedAt   time.Time
	UserIds     []string
	MemberCount int32
}
