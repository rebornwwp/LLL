package channelbasic

import "testing"

func TestFanIn(t *testing.T) {
	done := make(chan struct{})
	for c := range merge(done, gen1(done, 1, 2), gen1(done, 3, 4)) {
		t.Log(c)
	}

	result := merge(done, gen1(done, 1, 2), gen1(done, 3, 4))
	x := <-result
	t.Log(x)
	close(done)

	// close(done)
	// t.Log("hello")
	// x := <-done
	// t.Log(x)
	// x = <-done
	// t.Log(x)

}
