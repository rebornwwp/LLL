# 反转链表
# 题目描述
# 输入一个链表，反转链表后，输出新链表的表头。

# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution:
    def ReverseList(self, pHead):
        p = None
        h = pHead
        while h:
            head = h
            temp = ListNode(head.val)
            temp.next = p
            p = temp
            h = h.next
        return p
