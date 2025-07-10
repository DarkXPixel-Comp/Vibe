package main

import (
	"context"
	"fmt"
	"log/slog"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/DarkXPixel/Vibe/proto/auth"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/database"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/handler"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
)

type App struct {
	grpcServer *grpc.Server
	//authServer *internal.AuthServer
	_authService service.AuthService
	handler      *handler.AuthHandler
	log          *slog.Logger
	config       *config.Config
	db           *pgxpool.Pool
	redis        repository.RedisRepository
}

func initApp() (*App, error) {
	var app App
	conf, err := config.LoadConfig()
	if err != nil {
		return nil, fmt.Errorf("error load config: %w", err)
	}
	app.config = conf

	db, err := database.ConnectDB(conf.DB)
	if err != nil {
		return nil, fmt.Errorf("failed connect db: %w", err)
	}

	app.redis = repository.NewRedisRepository(&conf.Redis)
	if err := app.redis.PingRedis(context.Background()); err != nil {
		return nil, fmt.Errorf("error connect redis: %w", err)
	}
	//creds, err := credentials.NewClientTLSFromCert()

	app.db = db
	app.grpcServer = grpc.NewServer()
	app._authService = service.NewAuthSevice(app.redis, &conf.JWT, app.db)
	app.handler = handler.NewAuthHandler(app._authService)

	//auth.RegisterAuthServiceServer(app.grpcServer, app.authService)
	auth.RegisterAuthServiceServer(app.grpcServer, app.handler)

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
		//log.Fatalf("error initApp: %w", err)
		panic(err)
	}
	go app.run()

	stop := make(chan os.Signal, 1)
	signal.Notify(stop, syscall.SIGTERM, syscall.SIGINT)

	<-stop

	app.stop()

	// conf, err := config.LoadConfig()
	// if err != nil {
	// 	log.Fatalf("error load config: %v", err)
	// }

	// log.Print(conf)

	// lis, err := net.Listen("tcp", ":50051")
	// if err != nil {
	// 	log.Fatalf("Failed to listen: %v", err)
	// }

	// grpcServer := grpc.NewServer()

	// authServer := internal.NewAuthServer(nil, nil)

	// authpb.RegisterAuthServiceServer(grpcServer, authServer)

	// log.Println("Auth service listening on :50051")
	// if err := grpcServer.Serve(lis); err != nil {
	// 	log.Fatalf("Failed to serve: %v", err)
	// }

	// cfg := internal.LoadConfig()
	// err := internal.RunMigrate(cfg.DatabaseURL)
	// if err != nil {
	// 	log.Fatalf("Migration is NOT OK: %v", err)
	// }
	// db, err := internal.ConnectDB(cfg.DatabaseURL)
	// if err != nil {
	// 	log.Fatalf("Failed to connect to DB: %v", err)
	// }
	// defer db.Close()

	// lis, err := net.Listen("tcp", ":50051")
	// if err != nil {
	// 	log.Fatalf("Failed to listen: %v", err)
	// }

	// grpcServer := grpc.NewServer()

	// authServer := internal.NewAuthServer(db, cfg)

	// authpb.RegisterAuthServiceServer(grpcServer, authServer)

	// log.Println("Auth service listening on :50051")
	// if err := grpcServer.Serve(lis); err != nil {
	// 	log.Fatalf("Failed to serve: %v", err)
	// }
}
