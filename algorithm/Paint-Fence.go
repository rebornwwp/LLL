// Lintcode
// There is a fence with n posts, each post can be painted with one of the k colors.
// You have to paint all the posts such that no more than two adjacent fence posts have the same color.
// Return the total number of ways you can paint the fence.

// 样例
// Example 1:

// Input: n=3, k=2
// Output: 6
// Explanation:
//           post 1,   post 2, post 3
//     way1    0         0       1
//     way2    0         1       0
//     way3    0         1       1
//     way4    1         0       0
//     way5    1         0       1
//     way6    1         1       0
// Example 2:

// Input: n=2, k=2
// Output: 4
// Explanation:
//           post 1,   post 2
//     way1    0         0
//     way2    0         1
//     way3    1         0
//     way4    1         1
// 注意事项
// n and k are non-negative integers.

/**
 * @param n: non-negative integer, n posts
 * @param k: non-negative integer, k colors
 * @return: an integer, the total number of ways
 */
package main

import "fmt"

func numWays(n int, k int) int {
	var dp = make([][]int, 2)
	for i := 0; i < 2; i++ {
		dp[i] = make([]int, n)
		for j := 0; j < n; j++ {
			dp[i][j] = 0
		}
	}
	for i := 0; i < n; i++ {
		if i == 0 {
			dp[0][i] = 0
			dp[1][i] = k
		} else {
			dp[0][i] = dp[1][i-1]
			dp[1][i] = (dp[0][i-1] + dp[1][i-1]) * (k - 1)
		}
	}
	return dp[0][n-1] + dp[1][n-1]
}

func numWays1(n, k int) int {
	adjustSame := 0
	adjustNotSame := 0
	for i := 0; i < n; i++ {
		if i == 0 {
			adjustSame = 0
			adjustNotSame = k
		} else {
			adjustSame, adjustNotSame = adjustNotSame, (adjustSame+adjustNotSame)*(k-1)
		}
	}
	return adjustNotSame + adjustSame
}

func main() {
	fmt.Println(numWays1(5, 3))
}
