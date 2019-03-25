#
# @lc app=leetcode id=109 lang=python
#
# [109] Convert Sorted List to Binary Search Tree
#
# https://leetcode.com/problems/convert-sorted-list-to-binary-search-tree/description/
#
# algorithms
# Medium (39.90%)
# Total Accepted:    167.5K
# Total Submissions: 419.7K
# Testcase Example:  '[-10,-3,0,5,9]'
#
# Given a singly linked list where elements are sorted in ascending order,
# convert it to a height balanced BST.
#
# For this problem, a height-balanced binary tree is defined as a binary tree
# in which the depth of the two subtrees of every node never differ by more
# than 1.
#
# Example:
#
#
# Given the sorted linked list: [-10,-3,0,5,9],
#
# One possible answer is: [0,-3,9,-10,null,5], which represents the following
# height balanced BST:
#
# ⁠     0
# ⁠    / \
# ⁠  -3   9
# ⁠  /   /
# ⁠-10  5
#
#
#
# Definition for singly-linked list.


class ListNode(object):
    def __init__(self, x):
        self.val = x
        self.next = None

# Definition for a binary tree node.


class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution(object):
    def sortedListToBST(self, head):
        """
        :type head: ListNode
        :rtype: TreeNode
        """
        if not head:
            return None
        if not head.next:
            return TreeNode(head.val)
        slow = None
        fast = head
        while fast and fast.next:
            if slow is None:
                slow = head
            else:
                slow = slow.next
            fast = fast.next.next
        node = TreeNode(slow.next.val)
        temp = slow.next.next
        slow.next.next = None
        node.right = self.sortedListToBST(temp)
        slow.next = None
        node.left = self.sortedListToBST(head)
        return node
