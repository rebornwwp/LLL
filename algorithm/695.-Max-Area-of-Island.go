package main

import "fmt"

func main() {
	fmt.Println("hello")
}

func maxAreaOfIsland(grid [][]int) int {
	maxArea := 0
	var dfs func([][]int, int, int) int
	dfs = func(grid [][]int, i int, j int) int {
		if i < 0 || j < 0 || i >= len(grid) || j >= len(grid[0]) {
			return 0
		}
		if grid[i][j] == 0 {
			return 0
		}
		grid[i][j] = 0
		ans := 1 + dfs(grid, i-1, j) + dfs(grid, i+1, j) + dfs(grid, i, j-1) + dfs(grid, i, j+1)
		return ans
	}

	for i := 0; i < len(grid); i++ {
		for j := 0; j < len(grid[0]); j++ {
			if grid[i][j] == 1 {
				maxArea = max(maxArea, dfs(grid, i, j))
			}
		}
	}
	return maxArea
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
