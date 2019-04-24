# 无权最短路径


class DirectedGraphNode:
    def __init__(self, x):
        self.label = x
        self.neighbors = []
        self.known = False
        self.dist = None
        self.path = None

    def __str__(self):
        return "(label: {}, dist: {})".format(self.label, self.dist)

    def __repr__(self):
        return str(self)


class Solution:
    """
    @param: graph: A list of Directed graph node
    @return: Any topological order for the given graph.
    """

    def shortest_path(self, graph, start_label):
        """ start_label代表起始点的label值 """
        start_g = [g for g in graph if g.label == start_label]
        if len(start_g) == 1:
            start_g[0].dist = 0
        else:
            print("wrong")
            return

        for curr_dist in range(len(graph)):
            for g in graph:
                if not g.known and g.dist == curr_dist:
                    g.known = True
                    for n in g.neighbors:
                        if n.dist is None:
                            n.dist = curr_dist + 1
                            n.path = g

    def shortest_path1(self, graph, start_label):
        """ bfs """
        start_g = [g for g in graph if g.label == start_label]
        if len(start_g) == 1:
            start_g[0].dist = 0
        else:
            print("wrong")
            return

        while start_g:
            g = start_g.pop(0)
            # 只是一个遍历过的标志没有其他作用
            g.known = True
            for n in g.neighbors:
                if n.dist is None:
                    n.dist = g.dist + 1
                    n.path = g
                    start_g.append(n)


connects = [
    (1, (2, 4)),
    (2, (4, 5)),
    (3, (1, 6)),
    (4, (3, 5, 6, 7)),
    (5, (7, )),
    (6, set()),
    (7, (6,))
]
l = [DirectedGraphNode(i) for i in range(1, 8)]

for i, ns in connects:
    for n in ns:
        l[i - 1].neighbors.append(l[n - 1])

s = Solution()

s.shortest_path(l, 3)
print(sorted([(i.label, i.dist) for i in l], key=lambda x: x[0]))

s.shortest_path1(l, 3)
print(sorted([(i.label, i.dist) for i in l], key=lambda x: x[0]))
