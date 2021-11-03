package main

import (
	"fmt"
	"learn-go-by-concept/channel"
	"os"
	"os/signal"
)

func main() {
	task := channel.NewTask()

	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt)
	go func() {
		sig := <-c
		fmt.Printf("Got %s signal. Aborting...\n", sig)
		task.Stop()
		os.Exit(1)
	}()
	task.Run()
}
