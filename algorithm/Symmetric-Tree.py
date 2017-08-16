# Definition for a binary tree node.
class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution(object):
    def isSymmetric(self, root):
        """
        :type root: TreeNode
        :rtype: bool
        """
        if not root:
            return True
        else:
            return self.compare_left_right(root.left, root.right)

    def compare_left_right(self, leftNode, rightNode):
        if leftNode == None and rightNode == None:
            return True
        if leftNode and rightNode and leftNode.val == rightNode.val:
            return self.compare_left_right(leftNode.left, rightNode.right) & self.compare_left_right(leftNode.right, rightNode.left)
        return False


if __name__ == '__main__':
    root = TreeNode(1)
    root.left = TreeNode(3)
    root.right = TreeNode(3)
    solution = Solution()
    print(solution.isSymmetric(root))
