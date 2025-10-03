# Find all possible combinations of k numbers that add up to a number n, given that only numbers from 1 to 9 can be used and each combination should be a unique set of numbers.

# Note:

# All numbers will be positive integers.
# The solution set must not contain duplicate combinations.
# Example 1:

# Input: k = 3, n = 7
# Output: [[1,2,4]]
# Example 2:

# Input: k = 3, n = 9
# Output: [[1,2,6], [1,3,5], [2,3,4]]


class Solution(object):
    def combinationSum3(self, k, n):
        """
        :type k: int
        :type n: int
        :rtype: List[List[int]]
        """

        def dfs(index, k, target, temp, ans):
            if target == 0 and k == 0:
                ans.append(temp[:])

            if target < 0 or k < 0:
                return

            for i in range(index, 10):
                temp.append(i)
                dfs(i + 1, k - 1, target - i, temp, ans)
                temp.pop()

        ans = []
        dfs(1, k, n, [], ans)
        return ans


s = Solution()
print(s.combinationSum3(3, 9))
