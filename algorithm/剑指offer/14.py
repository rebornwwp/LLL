# 链表中倒数第k个节点
# 题目描述
# 输入一个链表，输出该链表中倒数第k个结点。


# class ListNode:
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution:
    def FindKthToTail(self, head, k):
        count = 0
        h = head
        while h:
            count += 1
            h = h.next
        if k > count:
            return None
        h = head
        forward_count = count - k
        while forward_count > 0:
            h = h.next
            forward_count -= 1
        return h
