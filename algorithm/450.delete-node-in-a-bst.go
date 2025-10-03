/*
 * @lc app=leetcode id=450 lang=golang
 *
 * [450] Delete Node in a BST
 *
 * https://leetcode.com/problems/delete-node-in-a-bst/description/
 *
 * algorithms
 * Medium (39.72%)
 * Total Accepted:    62.5K
 * Total Submissions: 157.3K
 * Testcase Example:  '[5,3,6,2,4,null,7]\n3'
 *
 * Given a root node reference of a BST and a key, delete the node with the
 * given key in the BST. Return the root node reference (possibly updated) of
 * the BST.
 *
 * Basically, the deletion can be divided into two stages:
 *
 * Search for a node to remove.
 * If the node is found, delete the node.
 *
 *
 *
 * Note: Time complexity should be O(height of tree).
 *
 * Example:
 *
 * root = [5,3,6,2,4,null,7]
 * key = 3
 *
 * ⁠   5
 * ⁠  / \
 * ⁠ 3   6
 * ⁠/ \   \
 * 2   4   7
 *
 * Given key to delete is 3. So we find the node with value 3 and delete it.
 *
 * One valid answer is [5,4,6,2,null,null,7], shown in the following BST.
 *
 * ⁠   5
 * ⁠  / \
 * ⁠ 4   6
 * ⁠/     \
 * 2       7
 *
 * Another valid answer is [5,2,6,null,4,null,7].
 *
 * ⁠   5
 * ⁠  / \
 * ⁠ 2   6
 * ⁠  \   \
 * ⁠   4   7
 *
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
	fmt.Println("hell")
}

func deleteNode(root *TreeNode, key int) *TreeNode {
	if root == nil {
		return root
	}
	if root.Val == key {
		if root.Left == nil && root.Right == nil {
			return nil
		} else if root.Left == nil {
			return root.Right
		} else if root.Right == nil {
			return root.Left
		} else {
			max := findMax(root.Left)
			root.Val = max
			root.Left = deleteNode(root.Left, max)
		}
	} else if root.Val > key {
		root.Left = deleteNode(root.Left, key)
	} else if root.Val < key {
		root.Right = deleteNode(root.Right, key)
	}
	return root
}

func findMax(node *TreeNode) int {
	if node.Right == nil {
		return node.Val
	}
	return findMax(node.Right)
}
