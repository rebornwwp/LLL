# Description
# Given a list of numbers, return all possible permutations.
# You can assume that there is no duplicate numbers in the list.
# Example
# Example 1:

# Input: [1]
# Output:
# [
#   [1]
# ]
# Example 2:

# Input: [1,2,3]
# Output:
# [
#   [1,2,3],
#   [1,3,2],
#   [2,1,3],
#   [2,3,1],
#   [3,1,2],
#   [3,2,1]
# ]
# Challenge
# Do it without recursion.


class Solution:
    """
    @param: nums: A list of integers.
    @return: A list of permutations.
    """

    def permute(self, nums):
        if not nums:
            return [[]]

        def dfs(nums, index, cur, ans):
            if index == len(nums):
                ans.append(cur[:])
                return
            for num in nums:
                cur.append(num)
                dfs(nums, index + 1, cur, ans)
                cur.pop()
        ans = []
        dfs(nums, 0, [], ans)
        return [l for l in ans if len(set(l)) == len(nums)]

    def permute1(self, nums):
        if not nums:
            return [[]]

        def dfs(nums, cur, ans):
            if 0 == len(nums):
                ans.append(cur[:])
                return
            for i in range(len(nums)):
                cur.append(nums[i])
                temp_nums = nums[0:i] + nums[i + 1:]
                dfs(temp_nums, cur, ans)
                cur.pop()
        ans = []
        dfs(nums, [], ans)
        return ans

    def permute2(self, nums):
        if not nums:
            return [[]]

        def dfs(nums, cur, ans):
            if len(cur) == len(nums):
                ans.append(cur[:])
                return
            for n in nums:
                if n in cur:
                    continue
                cur.append(n)
                dfs(nums, cur, ans)
                cur.pop()
        ans = []
        dfs(nums, [], ans)
        return ans
