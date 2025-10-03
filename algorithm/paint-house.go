// There are a row of n houses, each house can be painted with one of the three colors: red, blue or green. The cost of painting each house with a certain color is different. You have to paint all the houses such that no two adjacent houses have the same color, and you need to cost the least. Return the minimum cost.

// The cost of painting each house with a certain color is represented by a n x 3 cost matrix. For example, costs[0][0] is the cost of painting house 0 with color red; costs[1][2] is the cost of painting house 1 with color green, and so on... Find the minimum cost to paint all houses.

// 样例
// Example 1:

// Input: [[14,2,11],[11,14,5],[14,3,10]]
// Output: 10
// Explanation: blue green blue, 2 + 5 + 3 = 10
// Example 2:

// Input: [[1,2,3],[1,4,6]]
// Output: 3
// 注意事项
// All costs are positive integers.

/**
 * @param costs: n x 3 cost matrix
 * @return: An integer, the minimum cost to paint all houses
 */
package main

import "fmt"

func minCost(costs [][]int) int {
	if costs == nil || len(costs) == 0 {
		return 0
	}
	n := len(costs)
	minRed := []int{0, 0}
	minBlue := []int{0, 0}
	minGreen := []int{0, 0}
	for i := 1; i <= n; i++ {
		minRed[i%2] = costs[i-1][0] + min(minBlue[(i-1)%2], minGreen[(i-1)%2])
		minBlue[i%2] = costs[i-1][1] + min(minRed[(i-1)%2], minGreen[(i-1)%2])
		minGreen[i%2] = costs[i-1][2] + min(minBlue[(i-1)%2], minRed[(i-1)%2])
	}
	return min(min(minRed[n%2], minBlue[n%2]), minGreen[n%2])
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

func main() {
	l := make([][]int, 3)
	l[0] = []int{1, 2, 3}
	l[1] = []int{0, 5, 6}
	l[2] = []int{3, 2, 4}
	fmt.Println(minCost(l))
	fmt.Println(minCost([][]int{}))
}
