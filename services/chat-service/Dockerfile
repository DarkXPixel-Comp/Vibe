FROM golang:1.24.4 AS builder
RUN apt-get update && apt-get install -y protobuf-compiler \
 && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.29.0 \
 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3.0

ENV BIN="/usr/local/bin" \
    VERSION="1.57.2"

RUN curl -sSL \
    "https://github.com/bufbuild/buf/releases/download/v${VERSION}/buf-$(uname -s)-$(uname -m)" \
    -o "${BIN}/buf" \
 && chmod +x "${BIN}/buf"

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@v4.17.0 \
    && ls -l /go/bin/migrate

WORKDIR /app
ENV PATH="$PATH:$(go env GOPATH)/bin"
ENV GOPRIVATE=buf.build
ENV GONOSUMDB=buf.build

RUN --mount=type=secret,id=buf_token \
    buf registry login buf.build --token-stdin < /run/secrets/buf_token

COPY go.mod go.sum ./
RUN go mod download -x

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o out/service ./cmd/main.go

FROM alpine:3.19
RUN apk add --no-cache postgresql-client
COPY --from=builder /app/out/service /app/service
COPY --from=builder /app/migrations /app/migrations
COPY --from=builder /go/bin/migrate /app/migrate
RUN chmod +x /app/migrate

ENTRYPOINT ["/app/service"]

