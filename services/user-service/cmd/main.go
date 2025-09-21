package main

import (
	"fmt"
	"log/slog"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/DarkXPixel/Vibe/proto/user"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/handler"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/user-service/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
)

type App struct {
	grpcServer     *grpc.Server
	db             *pgxpool.Pool
	config         *config.Config
	log            *slog.Logger
	userService    service.UserService
	userRepository *repository.UserRepository
	handler        *handler.UserHandler
}

func initApp() (*App, error) {
	var app App
	conf, err := config.LoadConfig()
	if err != nil {
		return nil, fmt.Errorf("error load config: %w", err)
	}
	app.config = conf

	db, err := repository.ConnectDB(&app.config.Postgres)
	if err != nil {
		return nil, fmt.Errorf("failed connect db: %s", err)
	}
	app.db = db
	user_repository := repository.NewUserRepository(app.db)
	app.userRepository = &user_repository

	app.grpcServer = grpc.NewServer()
	app.userService = service.NewUserService(user_repository)
	app.handler = handler.NewUserHandler(app.userService)

	user.RegisterUserServiceServer(app.grpcServer, app.handler)

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

	log.Info("grpc user-service is running", slog.String("addr", l.Addr().String()))
	if err := a.grpcServer.Serve(l); err != nil {
		return fmt.Errorf("error serve: %w", err)
	}

	return nil
}

func (a *App) stop() {
	a.grpcServer.GracefulStop()
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
