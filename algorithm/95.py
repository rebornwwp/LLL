# Given an integer n, generate all structurally unique BST's (binary search trees) that store values 1 ... n.
# Example:
# Input: 3
# Output:
# [
#   [1,null,3,2],
#   [3,2,null,1],
#   [3,1,null,null,2],
#   [2,1,3],
#   [1,null,2,null,3]
# ]
# Explanation:
# The above output corresponds to the 5 unique BST's shown below:
#    1         3     3      2      1
#     \       /     /      / \      \
#      3     2     1      1   3      2
#     /     /       \                 \
#    2     1         2                 3

# Definition for a binary tree node.


class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution:
    def generateTrees(self, n):
        def newTree(x, l, r):
            t = TreeNode(x)
            t.left = l
            t.right = r
            return t

        def gen(s, e):
            return [newTree(i, l, r) for i in range(s, e + 1) for l in gen(s, i - 1) for r in gen(i + 1, e)] or [None]

        ans = gen(1, n) if n > 0 else []
        return ans

s = Solution()
s.generateTrees(3)
