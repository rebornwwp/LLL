# The n-queens puzzle is the problem of placing n queens on an n×n chessboard such that no two queens attack each other.


# Given an integer n, return all distinct solutions to the n-queens puzzle.

# Each solution contains a distinct board configuration of the n-queens' placement, where 'Q' and '.' both indicate a queen and an empty space respectively.

# Example:

# Input: 4
# Output: [
#  [".Q..",  // Solution 1
#   "...Q",
#   "Q...",
#   "..Q."],

#  ["..Q.",  // Solution 2
#   "Q...",
#   "...Q",
#   ".Q.."]
# ]
# Explanation: There exist two distinct solutions to the 4-queens puzzle as shown above.

class Solution(object):
    def solveNQueens(self, n):
        """
        :type n: int
        :rtype: List[List[str]]
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

        import copy
        ans = []
        for i in range(len(locations)):
            l = [['.'] * n for _ in range(n)]
            for col, row in locations[i]:
                l[col][row] = 'Q'
            ans.append(l)
        return [[''.join(row) for row in one] for one in ans]


s = Solution()
result = s.solveNQueens(4)

for i in result:
    for row in i:
        print(row)
    print('=' * 20)
