# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None


class Solution(object):
    def maxDepth(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if root and root.left is None and root.right is None:
            return 1
        elif root is None:
            return 0
        return 1 + max(self.maxDepth(root.right), self.maxDepth(root.left))
