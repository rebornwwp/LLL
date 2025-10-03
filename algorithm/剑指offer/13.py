# 合并两个排序的链表
# 题目描述
# 输入两个单调递增的链表，输出两个链表
# 合成后的链表，当然我们需要合成后的链
# 表满足单调不减规则。

# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution:
    def Merge(self, pHead1, pHead2):
        result = ListNode(0)
        a = result
        while pHead1 and pHead2:
            if pHead1.val > pHead2.val:
                a.next = pHead2
                a = a.next
                pHead2 = pHead2.next
            else:
                a.next = pHead1
                a = a.next
                pHead1 = pHead1.next
        while pHead1:
            a.next = pHead1
            a = a.next
            pHead1 = pHead1.next

        while pHead2:
            a.next = pHead2
            a = a.next
            pHead2 = pHead2.next
        return result.next
