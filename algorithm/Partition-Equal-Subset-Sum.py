# Given a non-empty array containing only positive integers, find if the array can be partitioned into two subsets such that the sum of elements in both subsets is equal.

# Note:
# Each of the array element will not exceed 100.
# The array size will not exceed 200.
# Example 1:

# Input: [1, 5, 11, 5]

# Output: true

# Explanation: The array can be partitioned as [1, 5, 5] and [11].
# Example 2:

# Input: [1, 2, 3, 5]

# Output: false

# Explanation: The array cannot be partitioned into equal sum subsets.

# 注意1: 肯定是所有数只和为偶数


class Solution(object):
    def canPartition(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        total = sum(nums)
        length = 2 * total + 1
        offset = total
        dp = [False] * length
        dp[offset] = True
        for n in nums:
            temp = [False] * length
            for i in range(n, length - n):
                if dp[i]:
                    temp[i - n] = True
                    temp[i + n] = True
            dp = temp

        return dp[offset]

    def canPartition1(self, nums):
        """
        :type nums: List[int]
        :rtype: bool
        """
        total = sum(nums)
        if total & 1 == 1:
            return False
        dp = [False] * (total + 1)
        dp[0] = True
        for n in nums:
            for i in range(total, -1, -1):
                if dp[i]:
                    dp[i + n] = True
            if dp[total // 2]:
                return True
        return False


s = Solution()
l = [1, 5, 11, 9]
print(s.canPartition1(l))
