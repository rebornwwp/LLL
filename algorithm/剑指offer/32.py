# 删除链表中重复节点
# 题目描述
# 在一个排序的链表中，存在重复的结点，请删除该链
# 表中重复的结点，重复的结点不保留，返回链表头指
# 针。 例如，链表1->2->3->3->4->4->5 处理后
# 为 1->2->5


class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution:
    def deleteDuplication(self, pHead):
        if not pHead or not pHead.next:
            return pHead
        new_head = ListNode(-1)
        new_head.next = pHead  # former node

        pre = new_head
        p = pHead  # cur node
        next = None
        while p and p.next:
            next = p.next  # later node
            if p.val == next.val:
                while next and next.val == p.val:
                    next = next.next
                p = next
                pre.next = next
            else:
                pre = p
                p = next
        return new_head.next
