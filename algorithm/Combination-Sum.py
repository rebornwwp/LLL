# Given a set of candidate numbers (candidates) (without duplicates) and a target number (target), find all unique combinations in candidates where the candidate numbers sums to target.

# The same repeated number may be chosen from candidates unlimited number of times.

# Note:

# All numbers (including target) will be positive integers.
# The solution set must not contain duplicate combinations.
# Example 1:

# Input: candidates = [2,3,6,7], target = 7,
# A solution set is:
# [
#   [7],
#   [2,2,3]
# ]
# Example 2:

# Input: candidates = [2,3,5], target = 8,
# A solution set is:
# [
#   [2,2,2,2],
#   [2,3,3],
#   [3,5]
# ]


class Solution(object):
    def combinationSum(self, candidates, target):
        """
        :type candidates: List[int]
        :type target: int
        :rtype: List[List[int]]
        """
        if not candidates:
            return []
        if target == 0:
            return [[]]

        def dfs(candidates, temp, target, ans):
            if target == 0:
                ans.append(temp[:])
                return
            if target < 0:
                return
            for i in range(len(candidates)):
                temp.append(candidates[i])
                dfs(candidates[i:], temp, target - candidates[i], ans)
                temp.pop()

        ans = []
        candidates = sorted(candidates)
        dfs(candidates, [], target, ans)
        return ans


s = Solution()
l = [2, 3, 6, 7]
target = 7
print(s.combinationSum(l, target))
