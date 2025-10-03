#
# @lc app=leetcode id=326 lang=python
#
# [326] Power of Three
#
# https://leetcode.com/problems/power-of-three/description/
#
# algorithms
# Easy (41.47%)
# Total Accepted:    174.7K
# Total Submissions: 421.3K
# Testcase Example:  '27'
#
# Given an integer, write a function to determine if it is a power of three.
#
# Example 1:
#
#
# Input: 27
# Output: true
#
#
# Example 2:
#
#
# Input: 0
# Output: false
#
# Example 3:
#
#
# Input: 9
# Output: true
#
# Example 4:
#
#
# Input: 45
# Output: false
#
# Follow up:
# Could you do it without using any loop / recursion?
#


class Solution(object):
    def isPowerOfThree(self, n):
        """
        :type n: int
        :rtype: bool
        """
        import math
        if n <= 0:
            return False
        r = math.log10(n) / math.log10(3)
        if (r % 1 == 0):
            return True
        else:
            return False

    def isPowerOfThree1(self, n):
        return (n > 0) and (1162261467 % n == 0)
