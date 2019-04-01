#
# @lc app=leetcode id=268 lang=python
#
# [268] Missing Number
#
# https://leetcode.com/problems/missing-number/description/
#
# algorithms
# Easy (47.78%)
# Total Accepted:    257.1K
# Total Submissions: 537.6K
# Testcase Example:  '[3,0,1]'
#
# Given an array containing n distinct numbers taken from 0, 1, 2, ..., n, find
# the one that is missing from the array.
#
# Example 1:
#
#
# Input: [3,0,1]
# Output: 2
#
#
# Example 2:
#
#
# Input: [9,6,4,2,3,5,7,0,1]
# Output: 8
#
#
# Note:
# Your algorithm should run in linear runtime complexity. Could you implement
# it using only constant extra space complexity?
#


class Solution(object):
    def missingNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        expected_sum = len(nums)*(len(nums)+1)//2
        actual_sum = sum(nums)
        return expected_sum - actual_sum

    def missingNumber2(self, nums):
        ans = 0
        for n in nums:
            ans ^= n
        for n in range(len(nums) + 1):
            ans ^= n
        return ans

    def missingNumber1(self, nums):
        l = [False] * (len(nums) + 1)
        for n in nums:
            l[n] = True
        for i in range(len(l)):
            if l[i] == False:
                return i
