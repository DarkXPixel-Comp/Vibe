package main

import (
	"context"
	"fmt"
	"log"
	"log/slog"
	"net"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/DarkXPixel/Vibe/proto/auth"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/database"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/handler"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"

	envoyauth "github.com/envoyproxy/go-control-plane/envoy/service/auth/v3"
)

type App struct {
	grpcServer *grpc.Server
	_authService service.AuthService
	handler      *handler.AuthHandler
	log          *slog.Logger
	config       *config.Config
	db           *pgxpool.Pool
	redis        repository.RedisRepository
	userClient   repository.UserClientInterface
}

func initApp() (*App, error) {
	var app App
	conf, err := config.LoadConfig()
	if err != nil {
		return nil, fmt.Errorf("error load config: %w", err)
	}
	app.config = conf

	for i := 0; i < 30; i++ {
		db, err := database.ConnectDB(conf.DB)
		if err == nil {
			app.db = db
			log.Println("PostgreSQL is ready")
			break
		}
		log.Printf("Attempt %d/%d: PostgreSQL not ready (%s)", i, 29, err.Error())
		time.Sleep(2 * time.Second)
	}
	if app.db == nil {
		return nil, fmt.Errorf("postgreSQL is not ready")
	}

	app.redis = repository.NewRedisRepository(&conf.Redis)
	if err := app.redis.PingRedis(context.Background()); err != nil {
		return nil, fmt.Errorf("error connect redis: %w", err)
	}

	userClient, err := repository.NewUserClient(fmt.Sprintf("%s:%s", app.config.UserService.Host, app.config.UserService.Port))
	if err != nil {
		return nil, fmt.Errorf("error connect user-service:%w", err)
	}

	app.userClient = userClient
	app.grpcServer = grpc.NewServer()
	app._authService = service.NewAuthSevice(app.redis, &conf.JWT, &conf.Session, app.db, app.userClient)
	app.handler = handler.NewAuthHandler(app._authService)

	auth.RegisterAuthServiceServer(app.grpcServer, app.handler)
	envoyauth.RegisterAuthorizationServer(app.grpcServer, app.handler)

	app.log = slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(app.log)

	return &app, nil
}

func (a *App) run() error {
	const op = "auth-service.run"

	log := a.log.With(
		slog.String("op", op),
		slog.Int("port", a.config.GRPC.Port),
	)

	l, err := net.Listen("tcp", fmt.Sprintf(":%d", a.config.GRPC.Port))
	if err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	log.Info("grpc auth-service is running", slog.String("addr", l.Addr().String()))

	if err := a.grpcServer.Serve(l); err != nil {
		return fmt.Errorf("%s: %w", op, err)
	}

	return nil
}

func (a *App) stop() {
	const op = "auth-service.stop"

	a.log.With(slog.String("op", op)).
		Info("stopping gRPC auth-service", slog.Int("port", a.config.GRPC.Port))

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