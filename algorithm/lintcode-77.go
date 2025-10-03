package main

import "fmt"

// 描述
// 中文
// English
// Given two strings, find the longest common subsequence (LCS).
//
// Your code should return the length of LCS.
//
// 您在真实的面试中是否遇到过这个题？
// 说明
// What's the definition of Longest Common Subsequence?
//
// https://en.wikipedia.org/wiki/Longest_common_subsequence_problem
// http://baike.baidu.com/view/2020307.htm
// 样例
// 样例 1:
// 输入:  "ABCD" and "EDCA"
// 输出:  1
//
// 解释:
// LCS 是 'A' 或  'D' 或 'C'
//
//
// 样例 2:
// 输入: "ABCD" and "EACB"
// 输出:  2
//
// 解释:
// LCS 是 "AC"

func main() {
	A := "ABCD"
	B := "EACB"
	fmt.Println(longestCommonSubsequence(A, B))
}

/**
 * @param A: A string
 * @param B: A string
 * @return: The length of longest common subsequence of A and B
 */
func longestCommonSubsequence(A string, B string) int {
	dp := make([][]int, len(A)+1)
	for i := range dp {
		dp[i] = make([]int, len(B)+1)
	}

	for i := 1; i <= len(A); i++ {
		for j := 1; j <= len(B); j++ {
			if A[i-1] == B[j-1] {
				dp[i][j] = max(dp[i][j], dp[i-1][j-1]+1)
			}
			dp[i][j] = max(dp[i][j], dp[i][j-1])
			dp[i][j] = max(dp[i][j], dp[i-1][j])
		}
	}
	for i := range dp {
		fmt.Println(dp[i])
	}
	return dp[len(A)][len(B)]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
