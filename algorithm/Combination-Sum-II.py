# Given a collection of candidate numbers (candidates) and a target number (target), find all unique combinations in candidates where the candidate numbers sums to target.

# Each number in candidates may only be used once in the combination.

# Note:

# All numbers (including target) will be positive integers.
# The solution set must not contain duplicate combinations.
# Example 1:

# Input: candidates = [10,1,2,7,6,1,5], target = 8,
# A solution set is:
# [
#   [1, 7],
#   [1, 2, 5],
#   [2, 6],
#   [1, 1, 6]
# ]
# Example 2:

# Input: candidates = [2,5,2,1,2], target = 5,
# A solution set is:
# [
#   [1,2,2],
#   [5]
# ]


class Solution(object):
    def combinationSum2(self, candidates, target):
        """
        :type candidates: List[int]
        :type target: int
        :rtype: List[List[int]]
        """
        if not candidates:
            return []

        def dfs(candidates, target, temp, ans):
            if target == 0:
                ans.append(temp[:])
            if target < 0:
                return

            visited = []
            for i in range(len(candidates)):
                if candidates[i] not in visited:
                    visited.append(candidates[i])
                    temp.append(candidates[i])
                    dfs(candidates[i+1:], target - candidates[i], temp, ans)
                    temp.pop()

        ans = []
        candidates = sorted(candidates)
        dfs(candidates, target, [], ans)
        return ans
