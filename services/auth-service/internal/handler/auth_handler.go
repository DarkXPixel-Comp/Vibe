package handler

import (
	"context"
	"fmt"
	"strings"

	"github.com/DarkXPixel/Vibe/proto/auth"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/service"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/utils"
	corev3 "github.com/envoyproxy/go-control-plane/envoy/config/core/v3"
	envoyauth "github.com/envoyproxy/go-control-plane/envoy/service/auth/v3"
	typev3 "github.com/envoyproxy/go-control-plane/envoy/type/v3"
	googleapis "google.golang.org/genproto/googleapis/rpc/status"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type AuthHandler struct {
	auth.UnimplementedAuthServiceServer
	envoyauth.UnimplementedAuthorizationServer
	service service.AuthService
}

func NewAuthHandler(service service.AuthService) *AuthHandler {
	return &AuthHandler{
		service: service,
	}
}

func (s *AuthHandler) SendVerificationCode(ctx context.Context, req *auth.PhoneNumberRequest) (*auth.SendCodeResponse, error) {
	phoneNumber, err := utils.ValidatePhoneNumber(req.GetPhoneNumber())
	if err != nil {
		return nil, status.Errorf(codes.InvalidArgument, "invalid phone number: %v", err)
	}

	tok, err := s.service.SendCode(ctx, phoneNumber)
	if err != nil {
		return &auth.SendCodeResponse{
			Success: false,
			Message: "error send code",
			Token:   "",
		}, status.Errorf(codes.Internal, "internal error: %s", err)
	}

	return &auth.SendCodeResponse{
		Success: true,
		Message: "its ok",
		Token:   tok,
	}, nil
}

func (s *AuthHandler) VerifyCode(ctx context.Context, req *auth.VerifyCodeRequest) (*auth.AuthResponse, error) {
	response, err := s.service.VerifyCode(ctx, req.GetToken(), req.GetCode(), req.GetDeviceId(), req.GetDeviceName())
	if err != nil {
		return &auth.AuthResponse{
			Success:   false,
			AuthToken: "",
			UserId:    "",
			Message:   fmt.Sprintf("Wrong code: %s", err.Error()),
		}, nil
	}

	return &auth.AuthResponse{
		Success:    true,
		AuthToken:  response.Token,
		UserId:     response.User_id,
		SessionKey: response.SessionKey,
	}, nil
}

func (s *AuthHandler) ValidateToken(ctx context.Context, req *auth.ValidateTokenRequest) (*auth.ValidateTokenRespone, error) {
	user_id, err := s.service.ValidateToken(ctx, req.GetToken())
	if err != nil {
		return nil, status.Errorf(codes.NotFound, "invalid token")
	}

	return &auth.ValidateTokenRespone{
		Success: true,
		UserId:  user_id,
	}, nil
}

func (s *AuthHandler) ListSessions(ctx context.Context, req *auth.ListSessionsRequest) (*auth.ListSessionsResponse, error) {
	userID, ok := s.getUserIDFromContext(ctx)
	if !ok {
		return nil, status.Errorf(codes.Unauthenticated, "user ID not found in context")
	}

	sessions, err := s.service.ListSessions(ctx, userID, req.GetCurrentSessionToken())
	if err != nil {
		return nil, err // The service layer should return a gRPC status error
	}

	protoSessions := make([]*auth.Session, len(sessions))
	for i, session := range sessions {
		protoSessions[i] = &auth.Session{
			Id:         session.ID,
			DeviceName: session.DeviceName,
			IsCurrent:  session.IsCurrent,
			LastUsedAt: session.LastUsedAt,
			CreatedAt:  session.CreatedAt,
		}
	}

	return &auth.ListSessionsResponse{Sessions: protoSessions}, nil
}

func (s *AuthHandler) RevokeSession(ctx context.Context, req *auth.RevokeSessionRequest) (*auth.RevokeSessionResponse, error) {
	userID, ok := s.getUserIDFromContext(ctx)
	if !ok {
		return nil, status.Errorf(codes.Unauthenticated, "user ID not found in context")
	}

	err := s.service.RevokeSession(ctx, req.GetSessionId(), userID)
	if err != nil {
		return nil, err // The service layer should return a gRPC status error
	}

	return &auth.RevokeSessionResponse{Success: true}, nil
}

func (s *AuthHandler) Check(ctx context.Context, req *envoyauth.CheckRequest) (*envoyauth.CheckResponse, error) {
	headers := req.Attributes.Request.Http.Headers
	authHeader, ok := headers["authorization"]
	if !ok || !strings.HasPrefix(authHeader, "Bearer ") {
		return s.deniedResponse(codes.Unauthenticated, "missing Authorization header"), nil
	}

	token := strings.TrimPrefix(authHeader, "Bearer ")
	response, err := s.ValidateToken(ctx, &auth.ValidateTokenRequest{Token: token})
	if err != nil {
		return s.deniedResponse(codes.Unauthenticated, "invalid token"), nil
	}

	if !response.Success {
		return s.deniedResponse(codes.Unauthenticated, "invalid token"), nil
	}

	return s.okResponse(response.GetUserId()), nil
}

func (s *AuthHandler) getUserIDFromContext(ctx context.Context) (string, bool) {
	md, ok := metadata.FromIncomingContext(ctx)
	if !ok {
		return "", false
	}
	values := md.Get("x-user-id")
	if len(values) == 0 {
		return "", false
	}
	return values[0], true
}

func (s *AuthHandler) deniedResponse(code codes.Code, message string) *envoyauth.CheckResponse {
	return &envoyauth.CheckResponse{
		Status:       &googleapis.Status{Code: int32(code), Message: message},
		HttpResponse: &envoyauth.CheckResponse_DeniedResponse{DeniedResponse: &envoyauth.DeniedHttpResponse{Status: &typev3.HttpStatus{Code: typev3.StatusCode_Unauthorized}}},
	}
}

func (s *AuthHandler) okResponse(userID string) *envoyauth.CheckResponse {
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
	}
}