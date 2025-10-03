package main

import (
	"fmt"
	"math"
)

// decimal to binary floating point conversion.
// Algorithm:
//   1) Store input in multiprecision decimal.
//   2) Multiply/divide decimal by powers of two until in range [0.5, 1)
//   3) Multiply by 2^precision and round to get mantissa.

var optimize = true // set to false to force slow-path conversions for testing

func equalIgnoreCase(s1, s2 string) bool {
	// 判断两个字符串在不区分大小写的情况下，是否相同
	if len(s1) != len(s2) {
		return false
	}
	for i := 0; i < len(s1); i++ {
		c1 := s1[i]
		if 'A' <= c1 && c1 <= 'Z' {
			c1 += 'a' - 'A'
		}
		c2 := s2[i]
		if 'A' <= c2 && c2 <= 'Z' {
			c2 += 'a' - 'A'
		}
		fmt.Println(c1, c2)
		if c1 != c2 {
			return false
		}
	}
	return true
}

func special(s string) (f float64, ok bool) {
	// 将字符串表示的无限大的数，和无限小的数转换成真实的无限大和无限小的数
	if len(s) == 0 {
		return
	}

	switch s[0] {
	default:
		return
	case '+':
		if equalIgnoreCase(s, "+inf") || equalIgnoreCase(s, "+infinity") {
			return math.Inf(1), true
		}
	case '-':
		if equalIgnoreCase(s, "-inf") || equalIgnoreCase(s, "-infinity") {
			return math.Inf(-1), true
		}
	case 'n', 'N':
		if equalIgnoreCase(s, "nan") {
			return math.NaN(), true
		}
	case 'i', 'I':
		if equalIgnoreCase(s, "inf") || equalIgnoreCase(s, "infinity") {
			return math.Inf(1), true
		}
	}
	return
}

func main() {
	fmt.Println('a' - 'A')
	fmt.Println(string('a'))
	fmt.Println('A')
	fmt.Println(equalIgnoreCase("hello", "heLLO"))
	fmt.Println(special("inf"))
	fmt.Println(special("infl"))
}
