package channelbasic

func gen(nums ...int) <-chan int {
	out := make(chan int)
	go func() {
		for _, n := range nums {
			out <- n
		}
		close(out)
	}()
	return out
}

func sq(in <-chan int) <-chan int {
	out := make(chan int)
	go func() {
		for n := range in {
			out <- n * n
		}
		close(out)
	}()
	return out
}

func gen1(done <-chan struct{}, nums ...int) <-chan int {
	out := make(chan int, len(nums))
	go func() {
		defer close(out)
		for _, n := range nums {
			select {
			case out <- n:
			case <-done:
				return
			}
		}
	}()
	return out
}

func sq1(done <-chan struct{}, nums <-chan int) <-chan int {

	out := make(chan int)

	go func() {
		defer close(out)
		for n := range nums {
			select {
			case out <- n * n:
			case <-done:
				return
			}
		}
	}()

	return out
}
