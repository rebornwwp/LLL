// Given N, consider a convex N-sided polygon with vertices labelled A[0], A[i], ..., A[N-1] in clockwise order.

// Suppose you triangulate the polygon into N-2 triangles.  For each triangle, the value of that triangle is the product of the labels of the vertices, and the total score of the triangulation is the sum of these values over all N-2 triangles in the triangulation.

// Return the smallest possible total score that you can achieve with some triangulation of the polygon.

// Example 1:

// Input: [1,2,3]
// Output: 6
// Explanation: The polygon is already triangulated, and the score of the only triangle is 6.
// Example 2:

// Input: [3,7,4,5]
// Output: 144
// Explanation: There are two triangulations, with possible scores: 3*7*5 + 4*5*7 = 245, or 3*4*5 + 3*4*7 = 144.  The minimum score is 144.
// Example 3:

// Input: [1,3,1,4,1,5]
// Output: 13
// Explanation: The minimum score triangulation has score 1*1*3 + 1*1*4 + 1*1*5 + 1*1*1 = 13.

// Note:

// 3 <= A.length <= 50
// 1 <= A[i] <= 100

package main

import "fmt"

func main() {
	l := []int{1, 3}
	fmt.Println(minScoreTriangulation(l))
}
func minScoreTriangulation(A []int) int {
	N := len(A)
	dp := make([][]int, N)
	for i := range dp {
		dp[i] = make([]int, N)
	}

	var helper func(int, int, [][]int) int
	helper = func(start int, end int, dp [][]int) int {
		ans := 0
		if dp[start][end] != 0 {
			return dp[start][end]
		}
		for k := start + 1; k < end; k++ {
			if ans == 0 {
				ans = min(1<<63-1, helper(start, k, dp)+A[start]*A[end]*A[k]+helper(k, end, dp))
			} else {
				ans = min(ans, helper(start, k, dp)+A[start]*A[end]*A[k]+helper(k, end, dp))
			}
		}
		dp[start][end] = ans
		return dp[start][end]
	}
	return helper(0, N-1, dp)
}

func min(x ...int) int {
	ans := x[0]
	for _, v := range x {
		if ans > v {
			ans = v
		}
	}
	return ans
}
