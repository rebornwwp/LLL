package main

import (
	"fmt"
	"sort"
)

func main() {
	s := "catsanddog"
	wordDict := []string{"cat", "cats", "and", "sand", "dog"}
	fmt.Println(wordBreak(s, wordDict))
}

func wordBreak(s string, wordDict []string) []string {

	m := make(map[string]bool, len(wordDict))
	sizes := make([]int, len(wordDict))
	lengths := make(map[int]bool, len(wordDict))

	for _, word := range wordDict {
		m[word] = true
		lengths[len(word)] = true
	}
	for k := range lengths {
		sizes = append(sizes, k)
	}
	sort.Ints(sizes)

	n := len(s)
	dp := make([]int, n+1)
	dp[0] = 1

	// dp[i]代表前i个字符是否可以被dict中字符组合出来
	for i := 0; i <= n; i++ {
		if dp[i] == 0 {
			continue
		}

		for _, size := range sizes {
			if i+size <= n && m[s[i:i+size]] {
				dp[i+size] += dp[i]
			}
		}
	}
	if dp[n] == 0 {
		return []string{}
	}

	var dfs func(string, int, string, *[]string)
	dfs = func(s string, index int, tmp string, ans *[]string) {
		if index == len(s) {
			*ans = append(*ans, tmp[1:])
			return
		}

		for _, size := range sizes {
			if index+size <= len(s) && m[s[index:index+size]] {
				dfs(s, index+size, tmp+" "+s[index:index+size], ans)
			}
		}
	}
	ans := make([]string, 0, dp[n])
	dfs(s, 0, "", &ans)
	return ans
}
