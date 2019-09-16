n = int(input())

grid = [[int(i) for i in input().split()] for _ in range(n)]

visited = [[False for _ in range(n)] for _ in range(n)]


def is_valid(x, y):
    return x >= 0 and x < n and y >= 0 and y < n


def next_points(points):
    p1 = (points[0] - 1, points[1])
    p2 = (points[0] + 1, points[1])
    p3 = (points[0], points[1] - 1)
    p4 = (points[0], points[1] + 1)
    return [p1, p2, p3, p4]


def collect_not_allows(grid, visited, x, y, not_allows, allows):
    if not visited[x][y]:
        if grid[x][y] == 1:
            not_allows.append([x, y])
        else:
            visited[x][y] = True
            allows.append([x, y])


def bfs(grid, visited):
    i = 0
    j = 0
    k = 0
    visited[0][0] = True
    allows = [[0, 0]]
    not_allows = []
    while not visited[n - 1][n - 1]:
        while len(allows) > 0:
            point = allows.pop()
            visited[point[0]][point[1]] = True
            for x, y in next_points(point):
                if is_valid(x, y):
                    collect_not_allows(grid, visited, x, y, not_allows, allows)

        if visited[n - 1][n - 1]:
            return k

        while len(not_allows) > 0:
            point = not_allows.pop()
            grid[point[0]][point[1]] = 0
            visited[point[0]][point[1]] = False
            allows.append([point[0], point[1]])

        k += 1
    return k


k = bfs(grid, visited)
print(k)

