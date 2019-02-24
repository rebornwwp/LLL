# 从尾到头打印链表
# 题目描述
# 输入一个链表，按链表值从尾到头的顺序返回一个ArrayList

# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution:
    def printListFromTailToHead(self, listNode):
        result = []
        l = listNode
        while l:
            result.append(l.val)
            l = l.next
        return list(reversed(result))
