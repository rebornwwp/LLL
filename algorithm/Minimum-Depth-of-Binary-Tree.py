# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def minDepth(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        if not root:
            return 0
        if root and root.left == None and root.right==None:
            return 1
        elif root.left is not None and root.right is None:
            return 1 + self.minDepth(root.left)
        elif root.right is not None and root.left is None:
            return 1 + self.minDepth(root.right)
        return 1 + min(self.minDepth(root.right), self.minDepth(root.left))