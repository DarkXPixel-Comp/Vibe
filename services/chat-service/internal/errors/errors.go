package errors

import "errors"

var (
	ErrInvalidChatType                 = errors.New("invalid chat type")
	ErrPrivateNeedOnePeer              = errors.New("private chat need exactly one peer")
	ErrDublicatePrivatePair            = errors.New("private chat between these users already exists")
	ErrInvalidUserCountForPrivateChat  = errors.New("invalid user count for private chat")
	ErrCannotCreatePrivateChatWithSelf = errors.New("cannot create private chat with self")
	ErrPrivateChatAlreadyExists        = errors.New("private chat between these users already exists")
)
