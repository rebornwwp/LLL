/*
 * @lc app=leetcode id=1029 lang=golang
 *
 * [1029] Two City Scheduling
 */
package main

import (
	"sort"
)

// func main() {
// 	fmt.Println("hello")
// }

type TwoData [][]int

func (a TwoData) Len() int           { return len(a) }
func (a TwoData) Less(i, j int) bool { return a[i][0]-a[i][1] < a[j][0]-a[j][1] }
func (a TwoData) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }

func twoCitySchedCost(costs [][]int) int {
	sort.Sort(TwoData(costs))
	N := len(costs)
	ans := 0
	for i := 0; i < N/2; i++ {
		ans += costs[i][0] + costs[N-i-1][1]
	}
	return ans
}
