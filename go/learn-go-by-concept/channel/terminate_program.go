package channel

import (
	"fmt"
	"time"
)

type Task struct {
	closed chan struct{}
	ticker *time.Ticker
}

func NewTask() *Task {
	return &Task{
		closed: make(chan struct{}),
		ticker: time.NewTicker(time.Second * 2),
	}
}

func (self *Task) Run() {
	for {
		select {
		case <-self.ticker.C:
			handler()
		case <-self.closed:
			return
		}
	}
}

func (self *Task) Stop() {
	close(self.closed)
}

func handler() {
	for i := 0; i < 5; i++ {
		fmt.Print("#")
		time.Sleep(time.Millisecond * 200)
	}
	fmt.Println()
}
