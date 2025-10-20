package handler

import (
	"context"
	"fmt"
	"strings"

	authgrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/auth/authgrpc"
	authproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/auth"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/service"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
	corev3 "github.com/envoyproxy/go-control-plane/envoy/config/core/v3"
	envoyauth "github.com/envoyproxy/go-control-plane/envoy/service/auth/v3"
	typev3 "github.com/envoyproxy/go-control-plane/envoy/type/v3"
	googleapis "google.golang.org/genproto/googleapis/rpc/status"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

type AuthHandler struct {
	authgrpc.UnimplementedAuthServiceServer
	envoyauth.UnimplementedAuthorizationServer
	service service.AuthService
}

func NewAuthHandler(service service.AuthService) *AuthHandler {
	return &AuthHandler{
		service: service,
	}
}

func (s *AuthHandler) SendVerificationCode(ctx context.Context, req *authproto.PhoneNumberRequest) (*authproto.SendCodeResponse, error) {
	phoneNumber, err := utils.ValidatePhoneNumber(req.GetPhoneNumber())
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid phone number: %w", err)
	}

	tok, err := s.service.SendCode(ctx, phoneNumber)
	if err != nil {
		return &authproto.SendCodeResponse{
			Success: false,
			Message: "error send code",
			Token:   "",
		}, status.Errorf(codes.Internal, "internal error: %s", err)
	}

	return &authproto.SendCodeResponse{
		Success: true,
		Message: "its ok",
		Token:   tok,
	}, nil
}

func (s *AuthHandler) VerifyCode(ctx context.Context, req *authproto.VerifyCodeRequest) (*authproto.AuthResponse, error) {
	response, err := s.service.VerifyCode(ctx, req.GetToken(), req.GetCode())
	if err != nil {
		return &authproto.AuthResponse{
			Success:   false,
			AuthToken: "",
			UserId:    "",
			Message:   fmt.Sprintf("Wrong code: %s", err.Error()),
		}, nil
	}

	return &authproto.AuthResponse{
		Success:   true,
		AuthToken: response.Token,
		UserId:    response.User_id,
	}, nil
}

func (s *AuthHandler) ValidateToken(ctx context.Context, req *authproto.ValidateTokenRequest) (*authproto.ValidateTokenRespone, error) {
	//s.service.ValidateToken(ctx)
	user_id, err := s.service.ValidateToken(ctx, req.GetToken())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "invalid token: %v", err)
	}

	return &authproto.ValidateTokenRespone{
		Success: true,
		UserId:  user_id,
	}, nil
}

func (s *AuthHandler) Check(ctx context.Context, req *envoyauth.CheckRequest) (*envoyauth.CheckResponse, error) {
	headers := req.Attributes.Request.Http.Headers
	authHeader, ok := headers["authorization"]
	if !ok || !strings.HasPrefix(authHeader, "Bearer ") {
		return &envoyauth.CheckResponse{
			Status:       &googleapis.Status{Code: int32(codes.Unauthenticated), Message: "missing Authorization header"},
			HttpResponse: &envoyauth.CheckResponse_DeniedResponse{DeniedResponse: &envoyauth.DeniedHttpResponse{Status: &typev3.HttpStatus{Code: typev3.StatusCode(401)}}},
		}, fmt.Errorf("missing or invalid Authorization header")
	}

	token := strings.TrimPrefix(authHeader, "Bearer ")
	response, err := s.ValidateToken(ctx, &authproto.ValidateTokenRequest{Token: token})
	if err != nil {
		return nil, fmt.Errorf("error validate token: %w", err)
	}

	if !response.Success {
		return &envoyauth.CheckResponse{
			Status:       &googleapis.Status{Code: int32(codes.Unauthenticated), Message: "invaid token"},
			HttpResponse: &envoyauth.CheckResponse_DeniedResponse{DeniedResponse: &envoyauth.DeniedHttpResponse{Status: &typev3.HttpStatus{Code: typev3.StatusCode(401)}}},
		}, fmt.Errorf("invalid token")
	}

	return &envoyauth.CheckResponse{
		Status: &googleapis.Status{Code: int32(codes.OK)},
		HttpResponse: &envoyauth.CheckResponse_OkResponse{
			OkResponse: &envoyauth.OkHttpResponse{
				Headers: []*corev3.HeaderValueOption{
					{
						Header: &corev3.HeaderValue{
							Key:   "x-user-id",
							Value: response.GetUserId(),
						},
					},
				},
				HeadersToRemove: []string{"auauthorizationth"},
			},
		},
	}, nil
}
