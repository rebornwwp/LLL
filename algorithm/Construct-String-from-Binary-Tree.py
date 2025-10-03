# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution(object):
    def tree2str(self, t):
        """
        :type t: TreeNode
        :rtype: str
        """
        if not t:
            return ""
        if t and t.left is None and t.right is None:
            return str(t.val)
        if t and t.left is None and t.right is not None:
            return str(t.val) + "()" + "(" + self.tree2str(t.right) + ")"
        if t and t.left is not None and t.right is None:
            return str(t.val) + "(" + self.tree2str(t.left) + ")"
        if t and t.left is not None and t.right is not None:
            return str(t.val) + "(" + self.tree2str(t.left) + ")" + "(" + self.tree2str(t.right) + ")"
