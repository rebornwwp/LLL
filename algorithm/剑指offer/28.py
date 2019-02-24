# 按之字形打印二叉树
# 题目描述
# 请实现一个函数按照之字形打印二叉树，即第一行按照从左到右的
# 顺序打印，第二层按照从右至左的顺序打印，第三行按照从左到右
# 的顺序打印，其他行以此类推。


# -*- coding:utf-8 -*-
class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution:
    def Print(self, pRoot):
        i = 1
        a = [pRoot]
        haha = []
        while True:
            result = []
            temp = []
            while len(a) > 0:
                t = a[0]
                a = a[1:]
                if t is not None:
                    result.append(t.val)
                    temp.append(t.left)
                    temp.append(t.right)
            if len(result) > 0:
                if i % 2 == 1:
                    haha.append(result)
                else:
                    haha.append(list(reversed(result)))
            i += 1
            if len(temp) == 0:
                break
            a = temp

        return haha


if __name__ == "__main__":
    a = TreeNode(5)
    a.left = TreeNode(3)
    a.right = TreeNode(7)
    a.left.right = TreeNode(4)
    a.right.left = TreeNode(6)
    s = Solution()
    s.Print(a)
