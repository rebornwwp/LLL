/*
 * @lc app=leetcode id=1030 lang=golang
 *
 * [1030] Matrix Cells in Distance Order
 */

package main

import (
	"fmt"
	"sort"
)

func main() {
	fmt.Println("hello")
}

type TwoData [][]int

func (a TwoData) Len() int { return len(a) }
func (a TwoData) Less(i, j int) bool {
	return abs(a[i][0]-a[i][2])+abs(a[i][1]-a[i][3]) < abs(a[j][0]-a[j][2])+abs(a[j][1]-a[j][3])
}
func (a TwoData) Swap(i, j int) { a[i], a[j] = a[j], a[i] }

func allCellsDistOrder(R int, C int, r0 int, c0 int) [][]int {
	ans := make([][]int, 0)
	for i := 0; i < R; i++ {
		for j := 0; j < C; j++ {
			ans = append(ans, []int{i, j, r0, c0})
		}
	}
	sort.Sort(TwoData(ans))
	for i := 0; i < len(ans); i++ {
		ans[i] = ans[i][0:2]
	}
	return ans
}

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}
