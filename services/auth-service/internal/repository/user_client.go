package repository

import "context"

type UserRepository interface {
	GetOrCreateUser(ctx context.Context)
}