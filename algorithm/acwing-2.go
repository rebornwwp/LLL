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
	"sort"
)

type byFistElement [][]int

func (l byFistElement) Len() int           { return len(l) }
func (l byFistElement) Swap(i, j int)      { l[i], l[j] = l[j], l[i] }
func (l byFistElement) Less(i, i int) bool { return l[i][0] < l[j][0] }

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
	sort.Sort(vw)
	fmt.Println(maxWeight(vw, V))
}

func maxWeight(vw [][]int, maxV int) int {
	dp := make([]int, maxV+1)
	temp := 0
	for i := range vw {
		for j := 1; j <= temp && temp <= maxV; j++ {
			if dp[j] > 0 && j+vw[i][0] < len(dp) {
				dp[j+vw[i][0]] = max(dp[j+vw[i][0]], dp[j]+vw[i][1])
			}
		}
		temp += vw[i][0]
		dp[vw[i][0]] = max(vw[i][1], dp[vw[i][0]])
	}
	return dp[len(dp)-1]
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
