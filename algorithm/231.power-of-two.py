#
# @lc app=leetcode id=231 lang=python
#
# [231] Power of Two
#
# https://leetcode.com/problems/power-of-two/description/
#
# algorithms
# Easy (41.72%)
# Total Accepted:    218K
# Total Submissions: 522.3K
# Testcase Example:  '1'
#
# Given an integer, write a function to determine if it is a power of two.
#
# Example 1:
#
#
# Input: 1
# Output: true
# Explanation: 2^0 = 1
#
#
# Example 2:
#
#
# Input: 16
# Output: true
# Explanation: 2^4 = 16
#
# Example 3:
#
#
# Input: 218
# Output: false
#
#


class Solution(object):
    def isPowerOfTwo(self, n):
        """
        :type n: int
        :rtype: bool
        """
        if n == 0:
            return False
        return n & (n - 1) == 0
