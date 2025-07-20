package main

import (
	"fmt"
	"os"
	"os/signal"
	"syscall"

	protoAuth "github.com/DarkXPixel/Vibe/proto/auth"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/chat-service/internal/interceptor"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

type App struct {
	grpcServer      *grpc.Server
	db              *pgxpool.Pool
	config          *config.Config
	authConn        *grpc.ClientConn
	authClient      protoAuth.AuthServiceClient
	authInterceptor *interceptor.AuthInterceptor
}

func initApp() (*App, error) {
	var app App
	conf, err := config.LoadConfig()
	if err != nil {
		return nil, fmt.Errorf("error load config: %w", err)
	}
	app.config = conf

	authConn, err := grpc.NewClient(fmt.Sprintf("%s:%d", app.config.AuthService.Host, app.config.AuthService.Port),
		grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		return nil, fmt.Errorf("failed to connect AuthService: %w", err)
	}

	app.authConn = authConn
	app.authClient = protoAuth.NewAuthServiceClient(authConn)
	app.authInterceptor = interceptor.NewAuthInterceptor(app.authClient)

	app.grpcServer = grpc.NewServer(grpc.UnaryInterceptor(app.authInterceptor.Unary()))

	return &app, nil
}

func (a *App) run() error {
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
