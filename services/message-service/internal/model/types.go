package model

import (
	"time"
)

type Message struct {
	ID        string     `json:"id"`
	ChatID    string     `json:"chat_id"`
	UserID    string     `json:"user_id"`
	Type      string     `json:"type"`    // text, call, audio, video, file
	Payload   string     `json:"payload"` // JSON-encoded data
	Timestamp time.Time  `json:"timestamp"`
	DeletedAt *time.Time `json:"deleted_at,omitempty"`
}

type UserPts struct {
	UserID string `json:"user_id"`
	Pts    int64  `json:"pts"`
}

type ChatState struct {
	ChatID            string    `json:"chat_id"`
	Messages          []Message `json:"messages"`
	DeletedMessageIDs []string  `json:"deleted_message_ids"`
	NewPts            int64     `json:"new_pts"`
}

type SyncData struct {
	ChatID            string                   `json:"chat_id"`
	Messages          []map[string]interface{} `json:"messages"`
	DeletedMessageIds []string                 `json:"deleted_message_ids"`
	NewPts            int64                    `json:"new_pts"`
}

type KafkaOffset struct {
	Topic     string
	Partition int32
	Offset    int64
}

type WebSocketMessage struct {
	Type string      `json:"type"` // Message type (e.g., sync, text, call, delete)
	Data interface{} `json:"data"` // Message data
}
