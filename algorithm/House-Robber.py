# You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night.

# Given a list of non-negative integers representing the amount of money of each house, determine the maximum amount of money you can rob tonight without alerting the police.

# Example 1:

# Input: [1,2,3,1]
# Output: 4
# Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3).
#              Total amount you can rob = 1 + 3 = 4.
# Example 2:

# Input: [2,7,9,3,1]
# Output: 12
# Explanation: Rob house 1 (money = 2), rob house 3 (money = 9) and rob house 5 (money = 1).
#              Total amount you can rob = 2 + 9 + 1 = 12.


class Solution:
    def rob(self, nums):
        """
        DP Time Limit Exceeded
        """
        def helper(nums, n):
            if n == 0:
                return nums[n]
            if n == 1:
                return max(nums[n], nums[n - 1])
            return max(helper(nums, n - 1), helper(nums, n - 2) + nums[n])
        if len(nums) == 0:
            return 0
        if len(nums) <= 2:
            return max(nums)
        return helper(nums, len(nums) - 1)

    def rob1(self, nums):
        if len(nums) == 0:
            return 0
        dp1 = 0
        dp2 = 0
        for i in range(len(nums)):
            dp = max(dp2, dp1 + nums[i])
            dp1 = dp2
            dp2 = dp

        return dp1


if __name__ == "__main__":
    s = Solution()
    print(s.rob([1, 7, 9, 2]))
    print(s.rob1([1, 7, 9, 2]))
