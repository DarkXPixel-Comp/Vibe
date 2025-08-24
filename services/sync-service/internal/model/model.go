package model

import "time"

type UserSync struct {
	UserID       string `json:"user_id"`
	Pts          int64  `json:"pts"`
	UnordoredPts int64  `json:"unordored_pts"`
}

type Update struct {
	ID           string    `json:"id"`
	UserID       string    `json:"user_id"`
	Messages     []Message `json:"messages"`
	Type         string    `json:"type"`
	Payload      string    `json:"payload"`
	Pts          int64     `json:"pts"`
	UnordoredPts int64     `json:"unordored_pts"`
	Timestamp    time.Time `json:"timestamp"`
}

type ChatState struct {
	ChatID   string    `json:"chat_id"`
	Messages []Message `json:"messages"`
}

type Message struct {
	ID        string    `json:"id"`
	ChatID    string    `json:"chat_id"`
	UserID    string    `json:"user_id"`
	Type      string    `json:"type"`
	Payload   string    `json:"payload"`
	Timestamp time.Time `json:"timestamp"`
}

type ProfileState struct {
	UserID    string `json:"user_id"`
	Name      string `json:"name"`
	AvatarURL string `json:"avatar_url"`
}
