# The n-queens puzzle is the problem of placing n queens on an n×n chessboard such that no two queens attack each other.
# Given an integer n, return the number of distinct solutions to the n-queens puzzle.

# Example:

# Input: 4
# Output: 2
# Explanation: There are two distinct solutions to the 4-queens puzzle as shown below.
# [
#  [".Q..",  // Solution 1
#   "...Q",
#   "Q...",
#   "..Q."],

#  ["..Q.",  // Solution 2
#   "Q...",
#   "...Q",
#   ".Q.."]
# ]


class Solution(object):
    def totalNQueens(self, n):
        """
        :type n: int
        :rtype: int
        """

        def dfs(n, col, temp, ans):

            if len(temp) == n:
                ans.append(temp[:])

            for i in range(n):
                if not any([col - x == 0 or i - y == 0 or abs(col - x) == abs(i - y) for x, y in temp]):
                    temp.append((col, i))
                    dfs(n, col + 1, temp, ans)
                    temp.pop()

        locations = []
        dfs(n, 0, [], locations)

        return len(locations)
