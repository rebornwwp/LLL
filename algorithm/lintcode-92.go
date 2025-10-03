// Given n items with size Ai, an integer m denotes the size of a backpack. How full you can fill this backpack?

// Example
// Example 1:
// 	Input:  [3,4,8,5], backpack size=10
// 	Output:  9

// Example 2:
// 	Input:  [2,3,5,7], backpack size=12
// 	Output:  12

// Challenge
// O(n x m) time and O(m) memory.

// O(n x m) memory is also acceptable if you do not know how to optimize memory.

// Notice
// You can not divide any item into small pieces.
/**
 * @param m: An integer m denotes the size of a backpack
 * @param A: Given n items with size A[i]
 * @return: The maximum size
 */

package main

import "fmt"

func main() {
	m := 10
	A := []int{3, 4, 5, 8}
	fmt.Println(backPack(m, A))
}

func backPack(m int, A []int) int {
	dp := make([][]bool, len(A)+1)
	for i := range dp {
		dp[i] = make([]bool, m+1)
	}
	dp[0][0] = true

	for i := 1; i < len(dp); i++ {
		for j := 0; j < m+1; j++ {
			if j >= A[i-1] {
				dp[i][j] = dp[i-1][j-A[i-1]] || dp[i-1][j]
			} else {
				dp[i][j] = dp[i-1][j]
			}
		}
	}
	var ans int
	for i := m; i >= 0; i-- {
		if dp[len(A)][i] {
			ans = i
			break
		}
	}
	return ans
}
