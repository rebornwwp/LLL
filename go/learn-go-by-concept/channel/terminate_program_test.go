package channel

import (
	"testing"
	"time"
)

func TestTask(t *testing.T) {
	task := Task{ticker: time.NewTicker(time.Second * 2)}
	task.Run()
	t.Log("hello")
}
