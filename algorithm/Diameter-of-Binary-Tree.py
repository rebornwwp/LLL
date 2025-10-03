# Given a binary tree, you need to compute the length of the diameter of the tree. The diameter of a binary tree is the length of the longest path between any two nodes in a tree. This path may or may not pass through the root.
#
# Example:
# Given a binary tree
#           1
#          / \
#         2   3
#        / \
#       4   5
# Return 3, which is the length of the path [4,2,1,3] or [5,2,1,3].
#
# Note: The length of path between two nodes is represented by the number of edges between them.


# Definition for a binary tree node.
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution:
    def diameterOfBinaryTree(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        self.ans

        def depth(node):
            if not node:
                return 0
            L = depth(node.left)
            R = depth(node.right)
            self.ans = max(self.ans, L + R + 1)
            return max(L, R) + 1

        depth(root)
        return self.ans - 1

    def diameterOfBinaryTree1(self, root):
        def depth(node, max_length):
            if not node:
                return 0
            l = depth(node.left, max_length)
            r = depth(node.right, max_length)
            max_length[0] = max(max_length[0], l + r + 1)
            return max(l, r) + 1

        max_length = [0]
        depth(root, max_length)
        if max_length[0] == 0:
            return 0
        return max_length - 1
