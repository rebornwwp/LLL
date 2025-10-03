/*
 * @lc app=leetcode id=404 lang=golang
 *
 * [404] Sum of Left Leaves
 *
 * https://leetcode.com/problems/sum-of-left-leaves/description/
 *
 * algorithms
 * Easy (48.87%)
 * Total Accepted:    121.3K
 * Total Submissions: 248.3K
 * Testcase Example:  '[3,9,20,null,null,15,7]'
 *
 * Find the sum of all left leaves in a given binary tree.
 *
 * Example:
 *
 * ⁠   3
 * ⁠  / \
 * ⁠ 9  20
 * ⁠   /  \
 * ⁠  15   7
 *
 * There are two left leaves in the binary tree, with values 9 and 15
 * respectively. Return 24.
 *
 *
 */
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
func sumOfLeftLeaves(root *TreeNode) int {
	count := 0
	helper(root, &count)
	return count
}

func helper(root *TreeNode, count *int) {
	if root == nil {
		return
	}
	if root.Left != nil && root.Left.Left == nil && root.Left.Right == nil {
		*count += root.Left.Val
		helper(root.Right, count)
		return
	}
	helper(root.Left, count)
	helper(root.Right, count)
}

