# encoding=utf8
# Given an integer array with all positive numbers and no duplicates, find the number of possible combinations that add up to a positive integer target.

# Example:

# nums = [1, 2, 3]
# target = 4

# The possible combination ways are:
# (1, 1, 1, 1)
# (1, 1, 2)
# (1, 2, 1)
# (1, 3)
# (2, 1, 1)
# (2, 2)
# (3, 1)

# Note that different sequences are counted as different combinations.

# Therefore the output is 7.


# Follow up:
# What if negative numbers are allowed in the given array?
# How does it change the problem?
# What limitation we need to add to the question to allow negative numbers?

# Credits:
# Special thanks to @pbrother for adding this problem and creating all test cases.

class Solution(object):
    def combinationSum4(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        # time limited exce
        self.count = 0

        def dfs(nums, target):
            if target == 0:
                self.count += 1
                return
            if target < 0:
                return
            for n in nums:
                dfs(nums, target - n)

        dfs(nums, target)
        return self.count

    def combinationSum41(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        # 上面的第一个解法为啥timelimit是我们dfs中有重复计算了，需要一个中间做存储的如同lru_cache一样

        def dfs(nums, temp_sum, target, d):
            if target == temp_sum:
                return 1
            if target < temp_sum:
                return 0
            if temp_sum in d:
                return d[temp_sum]

            count = 0
            for n in nums:
                count += dfs(nums, temp_sum + n,  target, d)

            d[temp_sum] = count
            return count

        d = {}
        count = dfs(nums, 0, target, d)
        return count

    def combinationSum42(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        # 对自己写的代码的优化

        def dfs(nums, target, d):
            if target == 0:
                return 1
            if target < 0:
                return 0
            if target in d:
                return d[target]

            count = 0
            for n in nums:
                count += dfs(nums, target - n, d)
            d[target] = count
            return count

        d = {}
        count = dfs(nums, target, d)
        return count


s = Solution()
print(s.combinationSum42([1, 2, 3], 4))
print(s.combinationSum42([4, 2, 1], 10))
