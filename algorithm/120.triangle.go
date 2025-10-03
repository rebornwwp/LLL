/*
 * @lc app=leetcode id=120 lang=golang
 *
 * [120] Triangle
 */
package main

// func main() {
// 	triangle := [][]int{
// 		[]int{2},
// 	}
// 	// []int{3, 4},
// 	// []int{6, 5, 7},
// 	// []int{4, 1, 8, 3},
// 	fmt.Println(minimumTotal(triangle))
// }

func minimumTotal(triangle [][]int) int {
	if len(triangle) == 0 {
		return 0
	}
	dp := make([]int, len(triangle))
	for i := range triangle[len(triangle)-1] {
		dp[i] = triangle[len(triangle)-1][i]
	}

	for i := len(triangle) - 2; i >= 0; i-- {
		for j := 0; j < len(triangle[i]); j++ {
			dp[j] = min(dp[j], dp[j+1]) + triangle[i][j]
		}
	}
	return dp[0]
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}
