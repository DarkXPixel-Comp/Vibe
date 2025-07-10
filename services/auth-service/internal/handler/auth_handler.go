package handler

import (
	"context"

	protoAuth "github.com/DarkXPixel/Vibe/proto/auth"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/service"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type AuthHandler struct {
	protoAuth.UnimplementedAuthServiceServer
	service service.AuthService
}

func NewAuthHandler(service service.AuthService) *AuthHandler {
	return &AuthHandler{
		service: service,
	}
}

func (s *AuthHandler) SendVerificationCode(ctx context.Context, req *protoAuth.PhoneNumberRequest) (*protoAuth.SendCodeResponse, error) {
	phoneNumber, err := utils.ValidatePhoneNumber(req.GetPhoneNumber())
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid phone number: %w", err)
	}

	tok, err := s.service.SendCode(ctx, phoneNumber)
	if err != nil {
		return &protoAuth.SendCodeResponse{
			Success: false,
			Message: "error send code",
			Token:   "",
		}, status.Errorf(codes.Internal, "internal error: %s", err)
	}

	return &protoAuth.SendCodeResponse{
		Success: true,
		Message: "its ok",
		Token:   tok,
	}, nil
}

func (s *AuthHandler) VerifyCode(ctx context.Context, req *protoAuth.VerifyCodeRequest) (*protoAuth.AuthResponse, error) {
	response, err := s.service.VerifyCode(ctx, req.GetToken(), req.GetCode())
	if err != nil {
		return &protoAuth.AuthResponse{
			Success:   false,
			AuthToken: "",
			UserId:    "",
			Message:   "Wrong code",
		}, nil
	}

	return &protoAuth.AuthResponse{
		Success:   true,
		AuthToken: response.Token,
		UserId:    response.User_id,
	}, nil
}

func (s *AuthHandler) ValidateToken(ctx context.Context, req *protoAuth.ValidateTokenRequest) (*protoAuth.ValidateTokenRespone, error) {
	//s.service.ValidateToken(ctx)
	user_id, err := s.service.ValidateToken(ctx, req.GetToken())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "invalid token")
	}

	return &protoAuth.ValidateTokenRespone{
		Success: true,
		UserId:  user_id,
	}, nil
}
