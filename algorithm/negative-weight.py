# 有权最短路径

# Python program for Dijkstra's single
# source shortest path algorithm. The program is
# for adjacency matrix representation of the graph

# Library for INT_MAX
import sys


class Graph():

    def __init__(self, vertices):
        self.V = vertices
        self.graph = [[0 for column in range(vertices)]
                      for row in range(vertices)]

    def printSolution(self, dist):
        print(dist)
        print("Vertex tDistance from Source")
        for node in range(self.V):
            print(node, "t", dist[node])

    # A utility function to find the vertex with
    # minimum distance value, from the set of vertices
    # not yet included in shortest path tree
    def minDistance(self, dist, sptSet):

        # Initilaize minimum distance for next node
        min = sys.maxsize

        # Search not nearest vertex not in the
        # shortest path tree
        for v in range(self.V):
            if dist[v] < min and not sptSet[v]:
                min = dist[v]
                min_index = v

        return min_index

    def negative_weight(self, src):

        dist = [sys.maxsize] * self.V
        dist[src] = 0
        Q = []
        Q.append(src)

        while Q:
            print(dist)
            v = Q.pop(0)

            for w in range(self.V):
                if self.graph[v][w] != 0 and dist[w] > dist[v] + self.graph[v][w]:
                    dist[w] = dist[v] + self.graph[v][w]
                    if w not in Q:
                        Q.append(w)

        self.printSolution(dist)


# Driver program
g = Graph(5)
g.graph = [
    [0, -1, 4, 0, 0],
    [0, 0, 3, 2, 2],
    [0, 0, 0, 0, 0],
    [0, 1, 5, 0, 0],
    [0, 0, 0, -3, 0]
]

# 例子中3 -> 1换成-1将会存在问题，程序无限循环下去

g.negative_weight(0)
