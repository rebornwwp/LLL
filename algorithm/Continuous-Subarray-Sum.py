# Given a list of non-negative numbers and a target integer k, write a function to check if the array has a continuous subarray of size at least 2 that sums up to the multiple of k, that is, sums up to n*k where n is also an integer.
# Example 1:

# Input: [23, 2, 4, 6, 7],  k=6
# Output: True
# Explanation: Because [2, 4] is a continuous subarray of size 2 and sums up to 6.
# Example 2:

# Input: [23, 2, 6, 4, 7],  k=6
# Output: True
# Explanation: Because [23, 2, 6, 4, 7] is an continuous subarray of size 5 and sums up to 42.


# Note:

# The length of the array won't exceed 10,000.
# You may assume the sum of all the numbers is in the range of a signed 32-bit integer.

class Solution(object):
    def checkSubarraySum(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: bool
        """
        # out of memory
        k = abs(k)
        if k != 0:
            nums = [n % k for n in nums]
        if k == 0:
            return False
        l = sum(nums) + 1
        dp = [False] * l
        s = -1
        for n in nums:
            temp_dp = [False] * l
            for i in range(l):
                if dp[i]:
                    if (i + n) % k == 0:
                        return True
                    temp_dp[i + n] = True
            dp = temp_dp
            if s != -1:
                if (s + n) % k == 0:
                    return True
                dp[s + n] = True
            s = n
        return False

    def checkSubarraySum1(self, nums, k):
        if k != 0:
            nums = [n % k for n in nums]

        if k == 0:
            for i in range(len(nums) - 1):
                if nums[i] == 0 and nums[i + 1] == 0:
                    return True
            return False

        d = set()
        s = -1
        k = abs(k)
        for n in nums:
            temp = set()
            for x in d:
                if k > 0 and (x + n) % k == 0:
                    return True
                temp.add(x + n)
            d = temp
            if s != -1:
                if k > 0 and (s + n) % k == 0:
                    return True
                d.add(s + n)
            s = n
        return False

    def checkSubarraySum2(self, nums, k):
        d = {0: -1}
        nnum = 0
        for i, n in enumerate(nums):
            if k != 0:
                nnum = (nnum + n) % k
            else:
                nnum = nnum + n
            if nnum not in d:
                d[nnum] = i
            else:
                if i - d[nnum] >= 2:
                    return True
        return False


s = Solution()
print(s.checkSubarraySum2([23, 6, 4, 7], 6))
print(s.checkSubarraySum2([1, 1000000000], 1))
print(s.checkSubarraySum2([1, 1000000000], 0))
print(s.checkSubarraySum2([0, 0], 0))
