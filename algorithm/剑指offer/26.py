# 二叉树中和为某一值的路径
# 题目描述
# 输入一颗二叉树的跟节点和一个整数，打印出二叉树中结点
# 值的和为输入整数的所有路径。路径定义为从树的根结点开
# 始往下一直到叶结点所经过的结点形成一条路径。(注意:
# 在返回值的list中，数组长度大的数组靠前)


# class TreeNode:
#     def __init__(self, x):
#         self.val = x
#         self.left = None
#         self.right = None

class Solution:
    # 返回二维列表，内部每个列表表示找到的路径
    def __init__(self):
        self.li = []
        self.liAll = []

    def FindPath(self, root, expectNumber):
        if root is None:
            return self.liAll
        self.li.append(root.val)

        expectNumber = expectNumber - root.val
        isLeaf = not root.left and not root.right
        if expectNumber == 0 and isLeaf:
            self.liAll.append(self.li[:])

        self.FindPath(root.left, expectNumber)
        self.FindPath(root.right, expectNumber)
        self.li.pop()
        return self.liAll
