/*
 * @lc app=leetcode id=113 lang=golang
 *
 * [113] Path Sum II
 *
 * https://leetcode.com/problems/path-sum-ii/description/
 *
 * algorithms
 * Medium (40.07%)
 * Total Accepted:    223K
 * Total Submissions: 556.3K
 * Testcase Example:  '[5,4,8,11,null,13,4,7,2,null,null,5,1]\n22'
 *
 * Given a binary tree and a sum, find all root-to-leaf paths where each path's
 * sum equals the given sum.
 *
 * Note: A leaf is a node with no children.
 *
 * Example:
 *
 * Given the below binary tree and sum = 22,
 *
 *
 * ⁠     5
 * ⁠    / \
 * ⁠   4   8
 * ⁠  /   / \
 * ⁠ 11  13  4
 * ⁠/  \    / \
 * 7    2  5   1
 *
 *
 * Return:
 *
 *
 * [
 * ⁠  [5,4,11,2],
 * ⁠  [5,8,4,5]
 * ]
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
func pathSum(root *TreeNode, sum int) [][]int {
	ans := [][]int{}
	temp := []int{}

	var dfs func(*TreeNode, int, int)
	dfs = func(root *TreeNode, level int, sum int) {
		if root == nil {
			return
		}
		if level >= len(temp) {
			temp = append(temp, root.Val)
		} else {
			temp[level] = root.Val
		}

		sum -= root.Val

		if root.Left == nil && root.Right == nil && sum == 0 {
			c := make([]int, level+1)
			copy(c, temp)
			ans = append(ans, c)
		}
		dfs(root.Left, level+1, sum)
		dfs(root.Right, level+1, sum)
	}
	dfs(root, 0, sum)
	return ans
}


