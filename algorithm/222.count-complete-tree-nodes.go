/*
 * @lc app=leetcode id=222 lang=golang
 *
 * [222] Count Complete Tree Nodes
 *
 * https://leetcode.com/problems/count-complete-tree-nodes/description/
 *
 * algorithms
 * Medium (32.47%)
 * Total Accepted:    113.9K
 * Total Submissions: 350.2K
 * Testcase Example:  '[1,2,3,4,5,6]'
 *
 * Given a complete binary tree, count the number of nodes.
 *
 * Note:
 *
 * Definition of a complete binary tree from Wikipedia:
 * In a complete binary tree every level, except possibly the last, is
 * completely filled, and all nodes in the last level are as far left as
 * possible. It can have between 1 and 2^h nodes inclusive at the last level
 * h.
 *
 * Example:
 *
 *
 * Input:
 * ⁠   1
 * ⁠  / \
 * ⁠ 2   3
 * ⁠/ \  /
 * 4  5 6
 *
 * Output: 6
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
func countNodes(root *TreeNode) int {
	count := 0
	helper(root, &count)
	return count
}

func helper(root *TreeNode, count *int) {
	if root == nil {
		return
	}

	*count++
	helper(root.Left, count)
	helper(root.Right, count)
}

