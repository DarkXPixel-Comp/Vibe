package repository

import (
	"context"
	"time"

	usergrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/user/usergrpc"
	userproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/user"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

// UserClient defines the interface for interacting with the user service.
type UserClient interface {
	GetOrCreateUser(ctx context.Context, phone string) (*userproto.User, error)
}

type userClient struct {
	client usergrpc.UserServiceClient
}

func NewUserClient(userServiceAddr string) (UserClient, error) {
	conn, err := grpc.NewClient(userServiceAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithIdleTimeout(60*time.Second))
	if err != nil {
		return nil, err
	}

	return &userClient{
		client: usergrpc.NewUserServiceClient(conn),
	}, nil
}

func (uc *userClient) GetOrCreateUser(ctx context.Context, phone string) (*userproto.User, error) {
	// In a real-world scenario, you might want to add a timeout/deadline to the context.
	ctx, cancel := context.WithTimeout(ctx, 5*time.Second)
	defer cancel()

	resp, err := uc.client.GetOrCreateUser(ctx, &userproto.GetOrCreateUserRequest{Phone: phone})
	if err != nil {
		return nil, err
	}

	// The GetSuccess check is removed as we rely on gRPC status codes for errors.
	// If the user service returns an error, it will be propagated.

	return resp.User, nil
}
