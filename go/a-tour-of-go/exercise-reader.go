package main

import "fmt"

type MyReader struct{}

func (reader MyReader) Read(b []byte) (int, error) {
	for i := 0; i < len(b); i++ {
		b[i] = 'A'
	}
	return len(b), nil
}

func main() {
	fmt.Println(MyReader{})
}
