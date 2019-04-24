package main

import (
	"fmt"
	"strconv"
)

// lower(c) is a lower-case letter if and only if
// c is either that lower-case letter or the equivalent upper-case letter.
// Instead of writing c == 'x' || c == 'X' one can write lower(c) == 'x'.
// Note that lower of non-letters can produce other non-letters.
func lower(c byte) byte {
	// 将大写字母变换成小写字母, 将倒数第六位置1就好了
	return c | ('a' - 'A')
}

func main() {
	var isGraphic = []uint16{
		0x00a0,
		0x1680,
		0x2000,
		0x2001,
		0x2002,
		0x2003,
		0x2004,
		0x2005,
		0x2006,
		0x2007,
		0x2008,
		0x2009,
		0x200a,
		0x202f,
		0x205f,
		0x3000,
	}
	fmt.Println(isGraphic)
	fmt.Println('x' - 'X')
	fmt.Println(string(lower('B')))
	fmt.Println(strconv.ParseInt("+123", 10, 10))
}
