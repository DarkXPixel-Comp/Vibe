package model

import "time"

type AuthKey struct {
	AuthKeyID  uint64
	UserID     string
	DeviceID   string
	AuthKeyEnc []byte
	RevokedAt  *time.Time
}

type Session struct {
	SessionID      string
	UserID         string
	DeviceID       string
	AuthKeyID      uint64
	Salt           uint64
	Status         string
	DevicePlatform string
	DeviceName     string
	LastSeen       *time.Time
}
