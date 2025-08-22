package handler

import (
	protoMessage "github.com/DarkXPixel/Vibe/proto/message"
)

type MessageHandler struct {
	protoMessage.UnimplementedMessageServiceServer
}

func NewMessageHandler() *MessageHandler {
	return &MessageHandler{}
}
