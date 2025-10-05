FROM golang:1.24.4 AS builder
RUN apt-get update && apt-get install -y protobuf-compiler \
 && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.29.0 \
 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@v4.17.0 \
    && ls -l /go/bin/migrate

WORKDIR /app
ENV PATH="$PATH:$(go env GOPATH)/bin"

COPY go.work ./
COPY proto/go.mod proto/go.sum ./proto/
COPY services/auth-service/go.mod services/auth-service/go.sum ./services/auth-service/
COPY services/user-service/go.mod services/user-service/go.sum ./services/user-service/
COPY services/chat-service/go.mod services/chat-service/go.sum ./services/chat-service/
COPY services/message-service/go.mod services/message-service/go.sum ./services/message-service/
COPY services/sync-service/go.mod services/sync-service/go.sum ./services/sync-service/

RUN go mod download -x


COPY proto ./proto
COPY services/auth-service ./services/auth-service
COPY services/user-service ./services/user-service
COPY services/chat-service ./services/chat-service
COPY services/message-service ./services/message-service
COPY services/sync-service ./services/sync-service

RUN protoc \
  --proto_path=proto \
  --go_out=paths=source_relative:proto \
  --go-grpc_out=paths=source_relative:proto \
  proto/chat/chat.proto proto/user/user.proto proto/auth/auth.proto proto/common/types.proto proto/message/message.proto proto/sync/sync.proto


WORKDIR /app/services/user-service

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o user-service ./cmd/main.go

# FROM golang:1.24.4 AS debugger
# RUN go install github.com/go-delve/cmd/dlv@latest
# COPY --from=builder /app/services/auth-service /debug_app/auth-service
# COPY --from=builder /app/services/auth-service/config/docker.yaml /debug_app/config/docker.yaml
# ENTRYPOINT ["dlv", "exec", "/debug_app/auth-service", "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient"]

FROM alpine:3.19
RUN apk add --no-cache postgresql-client
COPY --from=builder /app/services/user-service/user-service /app/user-service
COPY --from=builder /app/services/user-service/migrations /app/migrations
COPY --from=builder /go/bin/migrate /app/migrate
RUN chmod +x /app/migrate


ENTRYPOINT ["/app/user-service"]
