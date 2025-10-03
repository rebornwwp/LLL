package main

import "fmt"

func main() {
	A := []int{1, 4, 2}
	B := []int{1, 2, 4}
	fmt.Println(max(1, 2, 3, 4))
	fmt.Println(maxUncrossedLines(A, B))
}

func maxUncrossedLines(A []int, B []int) int {
	lA := len(A)
	lB := len(B)
	dp := make([][]int, lA+1)
	for i := range dp {
		dp[i] = make([]int, lB+1)
	}

	for i := 1; i <= lA; i++ {
		for j := 1; j <= lB; j++ {
			if A[i-1] == B[j-1] {
				dp[i][j] = max(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]+1)
			} else {
				dp[i][j] = max(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])
			}
		}
	}
	return dp[lA][lB]
}

func max(x ...int) int {
	ans := x[0]
	for _, v := range x {
		if v > ans {
			ans = v
		}
	}
	return ans
}
