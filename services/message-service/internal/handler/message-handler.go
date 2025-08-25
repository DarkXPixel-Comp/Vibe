package handler

import (
	protoMessage "github.com/DarkXPixel/Vibe/proto/message"
	// "google.golang.org/grpc/codes"
	// "google.golang.org/grpc/status"
)

type MessageHandler struct {
	protoMessage.UnimplementedMessageServiceServer
}

func NewMessageHandler() *MessageHandler {
	return &MessageHandler{}
}

// func (h *MessageHandler) GetState(ctx context.Context, req *protoMessage.GetStateRequest) (*protoMessage.GetStateResponse, error) {
// 	if req.UserId == "" {
// 		return nil, status.Error(codes.InvalidArgument, "user_id is null")
// 	}

// 	return nil, nil
// 	//pts, err := h.
// }
