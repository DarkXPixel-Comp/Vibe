package repository

import (
	"context"
	"time"

	"github.com/DarkXPixel/Vibe/proto/user"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type UserClientInterface interface {
	GetOrCreateUser(ctx context.Context, phone string) (*user.User, error)
}

type UserClient struct {
	client user.UserServiceClient
}

func NewUserClient(userServiceAddr string) (*UserClient, error) {
	conn, err := grpc.NewClient(userServiceAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithIdleTimeout(60*time.Second))
	if err != nil {
		return nil, err
	}

	return &UserClient{
		client: user.NewUserServiceClient(conn),
	}, nil
}

func (uc *UserClient) GetOrCreateUser(ctx context.Context, phone string) (*user.User, error) {
	resp, err := uc.client.GetOrCreateUser(ctx, &user.GetOrCreateUserRequest{Phone: phone})
	if err != nil {
		return nil, err
	}

	if !resp.GetSuccess() {
		return nil, err
	}

	return resp.User, nil
}