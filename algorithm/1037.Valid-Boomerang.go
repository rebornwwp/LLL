// A boomerang is a set of 3 points that are all distinct and not in a straight line.

// Given a list of three points in the plane, return whether these points are a boomerang.

// Example 1:

// Input: [[1,1],[2,3],[3,2]]
// Output: true
// Example 2:

// Input: [[1,1],[2,2],[3,3]]
// Output: false

// Note:

// points.length == 3
// points[i].length == 2
// 0 <= points[i][j] <= 100

package main

import (
	"fmt"
	"strconv"
)

func main() {
	points := [][]int{
		[]int{1, 1},
		[]int{2, 3},
		[]int{3, 3},
	}
	fmt.Println(isBoomerang(points))
}

func isBoomerang(points [][]int) bool {
	m := make(map[string]bool)
	for _, point := range points {
		m[strconv.Itoa(point[0])+"-"+strconv.Itoa(point[1])] = true
	}
	var ans bool
	if len(m) <= 2 {
		ans = false
	} else {
		x1 := points[1][0] - points[0][0]
		y1 := points[1][1] - points[0][1]
		x2 := points[2][0] - points[0][0]
		y2 := points[2][1] - points[0][1]
		ans = (x1*x2+y1*y2)*(x1*x2+y1*y2)/((x1*x1+y1*y1)*(x2*x2+y2*y2)) != 1
	}
	return ans
}
