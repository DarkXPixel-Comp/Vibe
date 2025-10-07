package model

type Session struct {
	ID         string `json:"id"`
	DeviceName string `json:"device_name"`
	IsCurrent  bool   `json:"is_current"`
	LastUsedAt string `json:"last_used_at"`
	CreatedAt  string `json:"created_at"`
}