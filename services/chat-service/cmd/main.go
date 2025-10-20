package main

import (
	"fmt"
	"log/slog"
	"net"
	"os"
	"os/signal"
	"syscall"

	authgrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/auth/authgrpc"
	chatgrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/chat/chatgrpc"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/handler"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type App struct {
	grpcServer     *grpc.Server
	db             *pgxpool.Pool
	config         *config.Config
	authConn       *grpc.ClientConn
	authClient     authgrpc.AuthServiceClient
	handler        *handler.ChatGRPCHandler
	chatRepository *repository.ChatRepository
	chatService    *service.ChatService
	log            *slog.Logger
}

func initApp() (*App, error) {
	var app App
	conf, err := config.LoadConfig()
	if err != nil {
		return nil, fmt.Errorf("error load config: %w", err)
	}
	app.config = conf

	db, err := repository.ConnectDB(&app.config.DB)
	if err != nil {
		return nil, fmt.Errorf("failed connect db: %s", err)
	}

	app.db = db
	chat_repository := repository.CreateChatRepository(app.db)
	app.chatRepository = &chat_repository

	authConn, err := grpc.NewClient(fmt.Sprintf("%s:%d", app.config.AuthService.Host, app.config.AuthService.Port),
		grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to connect AuthService: %w", err)
	}

	app.authConn = authConn
	app.authClient = authgrpc.NewAuthServiceClient(authConn)

	app.grpcServer = grpc.NewServer()
	chat_service := service.NewChatService(app.chatRepository)
	app.chatService = chat_service
	app.handler = handler.NewChatGRPCHandler(chat_service)

	chatgrpc.RegisterChatServiceServer(app.grpcServer, app.handler)

	app.log = slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(app.log)

	return &app, nil
}

func (a *App) run() error {
	const op = "user-service.run"

	log := a.log.With(
		slog.String("op", op),
		slog.Int("port", a.config.GRPC.Port),
	)

	l, err := net.Listen("tcp", fmt.Sprintf(":%d", a.config.GRPC.Port))
	if err != nil {
		return fmt.Errorf("fail listen: %w", err)
	}

	log.Info("grpc chat-service is running", slog.String("addr", l.Addr().String()))
	if err := a.grpcServer.Serve(l); err != nil {
		return fmt.Errorf("error serve: %w", err)
	}

	return nil
}

func (a *App) stop() {
	a.grpcServer.GracefulStop()
	a.authConn.Close()
	a.db.Close()
}

func main() {
	app, err := initApp()
	if err != nil {
		panic(err)
	}

	go app.run()

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGTERM, syscall.SIGINT)
	<-stop
	app.stop()
}
