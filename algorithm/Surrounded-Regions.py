# encoding=utf8

# Given a 2D board containing 'X' and 'O' (the letter O), capture all regions surrounded by 'X'.

# A region is captured by flipping all 'O's into 'X's in that surrounded region.

# Example:

# X X X X
# X O O X
# X X O X
# X O X X
# After running your function, the board should be:

# X X X X
# X X X X
# X X X X
# X O X X
# Explanation:

# Surrounded regions shouldn’t be on the border, which means that any 'O' on the border of the board are not flipped to 'X'. Any 'O' that is not on the border and it is not connected to an 'O' on the border will be flipped to 'X'. Two cells are connected if they are adjacent cells connected horizontally or vertically.


class Solution(object):
    def solve(self, board):
        """
        :type board: List[List[str]]
        :rtype: None Do not return anything, modify board in-place instead.
        """
        if not board:
            return

        def dfs(board, i, j):
            if i < 0 or i >= len(board):
                return
            if j < 0 or j >= len(board[0]):
                return
            if board[i][j] != 'O':
                return
            board[i][j] = 'Z'
            dfs(board, i - 1, j)
            dfs(board, i + 1, j)
            dfs(board, i, j - 1)
            dfs(board, i, j + 1)

        i, j = 0, 0
        while j < len(board[0]):
            if board[i][j] == 'O':
                dfs(board, i, j)
            j += 1

        i, j = len(board) - 1, 0
        while j < len(board[0]):
            if board[i][j] == 'O':
                dfs(board, i, j)
            j += 1

        i, j = 0, 0
        while i < len(board):
            if board[i][j] == 'O':
                dfs(board, i, j)
            i += 1

        i, j = 0, len(board[0]) - 1
        while i < len(board):
            if board[i][j] == 'O':
                dfs(board, i, j)
            i += 1

        for i in range(len(board)):
            for j in range(len(board[0])):
                if board[i][j] != 'Z':
                    board[i][j] = 'X'
                else:
                    board[i][j] = 'O'


l = [['X', 'X', 'X', 'X'], ['X', 'O', 'O', 'X'],
     ['X', 'X', 'O', 'X'], ['X', 'O', 'X', 'X']]
s = Solution()
# inplace modify
s.solve(l)
print(l)
