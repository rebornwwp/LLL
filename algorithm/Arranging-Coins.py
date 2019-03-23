# encoding=utf8

# You have a total of n coins that you want to form in a staircase shape, where every k-th row must have exactly k coins.

# Given n, find the total number of full staircase rows that can be formed.

# n is a non-negative integer and fits within the range of a 32-bit signed integer.

# Example 1:

# n = 5

# The coins can form the following rows:
# ¤
# ¤ ¤
# ¤ ¤

# Because the 3rd row is incomplete, we return 2.
# Example 2:

# n = 8

# The coins can form the following rows:
# ¤
# ¤ ¤
# ¤ ¤ ¤
# ¤ ¤

# Because the 4th row is incomplete, we return 3.


class Solution(object):
    def arrangeCoins(self, n):
        """
        :type n: int
        :rtype: int
        """
        i = 0
        while n >= 0:
            n = n - i - 1
            i += 1
        return i - 1

    def arrangeCoins1(self, n):
        start = 0
        end = n
        while start <= end:
            mid = (start + end) // 2
            total = mid * (mid + 1) / 2
            if total > n:
                end = mid - 1
                ans = mid
            else:
                start = mid + 1
                ans = mid
        return ans

s = Solution()

print(s.arrangeCoins(8))

