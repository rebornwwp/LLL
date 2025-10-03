# Given an integer array nums, find the contiguous subarray within an array (containing at least one number) which has the largest product.

# Example 1:

# Input: [2,3,-2,4]
# Output: 6
# Explanation: [2,3] has the largest product 6.
# Example 2:

# Input: [-2,0,-1]
# Output: 0
# Explanation: The result cannot be 2, because [-2,-1] is not a subarray.


class Solution:
    def maxProduct(self, nums):
        if not nums:
            return 0
        maxNums = [0] * len(nums)
        minNums = [0] * len(nums)
        maxNums[0] = nums[0]
        minNums[0] = nums[0]
        result = maxNums[0]
        for i in range(1, len(nums)):
            if nums[i] > 0:
                maxNums[i] = max(nums[i], maxNums[i - 1] * nums[i])
                minNums[i] = min(nums[i], minNums[i - 1] * nums[i])
            else:
                maxNums[i] = max(nums[i], minNums[i - 1] * nums[i])
                minNums[i] = min(nums[i], maxNums[i - 1] * nums[i])
            result = max(result, maxNums[i])
        return result


if __name__ == "__main__":
    l = [-2, 0, -1]
    r = [2, 3, -2, 4]
    s = Solution()
    print(s.maxProduct(l))
    print(s.maxProduct(r))
