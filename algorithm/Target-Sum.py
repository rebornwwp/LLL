# You are given a list of non-negative integers, a1, a2, ..., an, and a target, S. Now you have 2 symbols + and -. For each integer, you should choose one from + and - as its new symbol.

# Find out how many ways to assign symbols to make sum of integers equal to target S.

# Example 1:
# Input: nums is [1, 1, 1, 1, 1], S is 3.
# Output: 5
# Explanation:

# -1+1+1+1+1 = 3
# +1-1+1+1+1 = 3
# +1+1-1+1+1 = 3
# +1+1+1-1+1 = 3
# +1+1+1+1-1 = 3

# There are 5 ways to assign symbols to make the sum of nums be target 3.
# Note:
# The length of the given array is positive and will not exceed 20.
# The sum of elements in the given array will not exceed 1000.
# Your output answer is guaranteed to be fitted in a 32-bit integer.


class Solution(object):
    def findTargetSumWays(self, nums, S):
        """
        :type nums: List[int]
        :type S: int
        :rtype: int
        """
        def dfs(nums, s, index):
            if index >= len(nums) and s == 0:
                return 1
            elif index >= len(nums) and s != 0:
                return 0
            ans = 0
            ans += dfs(nums, s - nums[index], index + 1)
            ans += dfs(nums, s + nums[index], index + 1)
            return ans

        return dfs(nums, S, 0)

    def findTargetSumWays1(self, nums, S):

        total = sum(nums)

        if S > total:
            return 0

        offset = total
        dp_length = 2 * total + 1
        dp = [0] * dp_length
        dp[offset] = 1
        for n in nums:
            temp = [0] * dp_length
            for i in range(n, dp_length - n):
                if dp[i] > 0:
                    temp[i + n] += dp[i]
                    temp[i - n] += dp[i]
            dp = temp

        return dp[offset + S]


so = Solution()
l = [1]
s = 3
print(so.findTargetSumWays1(l, s))
