# Given a 2D board and a word, find if the word exists in the grid.

# The word can be constructed from letters of sequentially adjacent cell, where "adjacent" cells are those horizontally or vertically neighboring. The same letter cell may not be used more than once.

# Example:

# board =
# [
#   ['A','B','C','E'],
#   ['S','F','C','S'],
#   ['A','D','E','E']
# ]

# Given word = "ABCCED", return true.
# Given word = "SEE", return true.
# Given word = "ABCB", return false.


class Solution(object):
    def exist(self, board, word):
        """
        :type board: List[List[str]]
        :type word: str
        :rtype: bool
        """

        def dfs(board, index, word, col, row):
            if index == len(word):
                return True
            if col < 0 or col >= len(board):
                return False
            if row < 0 or row >= len(board[0]):
                return False
            if word[index] != board[col][row]:
                return False

            board[col][row] = '#'
            result = dfs(board, index + 1, word, col, row - 1) or dfs(board, index + 1, word, col, row +
                                                                      1) or dfs(board, index + 1, word, col - 1, row) or dfs(board, index + 1, word, col + 1, row)
            board[col][row] = word[index]
            return result

        for col in range(len(board)):
            for row in range(len(board[0])):
                if dfs(board, 0, word, col, row):
                    return True
        return False

s = Solution()
board = [
    ['A', 'B', 'C', 'E'],
    ['S', 'F', 'C', 'S'],
    ['A', 'D', 'E', 'E']
]

word = "ABCB"

print(s.exist(board, word))
