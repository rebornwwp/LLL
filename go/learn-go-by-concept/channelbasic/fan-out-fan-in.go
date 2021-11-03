package channelbasic

import (
	"sync"
)

// fan in
func merge(done <-chan struct{}, cs ...<-chan int) <-chan int {
	var wg sync.WaitGroup

	out := make(chan int)
	mapChannelFunc := func(c <-chan int) {
		for n := range c {
			select {
			case out <- n:
			case <-done:
			}
		}
		wg.Done()
	}

	wg.Add(len(cs))
	for _, c := range cs {
		go mapChannelFunc(c)
	}

	go func() {
		wg.Wait()
		close(out)
	}()

	return out
}
