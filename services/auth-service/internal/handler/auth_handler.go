package handler

import (
	"context"
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
		return nil, status.Errorf(codes.InvalidArgument, "invalid phone number: %v", err)
	}

	tok, err := s.service.SendCode(ctx, phoneNumber)
	if err != nil {
		return nil, err
	}

	return &authproto.SendCodeResponse{
		Token: tok,
	}, nil
}

func (s *AuthHandler) VerifyCode(ctx context.Context, req *authproto.VerifyCodeRequest) (*authproto.AuthResponse, error) {
	response, err := s.service.VerifyCode(ctx, req.GetToken(), req.GetCode())
	if err != nil {
		return nil, err
	}

	return &authproto.AuthResponse{
		AcceessToken: response.AccessToken,
		RefreshToken: response.RefreshToken,
		UserId:       response.UserID,
	}, nil
}

func (s *AuthHandler) RefreshToken(ctx context.Context, req *authproto.RefreshTokenRequest) (*authproto.AuthResponse, error) {
	if req.GetRefreshToken() == "" {
		return nil, status.Error(codes.InvalidArgument, "refresh token is required")
	}

	response, err := s.service.RefreshToken(ctx, req.GetRefreshToken())
	if err != nil {
		return nil, err // Errors from service are already gRPC status errors
	}

	return &authproto.AuthResponse{
		AcceessToken: response.AccessToken,
		RefreshToken: response.RefreshToken,
		UserId:       response.UserID,
	}, nil
}

func (s *AuthHandler) ValidateToken(ctx context.Context, req *authproto.ValidateTokenRequest) (*authproto.ValidateTokenRespone, error) {
	//s.service.ValidateToken(ctx)
	user_id, err := s.service.ValidateToken(ctx, req.GetToken())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "invalid token %v", err)
	}

	return &authproto.ValidateTokenRespone{
		UserId: user_id,
	}, nil
}

func (s *AuthHandler) Check(ctx context.Context, req *envoyauth.CheckRequest) (*envoyauth.CheckResponse, error) {
	authHeader, ok := req.GetAttributes().GetRequest().GetHttp().GetHeaders()["authorization"]
	if !ok {
		return &envoyauth.CheckResponse{
			Status: &googleapis.Status{Code: int32(codes.Unauthenticated), Message: "Authorization header missing"},
			HttpResponse: &envoyauth.CheckResponse_DeniedResponse{
				DeniedResponse: &envoyauth.DeniedHttpResponse{
					Status: &typev3.HttpStatus{Code: typev3.StatusCode_Unauthorized},
				},
			},
		}, nil
	}

	token := strings.TrimPrefix(authHeader, "Bearer ")
	if token == "" {
		return &envoyauth.CheckResponse{
			Status: &googleapis.Status{Code: int32(codes.Unauthenticated), Message: "Bearer token missing"},
			HttpResponse: &envoyauth.CheckResponse_DeniedResponse{
				DeniedResponse: &envoyauth.DeniedHttpResponse{
					Status: &typev3.HttpStatus{Code: typev3.StatusCode_Unauthorized},
				},
			},
		}, nil
	}

	userID, err := s.service.ValidateToken(ctx, token)
	if err != nil {
		return &envoyauth.CheckResponse{
			Status: &googleapis.Status{Code: int32(codes.Unauthenticated), Message: "Invalid token"},
			HttpResponse: &envoyauth.CheckResponse_DeniedResponse{
				DeniedResponse: &envoyauth.DeniedHttpResponse{
					Status: &typev3.HttpStatus{Code: typev3.StatusCode_Unauthorized},
				},
			},
		}, nil
	}

	return &envoyauth.CheckResponse{
		Status: &googleapis.Status{Code: int32(codes.OK)},
		HttpResponse: &envoyauth.CheckResponse_OkResponse{
			OkResponse: &envoyauth.OkHttpResponse{
				Headers: []*corev3.HeaderValueOption{
					{
						Header: &corev3.HeaderValue{
							Key:   "x-user-id",
							Value: userID,
						},
					},
				},
			},
		},
	}, nil
}
