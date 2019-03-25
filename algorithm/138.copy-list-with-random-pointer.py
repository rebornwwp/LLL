#
# @lc app=leetcode id=138 lang=python
#
# [138] Copy List with Random Pointer
#
# https://leetcode.com/problems/copy-list-with-random-pointer/description/
#
# algorithms
# Medium (26.13%)
# Total Accepted:    230.1K
# Total Submissions: 880.6K
# Testcase Example:  '{"$id":"1","next":{"$id":"2","next":null,"random":{"$ref":"2"},"val":2},"random":{"$ref":"2"},"val":1}'
#
# A linked list is given such that each node contains an additional random
# pointer which could point to any node in the list or null.
#
# Return a deep copy of the list.
#
#
#
# Example 1:
#
#
#
#
# Input:
#
# {"$id":"1","next":{"$id":"2","next":null,"random":{"$ref":"2"},"val":2},"random":{"$ref":"2"},"val":1}
#
# Explanation:
# Node 1's value is 1, both of its next and random pointer points to Node 2.
# Node 2's value is 2, its next pointer points to null and its random pointer
# points to itself.
#
#
#
#
# Note:
#
#
# You must return the copy of the given head as a reference to the cloned list.
#
#

# Definition for a Node.


class Node(object):
    def __init__(self, val, next, random):
        self.val = val
        self.next = next
        self.random = random


class Solution(object):
    def copyRandomList(self, head):
        """
        :type head: Node
        :rtype: Node
        """
        if not head:
            return None
        h = head
        while h:
            next_h = h.next
            h.next = Node(h.val, next_h, None)
            h = h.next.next
        h = head
        while h:
            if h.random is not None:
                h.next.random = h.random.next
            else:
                h.next.random = h.random
            h = h.next.next

        p = head
        a = []
        b = []
        while p and p.next:
            a.append(p)
            b.append(p.next)
            p = p.next.next
        for i in range(len(a) - 1):
            a[i].next = a[i + 1]
            b[i].next = b[i + 1]
        a[-1].next = None
        b[-1].next = None
        return b[0]
