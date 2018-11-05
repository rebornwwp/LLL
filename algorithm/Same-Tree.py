# Definition for a binary tree node.
# class TreeNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None


class Solution(object):
    def isSameTree(self, p, q):
        """
        :type p: TreeNode
        :type q: TreeNode
        :rtype: bool
        """
        if p is None:
            return q == None
        elif q is None:
            return False
        if q.val == p.val:
            return self.isSameTree(p.left, q.left) & self.isSameTree(
                p.right, q.right)
        else:
            return False

    def isSameTree1(self, p, q):
        if p is None and q is not None:
            return False
        if p is not None and q is None:
            return False
        if p is None and q is None:
            return True
        else:
            return p.val == q.val and self.isSameTree1(
                p.left, q.left) and self.isSameTree1(p.right, q.right)

    def isSameTree2(self, a, b):
        stack = [(a, b)]
        while stack:
            (p, q) = stack.pop()
            if p and q and p.val == q.val:
                stack.append((p.left, q.left))
                stack.append((p.right, q.right))
            elif not p and not q:
                continue
            else:
                return False
        return True
