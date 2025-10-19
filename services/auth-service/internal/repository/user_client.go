package repository

import (
	"context"
	"time"

	usergrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/user/usergrpc"
	userproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/user"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type UserClient struct {
	client usergrpc.UserServiceClient
}

func NewUserClient(userServiceAddr string) (*UserClient, error) {
	conn, err := grpc.NewClient(userServiceAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithIdleTimeout(60*time.Second))
	if err != nil {
		return nil, err
	}

	return &UserClient{
		client: usergrpc.NewUserServiceClient(conn),
	}, nil
}

func (uc *UserClient) GetOrCreateUser(ctx context.Context, phone string) (*userproto.User, error) {
	resp, err := uc.client.GetOrCreateUser(ctx, &userproto.GetOrCreateUserRequest{Phone: phone})
	if err != nil {
		return nil, err
	}

	if !resp.GetSuccess() {
		return nil, err
	}

	return resp.User, nil
}
