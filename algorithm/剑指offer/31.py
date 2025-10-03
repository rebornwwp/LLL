# 二叉树的下一个节点
# 题目描述
# 给定一个二叉树和其中的一个结点，请找出中序
# 遍历顺序的下一个结点并且返回。注意，树中的
# 结点不仅包含左右子结点，同时包含指向父结点
# 的指针。


class TreeLinkNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None
        self.next = None


class Solution:
    def GetNext(self, pNode):
        if not pNode:
            return None
        if pNode.right:
            pNode = pNode.right
            while pNode.left:
                pNode = pNode.left
            return pNode
        else:
            while pNode.next:
                if pNode == pNode.next.left:
                    return pNode.next
                pNode = pNode.next
        return None
