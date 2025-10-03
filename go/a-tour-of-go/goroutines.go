package main

import (
	"fmt"
)

func say(s string) {
	total := 0
	for i := 0; i < 1000; i++ {
		total += i
	}
	fmt.Println(total)
}

func main() {
	// 有问题的输出估计是没有同步
	go say("hello world")
	go say("hello")
	go say("hello")
	go say("hello")
	go say("hello")
	go say("hello")
	go say("hello")
	go say("hello")
	say("hello")
}
