package main

import (
	"fmt"
	"log/slog"
	"net"
	"os"
	"os/signal"
	"syscall"

	protoAuth "github.com/DarkXPixel/Vibe/proto/auth"
	protoSync "github.com/DarkXPixel/Vibe/proto/sync"
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/handler"
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/interceptor"
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/sync-service/internal/service"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type App struct {
	grpcServer      *grpc.Server
	authClient      protoAuth.AuthServiceClient
	authConn        *grpc.ClientConn
	authInterceptor *interceptor.AuthInterceptor
	syncRepository  repository.SyncRepository
	syncService     service.SyncService
	handler         *handler.SyncHandler
	db              *pgxpool.Pool
	config          *config.Config
	log             *slog.Logger
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
		return nil, fmt.Errorf("failed to connect db: %w", err)
	}
	app.db = db

	authConn, err := grpc.NewClient(fmt.Sprintf("%s:%d", app.config.AuthService.Host, app.config.AuthService.Port),
		grpc.WithTransportCredentials(insecure.NewCredentials()))

	app.authConn = authConn
	app.authClient = protoAuth.NewAuthServiceClient(app.authConn)
	app.syncRepository = repository.NewSyncRepository(db)

	app.authInterceptor = interceptor.NewAuthInterceptor(app.authClient)
	app.grpcServer = grpc.NewServer(grpc.UnaryInterceptor(app.authInterceptor.Unary()))
	app.syncService = service.NewSyncService()
	app.handler = handler.NewSyncHandler(app.syncService)

	protoSync.RegisterSyncServiceServer(app.grpcServer, app.handler)

	app.log = slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(app.log)

	return &app, nil
}

func (a *App) run() error {
	const op = "sync-service.run"

	log := a.log.With(
		slog.String("op", op),
		slog.Int("port", a.config.GRPC.Port),
	)

	l, err := net.Listen("tcp", fmt.Sprintf(":%d", a.config.GRPC.Port))
	if err != nil {
		return fmt.Errorf("fail listen: %w", err)
	}

	log.Info("grpc sync-service is running", slog.String("addr", l.Addr().String()))
	if err := a.grpcServer.Serve(l); err != nil {
		return fmt.Errorf("error serve: %w", err)
	}
	return nil
}

func (a *App) stop() {
	a.grpcServer.GracefulStop()
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
