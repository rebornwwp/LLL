# 序列化二叉树
# 题目描述
# 请实现两个函数，分别用来序列化和反序列化二叉树

# -*- coding:utf-8 -*-


class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution:
    def Serialize(self, root):
        if root is None:
            return '#'
        return str(root.val) + ',' + self.Serialize(root.left) + ',' + self.Serialize(root.right)

    def Deserialize(self, s):
        values = s.split(',')
        return self.build(values)

    def build(self, values):
        if len(values) > 0:
            val = values.pop(0)
            print(val)
            if val == '#':
                return None
            root = TreeNode(int(val))
            root.left = self.build(values)
            root.right = self.build(values)
            return root


if __name__ == "__main__":
    a = TreeNode(5)
    a.left = TreeNode(3)
    a.right = TreeNode(7)
    a.left.right = TreeNode(4)
    a.right.left = TreeNode(6)
    s = Solution()
    print(s.Serialize(a))
    print(s.Deserialize(s.Serialize(a)))
