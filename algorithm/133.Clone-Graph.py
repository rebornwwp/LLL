"""
# Definition for a Node.
class Node(object):
    def __init__(self, val, neighbors):
        self.val = val
        self.neighbors = neighbors
"""


class Solution(object):
    def cloneGraph(self, node):
        """
        :type node: Node
        :rtype: Node
        """

        def dfs(node, dic):
            if node in dic:
                return dic[node]

            node_copy = Node(node.val, [])
            dic[node] = node_copy
            for n in node.neighbors:
                node_copy.neighbors.append(dfs(n, dic))

            return node_copy

        if not node:
            return None

        return dfs(node, {})
