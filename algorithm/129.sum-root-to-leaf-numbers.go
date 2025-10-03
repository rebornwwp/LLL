/*
 * @lc app=leetcode id=129 lang=golang
 *
 * [129] Sum Root to Leaf Numbers
 *
 * https://leetcode.com/problems/sum-root-to-leaf-numbers/description/
 *
 * algorithms
 * Medium (42.02%)
 * Total Accepted:    179.6K
 * Total Submissions: 427.3K
 * Testcase Example:  '[1,2,3]'
 *
 * Given a binary tree containing digits from 0-9 only, each root-to-leaf path
 * could represent a number.
 *
 * An example is the root-to-leaf path 1->2->3 which represents the number
 * 123.
 *
 * Find the total sum of all root-to-leaf numbers.
 *
 * Note: A leaf is a node with no children.
 *
 * Example:
 *
 *
 * Input: [1,2,3]
 * ⁠   1
 * ⁠  / \
 * ⁠ 2   3
 * Output: 25
 * Explanation:
 * The root-to-leaf path 1->2 represents the number 12.
 * The root-to-leaf path 1->3 represents the number 13.
 * Therefore, sum = 12 + 13 = 25.
 *
 * Example 2:
 *
 *
 * Input: [4,9,0,5,1]
 * ⁠   4
 * ⁠  / \
 * ⁠ 9   0
 * / \
 * 5   1
 * Output: 1026
 * Explanation:
 * The root-to-leaf path 4->9->5 represents the number 495.
 * The root-to-leaf path 4->9->1 represents the number 491.
 * The root-to-leaf path 4->0 represents the number 40.
 * Therefore, sum = 495 + 491 + 40 = 1026.
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
func sumNumbers(root *TreeNode) int {
	sum := 0
	var dfs func(*TreeNode, int)
	dfs = func(root *TreeNode, temp int) {
		if root == nil {
			return
		}
		if root.Left == nil && root.Right == nil {
			sum += temp*10 + root.Val
			return
		}
		temp = temp*10 + root.Val
		dfs(root.Left, temp)
		dfs(root.Right, temp)
	}
	dfs(root, 0)
	return sum
}

