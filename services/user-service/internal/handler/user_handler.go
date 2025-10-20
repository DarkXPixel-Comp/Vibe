package handler

import (
	"context"
	"time"

	usergrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/user/usergrpc"
	userproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/user"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/service"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/utils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type UserHandler struct {
	usergrpc.UnimplementedUserServiceServer
	service service.UserService
}

func NewUserHandler(service service.UserService) *UserHandler {
	return &UserHandler{
		service: service,
	}
}

func (h *UserHandler) GetOrCreateUser(ctx context.Context, req *userproto.GetOrCreateUserRequest) (*userproto.UserResponse, error) {
	phone, err := utils.ValidatePhoneNumber(req.GetPhone())
	if err != nil {
		return &userproto.UserResponse{
			Success: false,
		}, status.Error(codes.InvalidArgument, "invalid phone number")
	}
	user, err := h.service.GetOrCreateUser(ctx, phone)
	if err != nil {
		return &userproto.UserResponse{
			Success: false,
		}, status.Error(codes.Internal, err.Error())
	}

	return &userproto.UserResponse{
		User: &userproto.User{
			UserId:    user.UserID,
			Phone:     user.Phone,
			UserName:  user.UserName,
			CreatedAt: user.Created_at.Format(time.RFC3339),
			UpdatedAt: user.Updated_at.Format(time.RFC3339),
		},
		Success: true,
	}, nil
}
