package main

import (
	"os"
	"os/signal"
	"syscall"

	"github.com/jackc/pgx/v5/pgxpool"
)

type App struct {
	db *pgxpool.Pool
}

func initApp() (*App, error) {
	var app App

	return &app, nil
}

func (a *App) run() error {
	return nil
}

func (a *App) stop() {

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
