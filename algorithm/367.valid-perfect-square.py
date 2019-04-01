#
# @lc app=leetcode id=367 lang=python
#
# [367] Valid Perfect Square
#
# https://leetcode.com/problems/valid-perfect-square/description/
#
# algorithms
# Easy (39.49%)
# Total Accepted:    103.4K
# Total Submissions: 261.6K
# Testcase Example:  '16'
#
# Given a positive integer num, write a function which returns True if num is a
# perfect square else False.
#
# Note: Do not use any built-in library function such as sqrt.
#
# Example 1:
#
#
#
# Input: 16
# Output: true
#
#
#
# Example 2:
#
#
# Input: 14
# Output: false
#
#
#
#


class Solution(object):
    def isPerfectSquare(self, num):
        """
        :type num: int
        :rtype: bool
        """
        eps = 0.1
        x_n = num / 2.0
        x_n_prev = 0.0
        while abs(x_n - x_n_prev) > eps:
            x_n_prev = x_n
            x_n = (1.0 / 2) * (x_n + num * 1.0 / x_n)
        return int(x_n) ** 2 == num

s = Solution()
print(s.isPerfectSquare(4))
