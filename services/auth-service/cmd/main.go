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

	//"github.com/DarkXPixel/Vibe/proto/auth"
	//authgrpc "buf.build/gen/go/darkxpixel/vibe-contracts/grpc/go/auth/authgrpc"

	"github.com/DarkXPixel/Vibe/services/auth-service/internal/bootstrap"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/repository"
	"github.com/DarkXPixel/Vibe/services/auth-service/internal/service"
	"google.golang.org/grpc"
	//"github.com/DarkXPixel/Vibe/services/auth-service/internal/handler"
)

type App struct {
	config     *config.Config
	grpcServer *grpc.Server
	service    *service.AuthService
	postgres   *repository.Postgres
	redis      *repository.Redis
	keys       *bootstrap.ServerKeys
	// //authServer *internal.AuthServer
	// _authService service.AuthService
	// handler      *handler.AuthHandler
	log *slog.Logger
	// config       *config.Config
	// db           *pgxpool.Pool
	// redis        repository.RedisRepository
	// userClient   repository.UserClient
}

func initApp() (*App, error) {
	ctx := context.Background()
	var app App
	conf, err := config.LoadConfig()
	if err != nil {
		return nil, fmt.Errorf("error load config: %w", err)
	}

	app.config = conf
	app.keys = bootstrap.MustLoadServerKeys()

	for i := 0; i < 30; i++ {
		db, err := repository.NewPostgres(ctx, fmt.Sprintf(
			"postgres://%s:%s@%s:%s/%s?sslmode=%s",
			conf.DB.User,
			conf.DB.Password,
			conf.DB.Host,
			conf.DB.Port,
			conf.DB.DBName,
			conf.DB.SSLMode))
		if err == nil {
			app.postgres = db
			log.Println("PostgreSQL is ready")
			break
		}
		log.Printf("Attempt %d/%d: PostgreSQL not ready (%s)", i, 29, err.Error())
		time.Sleep(2 * time.Second)
	}
	if app.postgres == nil {
		return nil, fmt.Errorf("postgreSQL is not ready")
	}

	app.redis = repository.NewRedis(fmt.Sprintf("%s:%s", conf.Redis.Host, conf.Redis.Port), conf.Redis.Password, 0)
	app.service = service.NewAuthService(app.postgres, app.redis, app.keys.Priv, app.keys.Pub, nil)

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
}
