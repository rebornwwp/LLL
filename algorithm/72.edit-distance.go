/*
 * @lc app=leetcode id=72 lang=golang
 *
 * [72] Edit Distance
 */

package main

// func main() {
// 	word1 := "intention"
// 	word2 := "execution"
// 	fmt.Println(minDistance(word1, word2))
// }

func minDistance(word1 string, word2 string) int {
	la := len(word1)
	lb := len(word2)
	dp := make([][]int, la+1)
	for i := range dp {
		dp[i] = make([]int, lb+1)
		dp[i][0] = i
	}
	for i := 0; i <= lb; i++ {
		dp[0][i] = i
	}
	for i := 1; i <= la; i++ {
		for j := 1; j <= lb; j++ {
			if word1[i-1] == word2[j-1] {
				dp[i][j] = dp[i-1][j-1]
			} else {
				dp[i][j] = min(dp[i-1][j-1]+1, dp[i-1][j]+1, dp[i][j-1]+1)
			}
		}

	}
	return dp[la][lb]
}

func min(x ...int) int {
	ans := x[0]
	for _, v := range x {
		if v < ans {
			ans = v
		}
	}
	return ans
}
