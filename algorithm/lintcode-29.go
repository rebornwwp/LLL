package main

import "fmt"

// 描述
// 中文
// English
// 给出三个字符串:s1、s2、s3，判断s3是否由s1和s2交叉构成。
//
// 您在真实的面试中是否遇到过这个题？
// 样例
// 样例 1：
//
// 输入:
// "aabcc"
// "dbbca"
// "aadbbcbcac"
// 输出:
// true
// 样例 2：
//
// 输入:
// ""
// ""
// "1"
// 输出:
// false
// 样例 3：
//
// 输入:
// "aabcc"
// "dbbca"
// "aadbbbaccc"
// 输出:
// false

func main() {
	a := "aabcc"
	b := "dbbca"
	c := "aadbbcbc"
	fmt.Println(isInterleave(a, b, c))
}

/**
 * @param s1: A string
 * @param s2: A string
 * @param s3: A string
 * @return: Determine whether s3 is formed by interleaving of s1 and s2
 */
func isInterleave(s1 string, s2 string, s3 string) bool {
	dp := make([][]bool, len(s1)+1)
	for i := range dp {
		dp[i] = make([]bool, len(s2)+1)
	}
	for i := 0; i <= len(s1); i++ {
		for j := 0; j <= len(s2); j++ {
			if i == 0 && j == 0 {
				dp[i][j] = true
			}
			if i+j > len(s3) {
				return false
			}
			if i == 0 && j > 0 {
				dp[i][j] = dp[i][j] || (s2[j-1] == s3[i+j-1] && dp[i][j-1])
			}
			if i > 0 && j == 0 {
				dp[i][j] = dp[i][j] || (s1[i-1] == s3[i+j-1] && dp[i-1][j])
			}
			if i > 0 && j > 0 {
				dp[i][j] = dp[i][j] ||
					(s1[i-1] == s3[i+j-1] && dp[i-1][j]) ||
					(s2[j-1] == s3[i+j-1] && dp[i][j-1])
			}
		}
	}
	return dp[len(s1)][len(s2)]
}
