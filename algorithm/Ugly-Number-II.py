# Write a program to find the n-th ugly number.

# Ugly numbers are positive numbers whose prime factors only include 2, 3, 5.

# Example:

# Input: n = 10
# Output: 12
# Explanation: 1, 2, 3, 4, 5, 6, 8, 9, 10, 12 is the sequence of the first 10 ugly numbers.
# Note:

# 1 is typically treated as an ugly number.
# n does not exceed 1690.


class Solution(object):
    def nthUglyNumber(self, n):
        """
        :type n: int
        :rtype: int
        """
        i = 1
        ans = [1]
        x, y, z = 0, 0, 0
        while i != n:
            m = min(x * 2, y * 3, z * 5)

            if ans != m:
                i += 1
            ans = m

            if m == x * 2:
                x += 1
            elif m == y * 3:
                y += 1
            elif m == z * 5:
                z += 1
        return ans


s = Solution()
print(s.nthUglyNumber(10))
