package main

import (
	"fmt"
	"log/slog"
	"net"
	"os"
	"os/signal"
	"syscall"

	protoMessage "github.com/DarkXPixel/Vibe/proto/message"
	"github.com/DarkXPixel/Vibe/services/message-service/internal/config"
	"github.com/DarkXPixel/Vibe/services/message-service/internal/handler"
	"github.com/jackc/pgx/v5/pgxpool"
	"google.golang.org/grpc"
)

type App struct {
	grpcServer *grpc.Server
	db         *pgxpool.Pool
	config     *config.Config
	log        *slog.Logger
	handler    *handler.MessageHandler
}

func initApp() (*App, error) {
	var app App
	conf, err := config.LoadConfig()
	if err != nil {
		return nil, fmt.Errorf("error load config: %w", err)
	}
	app.config = conf

	app.grpcServer = grpc.NewServer()
	app.handler = handler.NewMessageHandler()

	protoMessage.RegisterMessageServiceServer(app.grpcServer, app.handler)

	app.log = slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(app.log)

	return &app, nil
}

func (a *App) run() error {
	const op = "message-service.run"
	log := a.log.With(
		slog.String("op", op),
		slog.Int("port", a.config.GRPC.Port),
	)

	l, err := net.Listen("tcp", fmt.Sprintf(":%d", a.config.GRPC.Port))
	if err != nil {
		return fmt.Errorf("fail listen: %w", err)
	}

	log.Info("grpc message-service is running", slog.String("addr", l.Addr().String()))
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
