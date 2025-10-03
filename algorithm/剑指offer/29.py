# 把二叉树打印成多行
# 题目描述
# 从上到下按层打印二叉树，同一层结点从左至右输出。每一层输出一行。

# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None


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
                    haha.append(result)
            i += 1
            if len(temp) == 0:
                break
            a = temp

        return haha
