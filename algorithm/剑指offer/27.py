# 对称二叉树
# 题目描述
# 请实现一个函数，用来判断一颗二叉树是不是对称的。注意，如果一个二叉树同此二叉树的镜像是同样的，定义其为对称的。


# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    def isSymmetrical(self, pRoot):
        if pRoot is None:
            return True
        return self.helper(pRoot.left, pRoot.right)

    def helper(self, p1, p2):
        if p1 is None and p2 is not None:
            return False

        if p1 is not None and p2 is None:
            return False

        if p1 is None and p2 is None:
            return True

        if p1.val == p2.val:
            return self.helper(p1.left, p2.right) and self.helper(p1.right, p2.left)
