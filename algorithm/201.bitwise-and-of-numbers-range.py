#
# @lc app=leetcode id=201 lang=python
#
# [201] Bitwise AND of Numbers Range
#
# https://leetcode.com/problems/bitwise-and-of-numbers-range/description/
#
# algorithms
# Medium (35.64%)
# Total Accepted:    78.8K
# Total Submissions: 221.1K
# Testcase Example:  '5\n7'
#
# Given a range [m, n] where 0 <= m <= n <= 2147483647, return the bitwise AND
# of all numbers in this range, inclusive.
#
# Example 1:
#
#
# Input: [5,7]
# Output: 4
#
#
# Example 2:
#
#
# Input: [0,1]
# Output: 0
#


class Solution(object):
    def rangeBitwiseAnd(self, m, n):
        """
        :type m: int
        :type n: int
        :rtype: int
        """
        a = 0
        while m != n:
            m >>= 1
            n >>= 1
            a += 1
        return m << a

    def rangeBitwiseAnd2(self, m, n):
        a, b = m.bit_length(), n.bit_length()
        if a != b:
            return 0

        mask = m & n
        diff = n - m
        diff_bits_length = diff.bit_length()
        mask &= ~((1 << diff_bits_length) - 1)
        return mask

    def rangeBitwiseAnd1(self, m, n):
        if len(bin(m)) != len(bin(n)):
            return 0
        else:
            ans = ''
            for i, j in zip(bin(m), bin(n)):
                if i == j:
                    ans += i
                else:
                    break
            ans += '0' * (len(bin(m)) - len(ans))
        return int(ans, 2)


s = Solution()
print(s.rangeBitwiseAnd(5, 7))
