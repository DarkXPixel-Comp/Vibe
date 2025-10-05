package interceptor

import (
	"context"
	"strings"

	authgrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/auth/authgrpc"
	authproto "buf.build/gen/go/darkxpixel/vibe-contracts/protocolbuffers/go/auth"
	"google.golang.org/grpc"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/status"
)

type AuthInterceptor struct {
	AuthClient authgrpc.AuthServiceClient
}

func NewAuthInterceptor(authClient authgrpc.AuthServiceClient) *AuthInterceptor {
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

		authResp, err := i.AuthClient.ValidateToken(ctx, &authproto.ValidateTokenRequest{Token: token})
		if err != nil || !authResp.Success {
			return nil, status.Error(codes.Unauthenticated, "invalid or expired token")
		}

		ctx = context.WithValue(ctx, "user_id", authResp.GetUserId())
		return handler(ctx, req)
	}
}
