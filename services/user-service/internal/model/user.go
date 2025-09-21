package model

import "time"

type User struct {
	UserID     string
	Phone      string
	UserName   string
	Created_at time.Time
	Updated_at time.Time
}
