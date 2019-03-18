# Given a binary tree, return all root-to-leaf paths.
# Note: A leaf is a node with no children.
# Example:
# Input:
#    1
#  /   \
# 2     3
#  \
#   5
# Output: ["1->2->5", "1->3"]
# Explanation: All root-to-leaf paths are: 1->2->5, 1->3


# Definition for a binary tree node.
class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution(object):
    def binaryTreePaths(self, root):
        """
        :type root: TreeNode
        :rtype: List[str]
        """
        if not root:
            return []

        def dfs(node, cur, ans):
            if not node.left and not node.right:
                ans.append(cur + [node.val])
                return
            elif not node.left and node.right:
                dfs(node.right, cur + [node.val], ans)
            elif node.left and not node.right:
                dfs(node.left, cur + [node.val], ans)
            else:
                dfs(node.left, cur + [node.val], ans)
                dfs(node.right, cur + [node.val], ans)

        ans = []
        dfs(root, [], ans)
        return ['->'.join(map(str, l)) for l in ans]

    def binaryTreePaths1(self, root):
        """
        :type root: TreeNode
        :rtype: List[str]
        """
        if not root:
            return []

        def dfs(node, cur, ans):
            if not node.left and not node.right:
                ans.append(cur + [node.val])
                return
            elif not node.left and node.right:
                cur.append(node.val)
                dfs(node.right, cur, ans)
                cur.pop()
            elif node.left and not node.right:
                cur.append(node.val)
                dfs(node.left, cur, ans)
                cur.pop()
            else:
                cur.append(node.val)
                dfs(node.left, cur, ans)
                dfs(node.right, cur, ans)
                cur.pop()

        ans = []
        dfs(root, [], ans)
        return ['->'.join(map(str, l)) for l in ans]

    def binaryTreePaths2(self, root):
        """
        :type root: TreeNode
        :rtype: List[str]
        """
        if not root:
            return []

        def dfs(node, cur, ans):
            if not node:
                return

            cur.append(node.val)
            if not node.left and not node.right:
                ans.append(cur[:])

            dfs(node.left, cur, ans)
            dfs(node.right, cur, ans)

            cur.pop()

        ans = []
        dfs(root, [], ans)
        return ['->'.join(map(str, l)) for l in ans]
