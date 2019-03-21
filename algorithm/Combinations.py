# Given two integers n and k, return all possible combinations of k numbers out of 1 ... n.

# Example:

# Input: n = 4, k = 2
# Output:
# [
#   [2,4],
#   [3,4],
#   [2,3],
#   [1,2],
#   [1,3],
#   [1,4],
# ]


class Solution(object):
    def combine(self, n, k):
        """
        :type n: int
        :type k: int
        :rtype: List[List[int]]
        """
        if n < k:
            return []
        if k == 0:
            return [[]]

        def dfs(n, i, temp, k, ans):
            if k == len(temp):
                ans.append(temp[:])
                return

            for x in range(i, n):
                temp.append(x + 1)
                dfs(n, x + 1, temp, k, ans)
                temp.pop()

        ans = []
        dfs(n, 0, [], k, ans)
        return ans


s = Solution()
print(s.combine(4, 3))
