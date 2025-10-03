/*
 * @lc app=leetcode id=508 lang=golang
 *
 * [508] Most Frequent Subtree Sum
 *
 * https://leetcode.com/problems/most-frequent-subtree-sum/description/
 *
 * algorithms
 * Medium (54.21%)
 * Total Accepted:    47K
 * Total Submissions: 86.6K
 * Testcase Example:  '[5,2,-3]'
 *
 *
 * Given the root of a tree, you are asked to find the most frequent subtree
 * sum. The subtree sum of a node is defined as the sum of all the node values
 * formed by the subtree rooted at that node (including the node itself). So
 * what is the most frequent subtree sum value? If there is a tie, return all
 * the values with the highest frequency in any order.
 *
 *
 * Examples 1
 * Input:
 *
 * ⁠ 5
 * ⁠/  \
 * 2   -3
 *
 * return [2, -3, 4], since all the values happen only once, return all of them
 * in any order.
 *
 *
 * Examples 2
 * Input:
 *
 * ⁠ 5
 * ⁠/  \
 * 2   -5
 *
 * return [2], since 2 happens twice, however -5 only occur once.
 *
 *
 * Note:
 * You may assume the sum of values in any subtree is in the range of 32-bit
 * signed integer.
 *
 */

package main

import "fmt"

// Definition for a binary tree node.
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func main() {
	fmt.Println("hello")
}

func findFrequentTreeSum(root *TreeNode) []int {
	r := map[int]int{}
	search(root, r)

	res := []int{}
	max := 0
	for i, v := range r {
		if max <= v {
			if max < v {
				max = v
				res = res[0:0]
			}
			res = append(res, i)
		}
	}
	return res
}

func search(node *TreeNode, r map[int]int) int {
	if node == nil {
		return 0
	}
	sum := search(node.Left, r) + node.Val + search(node.Right, r)
	r[sum]++
	return sum
}
