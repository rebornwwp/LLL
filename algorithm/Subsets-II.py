# Given a collection of integers that might contain duplicates, nums, return all possible subsets (the power set).

# Note: The solution set must not contain duplicate subsets.

# Example:

# Input: [1,2,2]
# Output:
# [
#   [2],
#   [1],
#   [1,2,2],
#   [2,2],
#   [1,2],
#   []
# ]


class Solution(object):
    def subsetsWithDup(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        if not nums:
            return []

        def dfs(nums, temp, ans):
            ans.append(temp[:])
            if not nums:
                return

            visited = []
            for i in range(len(nums)):
                if nums[i] not in visited:
                    visited.append(nums[i])
                    dfs(nums[i+1:], temp + [nums[i]], ans)

        ans = []
        nums = sorted(nums)
        dfs(nums, [], ans)
        return ans


s = Solution()
print(s.subsetsWithDup([1, 2, 2]))
