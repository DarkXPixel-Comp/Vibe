package model

import "time"

type TokenValidation struct {
	Valid          bool
	UserUUID       string
	Status         string
	DevicePlatform string
	DeviceName     string
	LastSeen       *time.Time
}
