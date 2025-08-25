package handler

import (
	"context"
	"time"

	protoUser "github.com/DarkXPixel/Vibe/proto/user"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/service"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/utils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type UserHandler struct {
	protoUser.UnimplementedUserServiceServer
	service service.UserService
}

func NewUserHandler(service service.UserService) *UserHandler {
	return &UserHandler{
		service: service,
	}
}

func (h *UserHandler) GetOrCreateUser(ctx context.Context, req *protoUser.GetOrCreateUserRequest) (*protoUser.UserResponse, error) {
	phone, err := utils.ValidatePhoneNumber(req.GetPhone())
	if err != nil {
		return &protoUser.UserResponse{
			Success: false,
		}, status.Error(codes.InvalidArgument, "invalid phone number")
	}
	user, err := h.service.GetOrCreateUser(ctx, phone)
	if err != nil {
		return &protoUser.UserResponse{
			Success: false,
		}, status.Error(codes.Internal, err.Error())
	}

	return &protoUser.UserResponse{
		User: &protoUser.User{
			UserId:    user.UserID,
			Phone:     user.Phone,
			UserName:  user.UserName,
			CreatedAt: user.Created_at.Format(time.RFC3339),
			UpdatedAt: user.Updated_at.Format(time.RFC3339),
		},
		Success: true,
	}, nil
}
