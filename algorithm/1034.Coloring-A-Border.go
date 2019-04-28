// Given a 2-dimensional grid of integers, each value in the grid represents the color of the grid square at that location.

// Two squares belong to the same connected component if and only if they have the same color and are next to each other in any of the 4 directions.

// The border of a connected component is all the squares in the connected component that are either 4-directionally adjacent to a square not in the component, or on the boundary of the grid (the first or last row or column).

// Given a square at location (r0, c0) in the grid and a color, color the border of the connected component of that square with the given color, and return the final grid.

// Example 1:

// Input: grid = [[1,1],[1,2]], r0 = 0, c0 = 0, color = 3
// Output: [[3, 3], [3, 2]]
// Example 2:

// Input: grid = [[1,2,2],[2,3,2]], r0 = 0, c0 = 1, color = 3
// Output: [[1, 3, 3], [2, 3, 3]]
// Example 3:

// Input: grid = [[1,1,1],[1,1,1],[1,1,1]], r0 = 1, c0 = 1, color = 2
// Output: [[2, 2, 2], [2, 1, 2], [2, 2, 2]]

// Note:

// 1 <= grid.length <= 50
// 1 <= grid[0].length <= 50
// 1 <= grid[i][j] <= 1000
// 0 <= r0 < grid.length
// 0 <= c0 < grid[0].length
// 1 <= color <= 1000
package main

import "fmt"

func main() {
	grid := [][]int{[]int{1, 1, 1, 1, 1}, []int{1, 1, 1, 1, 1},
		[]int{1, 1, 1, 1, 1}, []int{1, 1, 1, 1, 1}, []int{1, 1, 1, 1, 1}}
	fmt.Println(colorBorder(grid, 2, 2, 3))
}

func colorBorder(grid [][]int, r0 int, c0 int, color int) [][]int {
	var dfs func([][]int, int, int, int, [][]int, [][]bool)

	dfs = func(grid [][]int, r int, c int, origin int, ans [][]int, visited [][]bool) {
		if r < 0 || r >= len(grid) || c < 0 || c >= len(grid[0]) || visited[r][c] {
			return
		}
		if grid[r][c] != origin {
			return
		}
		if !visited[r][c] &&
			grid[r][c] == origin &&
			(c == 0 || c == len(grid[0])-1 || r == 0 || r == len(grid)-1 ||
				grid[r-1][c] != origin || grid[r+1][c] != origin ||
				grid[r][c-1] != origin || grid[r][c+1] != origin) {
			ans[r][c] = color
		}
		visited[r][c] = true
		dfs(grid, r-1, c, origin, ans, visited)
		dfs(grid, r+1, c, origin, ans, visited)
		dfs(grid, r, c-1, origin, ans, visited)
		dfs(grid, r, c+1, origin, ans, visited)
	}
	ans := make([][]int, len(grid))
	for i := range ans {
		tmp := make([]int, 0)
		for j := range grid[i] {
			tmp = append(tmp, grid[i][j])
		}
		ans[i] = tmp
	}
	visited := make([][]bool, len(grid))
	for i := range ans {
		tmp := make([]bool, len(grid[0]))
		for j := range grid[i] {
			tmp[j] = false
		}
		visited[i] = tmp
	}
	origin := grid[r0][c0]
	dfs(grid, r0, c0, origin, ans, visited)
	return ans
}
