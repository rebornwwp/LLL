package main

import (
	"fmt"
	"os"
	"sort"

	"learn-go-by-concept/channelbasic"
)

func main() {
	m, err := channelbasic.MD5AllWithLimit(os.Args[1])
	if err != nil {
		fmt.Println(err)
		return
	}
	var paths []string
	for path := range m {
		paths = append(paths, path)
	}
	sort.Strings(paths)
	for _, path := range paths {
		fmt.Printf("%x  %s\n", m[path], path)
	}
}
