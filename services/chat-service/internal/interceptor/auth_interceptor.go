package interceptor

import (
	"context"
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
	return &AuthInterceptor{
		AuthClient: authClient,
	}
}

func (i *AuthInterceptor) Unary() grpc.UnaryServerInterceptor {
	return func(
		ctx context.Context,
		req interface{},
		info *grpc.UnaryServerInfo,
		handler grpc.UnaryHandler,
	) (interface{}, error) {

		md, ok := metadata.FromIncomingContext(ctx)
		if ok == false {
			return nil, status.Error(codes.Unauthenticated, "no metadata provided")
		}

		authHeader, ok := md["authorization"]
		if ok == false || len(authHeader) == 0 {
			return nil, status.Error(codes.Unauthenticated, "authorization header missing")
		}

		token := strings.TrimPrefix(authHeader[0], "Bearer ")
		if token == "" {
			return nil, status.Error(codes.Unauthenticated, "invalid token format")
		}

		authResp, err := i.AuthClient.ValidateToken(ctx, &protoAuth.ValidateTokenRequest{Token: token})
		if err != nil || !authResp.Success {
			return nil, status.Error(codes.Unauthenticated, "invalid or expired token")
		}

		ctx = context.WithValue(ctx, "user_id", authResp.GetUserId())
		return handler(ctx, req)
	}
}
