#
# @lc app=leetcode id=137 lang=python
#
# [137] Single Number II
#
# https://leetcode.com/problems/single-number-ii/description/
#
# algorithms
# Medium (45.39%)
# Total Accepted:    160.8K
# Total Submissions: 354.1K
# Testcase Example:  '[2,2,3,2]'
#
# Given a non-empty array of integers, every element appears three times except
# for one, which appears exactly once. Find that single one.
#
# Note:
#
# Your algorithm should have a linear runtime complexity. Could you implement
# it without using extra memory?
#
# Example 1:
#
#
# Input: [2,2,3,2]
# Output: 3
#
#
# Example 2:
#
#
# Input: [0,1,0,1,0,1,99]
# Output: 99
#
#


class Solution(object):
    def singleNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        a = 0
        b = 0
        for n in nums:
            b = (b ^ n) & ~a
            a = (a ^ n) & ~b
        return b

    def singleNumber2(self, nums):
        one = 0
        two = 0
        three = 0
        for n in nums:
            two |= one & n
            one ^= n
            three = one & two
            one &= ~three
            two &= ~three
        return one

    def singleNumber1(self, nums):
        d = {}
        for n in nums:
            d[n] = d.get(n, 0) + 1
        for key in d:
            if d[key] == 1:
                return key
