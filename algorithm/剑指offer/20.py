# 从上往下打印二叉树
# 题目描述
# 从上往下打印出二叉树的每个节点，同层节点从左至右打印。

# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None


class Solution:
    # 返回从上到下每个节点值列表，例：[1,2,3]
    def PrintFromTopToBottom(self, root):
        result = []
        l = [root]
        while len(l) > 0:
            node = l[0]
            l = l[1:]
            if node:
                result.append(node.val)
                if node.left:
                    l.append(node.left)
                if node.right:
                    l.append(node.right)
        return result
