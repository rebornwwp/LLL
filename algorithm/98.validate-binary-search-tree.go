/*
 * @lc app=leetcode id=98 lang=golang
 *
 * [98] Validate Binary Search Tree
 *
 * https://leetcode.com/problems/validate-binary-search-tree/description/
 *
 * algorithms
 * Medium (25.50%)
 * Total Accepted:    383.8K
 * Total Submissions: 1.5M
 * Testcase Example:  '[2,1,3]'
 *
 * Given a binary tree, determine if it is a valid binary search tree (BST).
 *
 * Assume a BST is defined as follows:
 *
 *
 * The left subtree of a node contains only nodes with keys less than the
 * node's key.
 * The right subtree of a node contains only nodes with keys greater than the
 * node's key.
 * Both the left and right subtrees must also be binary search trees.
 *
 *
 * Example 1:
 *
 *
 * Input:
 * ⁠   2
 * ⁠  / \
 * ⁠ 1   3
 * Output: true
 *
 *
 * Example 2:
 *
 *
 * ⁠   5
 * ⁠  / \
 * ⁠ 1   4
 * / \
 * 3   6
 * Output: false
 * Explanation: The input is: [5,1,4,null,null,3,6]. The root node's
 * value
 * is 5 but its right child's value is 4.
 *
 *
 */

package main

import "fmt"
import "math"

func main() {
	fmt.Println("hell")
}

// Definition for a binary tree node.
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func isValidBST(root *TreeNode) bool {
	t := toList(root)
	for i := 0; i < len(t)-1; i++ {
		if t[i] >= t[i+1] {
			return false
		}
	}
	return true
}

func toList(root *TreeNode) []int {
	if root == nil {
		return []int{}
	}
	return append(toList(root.Left), append([]int{root.Val}, toList(root.Right)...)...)
}

func isValidBST2(root *TreeNode) bool {
	return helper(root, math.MinInt64, math.MaxInt64)
}

func helper(root *TreeNode, min int, max int) bool {
	if root == nil {
		return true
	}

	return root.Val > min && root.Val < max && helper(root.Left, min, root.Val) && helper(root.Right, root.Val, max)
}
