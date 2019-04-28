class Solution:
    def isEscapePossible(self, blocked: List[List[int]], source: List[int], target: List[int]) -> bool:
        blocked = tuple(map(tuple, blocked))

        def bfs(source, target):
            q = [tuple(source)]
            visited = set()
            moves = [(1, 0), (-1, 0), (0, 1), (0, -1)]
            level = 0
            while q:
                for _ in range(len(q)):
                    tmp = q.pop(0)
                    if tmp[0] == target[0] and tmp[1] == target[1]:
                        return True

                    for x, y in moves:
                        xs = tmp[0] + x
                        ys = tmp[1] + y
                        point = (xs, ys)
                        if 0 <= xs <= 10**6 and 0 <= ys <= 10**6 and point not in visited and point not in blocked:
                            visited.add(point)
                            q.append(point)
                level += 1
                if level >= len(blocked):
                    return True
            return False
        
        return bfs(source, target)
