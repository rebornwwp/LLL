# 描述
# 给定一个有向图，图节点的拓扑排序定义如下:
# 对于图中的每一条有向边 A -> B , 在拓扑排序中A一定在B之前.
# 拓扑排序中的第一个节点可以是图中的任何一个没有其他节点指向它的节点.
# 针对给定的有向图找到任意一种拓扑排序的顺序.
# Definition for a Directed graph node


class DirectedGraphNode:
    def __init__(self, x):
        self.label = x
        self.neighbors = []


class Solution:
    """
    @param: graph: A list of Directed graph node
    @return: Any topological order for the given graph.
    """

    def topSort(self, graph):

        def dfs(ans, root, visited):
            if root in visited:
                return

            for n in root.neighbors:
                dfs(ans, n, visited)
            ans.insert(0, root)
            visited.append(root)
            print([i.label for i in visited])

        ans = []
        visited = []
        for root in graph:
            dfs(ans, root, visited)
        return ans

    def topSort1(self, graph):
        indegrees = dict()
        for g in graph:
            if g not in indegrees:
                indegrees[g] = 0
            for i in g.neighbors:
                if i not in indegrees:
                    indegrees[i] = 1
                else:
                    indegrees[i] += 1

        def remove(indegrees, e):
            if e in indegrees and indegrees[e] == 0:
                del indegrees[e]

        e_without_indegree = [g for g in graph if indegrees[g] == 0]
        ans = []
        count = 0
        while len(e_without_indegree) > 0:
            first = e_without_indegree.pop(0)
            ans.append(first)
            count += 1
            remove(indegrees, first)
            for e in first.neighbors:
                indegrees[e] -= 1
                if indegrees[e] == 0:
                    e_without_indegree.append(e)
        if count != len(graph):
            raise IndexError
        return ans

connects = [
    (1, (2, 3, 4)),
    (2, (4, 5)),
    (3, (6,)),
    (4, (3, 6, 7)),
    (5, (4, 7)),
    (6, set()),
    (7, (6,))
]
l = [DirectedGraphNode(i) for i in range(1, 8)]


for i, ns in connects:
    for n in ns:
        l[i - 1].neighbors.append(l[n - 1])
s = Solution()

ans = s.topSort(l)
print([i.label for i in ans])
