FROM golang:1.24.4 AS builder
RUN apt-get update && apt-get install -y protobuf-compiler \
 && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.29.0 \
 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

WORKDIR /app
ENV PATH="$PATH:$(go env GOPATH)/bin"

COPY go.work ./
COPY proto/go.mod proto/go.sum ./proto/
COPY services/auth-service/go.mod services/auth-service/go.sum ./services/auth-service/
COPY services/user-service/go.mod services/user-service/go.sum ./services/user-service/
COPY services/chat-service/go.mod services/chat-service/go.sum ./services/chat-service/
COPY services/message-service/go.mod services/message-service/go.sum ./services/message-service/

RUN go mod download -x

COPY proto ./proto
COPY services/auth-service ./services/auth-service
COPY services/user-service ./services/user-service
COPY services/chat-service ./services/chat-service
COPY services/message-service ./services/message-service

RUN protoc \
  --proto_path=proto \
  --go_out=paths=source_relative:proto \
  --go-grpc_out=paths=source_relative:proto \
  proto/chat/chat.proto proto/user/user.proto proto/auth/auth.proto proto/common/types.proto proto/message/message.proto


WORKDIR /app/services/auth-service

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o auth-service ./cmd/main.go

# FROM golang:1.24.4 AS debugger
# RUN go install github.com/go-delve/cmd/dlv@latest
# COPY --from=builder /app/services/auth-service /debug_app/auth-service
# COPY --from=builder /app/services/auth-service/config/docker.yaml /debug_app/config/docker.yaml
# ENTRYPOINT ["dlv", "exec", "/debug_app/auth-service", "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient"]

FROM gcr.io/distroless/static:nonroot
COPY --from=builder /app/services/auth-service/auth-service /app/auth-service
COPY --from=builder /app/services/auth-service/config/docker.yaml /app/config/docker.yaml 

ENTRYPOINT ["/app/auth-service"]
