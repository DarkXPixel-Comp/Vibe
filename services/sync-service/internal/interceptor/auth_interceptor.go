package interceptor

import (
	"context"
	"fmt"
	"strings"

	protoAuth "github.com/DarkXPixel/Vibe/proto/auth"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type AuthInterceptor struct {
	AuthClient protoAuth.AuthServiceClient
}

func NewAuthInterceptor(authClient protoAuth.AuthServiceClient) *AuthInterceptor {
	return &AuthInterceptor{AuthClient: authClient}
}

type userRequest interface {
	GetUserId() string
}

func (i *AuthInterceptor) Unary() grpc.UnaryServerInterceptor {
	return func(
		ctx context.Context,
		req interface{},
		info *grpc.UnaryServerInfo,
		handler grpc.UnaryHandler,
	) (interface{}, error) {
		md, ok := metadata.FromIncomingContext(ctx)
		if !ok {
			return nil, status.Error(codes.Unauthenticated, "authorization header missing")
		}

		authHeader, ok := md["authorization"]
		if !ok || len(authHeader) == 0 {
			return nil, status.Error(codes.Unauthenticated, "authorization header missing")
		}
		token := strings.TrimPrefix(authHeader[0], "Bearer ")
		if token == "" {
			return nil, status.Error(codes.Unauthenticated, "invalid token format")
		}

		authResp, err := i.AuthClient.ValidateToken(ctx, &protoAuth.ValidateTokenRequest{Token: token})
		if err != nil || !authResp.Success {
			return nil, status.Errorf(codes.Unauthenticated, "invalid or expired token: %s", err.Error())
		}

		fmt.Println("itttttt issss okk")

		user_id := authResp.GetUserId()
		ctx = context.WithValue(ctx, "user_id", user_id)

		switch r := req.(type) {
		case userRequest:
			if r.GetUserId() != user_id {
				return nil, status.Error(codes.PermissionDenied, "user_id does not match token")
			}
		default:
			return nil, status.Error(codes.InvalidArgument, "unknown request type")
		}
		return handler(ctx, req)
	}
}
