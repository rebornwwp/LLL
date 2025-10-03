# encoding=utf8
# Given a collection of numbers that might contain duplicates, return all possible unique permutations.

# Example:

# Input: [1,1,2]
# Output:
# [
#   [1,1,2],
#   [1,2,1],
#   [2,1,1]
# ]


class Solution(object):
    def permuteUnique(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        if not nums:
            return []

        def dfs(nums, temp, ans):
            if not nums:
                ans.append(temp[:])

            visited = []
            for i in range(len(nums)):
                # 过滤掉重复数字的dfs
                if nums[i] in visited:
                    continue
                temp.append(nums[i])
                visited.append(nums[i])
                dfs(nums[0:i] + nums[i + 1:], temp, ans)
                temp.pop()

        ans = []
        dfs(nums, [], ans)
        return ans


s = Solution()
print(s.permuteUnique([1, 1, 2]))
