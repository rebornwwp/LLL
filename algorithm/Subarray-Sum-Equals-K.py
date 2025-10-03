# Given an array of integers and an integer k, you need to find the total number of continuous subarrays whose sum equals to k.
#
# Example 1:
# Input:nums = [1,1,1], k = 2
# Output: 2
# Note:
# The length of the array is in range [1, 20,000].
# The range of numbers in the array is [-1000, 1000] and the range of the integer k is [-1e7, 1e7].


class Solution:
    def subarraySum(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: int
        """
        sum = [0] * (len(nums) + 1)
        for i in range(1, len(nums) + 1):
            sum[i] = sum[i - 1] + nums[i - 1]
        count = 0
        for start in range(len(nums)):
            for end in range(start + 1, len(nums) + 1):
                if sum[end] - sum[start] == k:
                    count += 1
        return count

    def subarraySum1(self, nums, k):
        count = 0
        for i in range(len(nums)):
            sum = 0
            for j in range(i, len(nums)):
                sum += nums[j]
                if sum == k:
                    count += 1
        return count

    def subarraySum2(self, nums, k):
        count = 0
        d = {0: 1}
        sum = 0
        for num in nums:
            sum += num
            count += d.get(sum - k, 0)
            d[sum] = d.get(sum, 0) + 1
        return count


if __name__ == "__main__":
    s = Solution()
    print(s.subarraySum2([1, 2, 3], 3))
