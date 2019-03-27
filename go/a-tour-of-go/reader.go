package main

import (
	"fmt"
	"io"
	"strings"
)

// 四个读
// 但读的时候b的内存不会被清空, 可能读到最后数据不够四个的时候，
// b[:n] = "eade"
// 只读取了r，但是只是e被覆盖成r， 但是ade没有被清空，shit. b[:n] = "rade"
func main() {
	r := strings.NewReader("hello, reader")
	fmt.Println(r.Size())
	b := make([]byte, 4)
	for {
		n, err := r.Read(b)
		fmt.Printf("n = %v err = %v b = %v\n", n, err, b)
		fmt.Printf("b[:n] = %q\n", b[:])
		if err == io.EOF {
			break
		}
	}
}
