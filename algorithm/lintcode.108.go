package main

import "fmt"

func main() {
	fmt.Println(minCut("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"))
}

func minCut(s string) int {
	if isPara(s, 0, len(s)-1) {
		return 0
	}
	dp := make([][]int, len(s))
	for i := range dp {
		dp[i] = make([]int, len(s))
		for j := range dp[i] {
			dp[i][j] = -1
		}
	}
	var helper func(string, int, int) int
	helper = func(s string, start int, end int) int {
		if dp[start][end] >= 0 {
			return dp[start][end]
		}
		if end-start == 0 {
			dp[start][end] = 0
			return dp[start][end]
		}
		ans := 10000000000
		for i := start; i < end; i++ {
			if !isPara(s, start, i) && !isPara(s, i+1, end) {
				ans = min(1+helper(s, start, i)+helper(s, i+1, end), ans)
			} else if !isPara(s, start, i) && isPara(s, i+1, end) {
				dp[i+1][end] = 0
				ans = min(1+helper(s, start, i), ans)
			} else if isPara(s, start, i) && !isPara(s, i+1, end) {
				dp[start][i] = 0
				ans = min(1+helper(s, i+1, end), ans)
			} else if isPara(s, start, i) && isPara(s, i+1, end) {
				dp[start][i] = 0
				dp[i+1][end] = 0
				ans = min(1, ans)
			}
		}
		dp[start][end] = ans
		return dp[start][end]
	}
	helper(s, 0, len(s)-1)
	return dp[0][len(s)-1]
}

func isPara(s string, start int, end int) bool {
	i, j := start, end
	for i <= j {
		if s[i] != s[j] {
			return false
		}
		i++
		j--
	}
	return true
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}
