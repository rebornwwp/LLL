package channelbasic

import "testing"

func TestPipelineChan(t *testing.T) {

	out := sq(gen(1, 2, 3, 4, 5, 6, 7, 8))

	for c := range out {
		t.Log(c)
	}

	out = sq(sq(gen(1, 2, 3, 4, 5, 6, 7, 8)))
	for c := range out {
		t.Log(c)
	}
}
