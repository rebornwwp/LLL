# encoding=utf8

# Given a 2d grid map of '1's (land) and '0's (water), count the number of islands. An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.
# Example 1:
# Input:
# 11110
# 11010
# 11000
# 00000
# Output: 1
# Example 2:
# Input:
# 11000
# 11000
# 00100
# 00011
# Output: 3


class Solution:
    def numIslands(self, grid):
        if not grid:
            return 0

        width, height = len(grid[0]), len(grid)
        if width == 0 and height == 0:
            return 0

        visited = [[False for _ in range(width)] for _ in range(height)]
        count = 0
        for i in range(height):
            for j in range(width):
                if grid[i][j] == '1' and not visited[i][j]:
                    self.dfs(grid, visited, i, j)
                    count += 1
        return count

    def dfs(self, grid, visited, i, j):
        # 超越边界的终止条件
        if i < 0 or i >= len(grid):
            return
        if j < 0 or j >= len(grid[0]):
            return
        # 一个是岛边界终止条件，一个是遍历过的点就不用继续遍历了
        if grid[i][j] != '1' or visited[i][j]:
            return
        visited[i][j] = True
        self.dfs(grid, visited, i - 1, j)
        self.dfs(grid, visited, i + 1, j)
        self.dfs(grid, visited, i, j - 1)
        self.dfs(grid, visited, i, j + 1)

    def numIslands1(self, grid):
        """
        :type grid: List[List[str]]
        :rtype: int
        """
        # inplace dfs
        if not grid:
            return 0

        def dfs(grid, i, j):
            # 超越边界的终止条件
            if i < 0 or i >= len(grid):
                return
            if j < 0 or j >= len(grid[0]):
                return

            # 遇到海就终止
            if grid[i][j] == '0':
                return

            grid[i][j] = '0'
            dfs(grid, i - 1, j)
            dfs(grid, i + 1, j)
            dfs(grid, i, j - 1)
            dfs(grid, i, j + 1)

        count = 0
        for i in range(len(grid)):
            for j in range(len(grid[0])):
                if grid[i][j] == '1':
                    count += 1
                    dfs(grid, i, j)

        return count


if __name__ == "__main__":
    islands = [["1", "1", "1", "1", "0"], ["1", "1", "0", "1", "0"],
               ["1", "1", "0", "0", "0"], ["0", "0", "0", "0", "0"]]
    s = Solution()
    print(s.numIslands1(islands))
