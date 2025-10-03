/*
 * @lc app=leetcode id=396 lang=golang
 *
 * [396] Rotate Function
 *
 * https://leetcode.com/problems/rotate-function/description/
 *
 * algorithms
 * Medium (34.98%)
 * Total Accepted:    33.9K
 * Total Submissions: 96.9K
 * Testcase Example:  '[]'
 *
 *
 * Given an array of integers A and let n to be its length.
 *
 *
 *
 * Assume Bk to be an array obtained by rotating the array A k positions
 * clock-wise, we define a "rotation function" F on A as follow:
 *
 *
 *
 * F(k) = 0 * Bk[0] + 1 * Bk[1] + ... + (n-1) * Bk[n-1].
 *
 * Calculate the maximum value of F(0), F(1), ..., F(n-1).
 *
 *
 * Note:
 * n is guaranteed to be less than 10^5.
 *
 *
 * Example:
 *
 * A = [4, 3, 2, 6]
 *
 * F(0) = (0 * 4) + (1 * 3) + (2 * 2) + (3 * 6) = 0 + 3 + 4 + 18 = 25
 * F(1) = (0 * 6) + (1 * 4) + (2 * 3) + (3 * 2) = 0 + 4 + 6 + 6 = 16
 * F(2) = (0 * 2) + (1 * 6) + (2 * 4) + (3 * 3) = 0 + 6 + 8 + 9 = 23
 * F(3) = (0 * 3) + (1 * 2) + (2 * 6) + (3 * 4) = 0 + 2 + 12 + 12 = 26
 *
 * So the maximum value of F(0), F(1), F(2), F(3) is F(3) = 26.
 *
 *
 */

package main

import "fmt"

func main() {
	fmt.Println(maxRotateFunction([]int{4, 3, 2, 6}))
}

func maxRotateFunction(A []int) int {
	a, b := sum(A)
	var (
		ans    int = b
		length int = len(A)
	)
	for i := length - 1; i > 0; i-- {
		b = b + a - length*A[i]
		ans = max(ans, b)
	}
	return ans
}

func sum(A []int) (int, int) {
	var a, b int
	for i := range A {
		a += A[i]
		b += i * A[i]
	}
	return a, b
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
