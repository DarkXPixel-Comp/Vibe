package model

import (
	"time"
	//"github.com/google/uuid"
)

type Chat struct {
	ID        string
	Type      string
	Title     string
	CreateID  string
	CreatedAt time.Time
}
