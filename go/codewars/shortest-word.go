package main

import (
	"fmt"
	"strings"
)

// FindShort function
func FindShort(s string) int {
	words := strings.Split(strings.Trim(s, " "), " ")
	total := -1
	for i, word := range words {
		if i == 0 {
			total = len(word)
		} else if len(word) < total && word != " " {
			total = len(word)
		}
	}
	return total
}

func main() {
	s := strings.Trim(" hhhl      jkj    ", " ")
	words := strings.Split(s, " ")
	fmt.Println(words)
	fmt.Println(FindShort("bitcoin take over the world maybe who knows perhaps"))
}
