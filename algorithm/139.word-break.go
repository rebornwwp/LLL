package main

import (
	"fmt"
	"sort"
)

func main() {
	s := "catsanddog"
	wordDict := []string{"cat", "dog", "sand", "and"}
	fmt.Println(wordBreak(s, wordDict))
}

func wordBreak(s string, wordDict []string) bool {
	m := make(map[string]bool, len(wordDict))
	sizes := make([]int, len(wordDict))

	for _, word := range wordDict {
		m[word] = true
		sizes = append(sizes, len(word))
	}

	sort.Ints(sizes)

	n := len(s)
	dp := make([]bool, n+1)
	dp[0] = true

	// dp[i]代表前i个字符是否可以被dict中字符组合出来
	for i := 0; i <= n; i++ {
		if !dp[i] {
			continue
		}

		for _, size := range sizes {
			if i+size <= n {
				dp[i+size] = dp[i+size] || m[s[i:i+size]]
			}
		}
	}

	return dp[n]
}
