#
# @lc app=leetcode id=477 lang=python
#
# [477] Total Hamming Distance
#
# https://leetcode.com/problems/total-hamming-distance/description/
#
# algorithms
# Medium (48.69%)
# Total Accepted:    44.8K
# Total Submissions: 91.9K
# Testcase Example:  '[4,14,2]'
#
# The Hamming distance between two integers is the number of positions at which
# the corresponding bits are different.
#
# Now your job is to find the total Hamming distance between all pairs of the
# given numbers.
#
#
# Example:
#
# Input: 4, 14, 2
#
# Output: 6
#
# Explanation: In binary representation, the 4 is 0100, 14 is 1110, and 2 is
# 0010 (just
# showing the four bits relevant in this case). So the answer will be:
# HammingDistance(4, 14) + HammingDistance(4, 2) + HammingDistance(14, 2) = 2 +
# 2 + 2 = 6.
#
#
#
# Note:
#
# Elements of the given array are in the range of 0  to 10^9
# Length of the array will not exceed 10^4.
#
#
#


class Solution(object):
    def totalHammingDistance(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        N = len(nums)
        m = [0] * 32
        for n in nums:
            bits = bin(n)[::-1][:-2]
            for i in range(len(bits)):
                if bits[i] == '1':
                    m[i] += 1
        total = 0
        for n in m:
            total += (N - n) * n
        return total
