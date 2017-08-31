# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def hasPathSum(self, root, sum):
        """
        :type root: TreeNode
        :type sum: int
        :rtype: bool
        """
        if root is None:
            return False
        if root.left is None and root.right is None:
            return root.val == sum
        if root.left is not None and root.right is None:
            return self.hasPathSum(root.left, sum - root.val)
        if root.left is None and root.right is not None:
            return self.hasPathSum(root.right, sum - root.val)
        if root.left is not None and root.right is not None:
            return self.hasPathSum(root.left, sum - root.val) or self.hasPathSum(root.right, sum - root.val)
