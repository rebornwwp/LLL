// 01背包问题

// 有 N 件物品和一个容量是 V 的背包。每件物品只能使用一次。

// 第 i 件物品的体积是 vi，价值是 wi。

// 求解将哪些物品装入背包，可使这些物品的总体积不超过背包容量，且总价值最大。
// 输出最大价值。

// 输入格式
// 第一行两个整数，N，V，用空格隔开，分别表示物品数量和背包容积。

// 接下来有 N 行，每行两个整数 vi,wi，用空格隔开，分别表示第 i 件物品的体积和价值。

// 输出格式
// 输出一个整数，表示最大价值。

// 数据范围
// 0<N,V≤1000
// 0<vi,wi≤1000
// 输入样例
// 4 5
// 1 2
// 2 4
// 3 4
// 4 5
// 输出样例：
// 8

package main

import (
	"fmt"
	"os"
)

func main() {
	var N, V int
	fmt.Fscanln(os.Stdin, &N, &V)
	vw := make([][]int, N)
	for i := range vw {
		var v, w int
		fmt.Fscanln(os.Stdin, &v, &w)
		temp := []int{v, w}
		vw[i] = temp
	}
	fmt.Println(maxWeight(vw, N, V))
}

func maxWeight(nums [][]int, N int, V int) int {
	// init dp (N+1)x(V+1)
	dp := make([][]int, N+1)
	for i := range dp {
		dp[i] = make([]int, V+1)
	}
	//
	for i := 1; i <= N; i++ {
		for j := 1; j <= V; j++ {
			if j >= nums[i-1][0] {
				dp[i][j] = max(dp[i-1][j], dp[i-1][j-nums[i-1][0]]+nums[i-1][1])
			} else {
				dp[i][j] = dp[i-1][j]
			}
		}
	}
	return dp[N][V]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
