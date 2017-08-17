# Definition for a binary tree node.
class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution(object):
    def levelOrderBottom(self, root):
        """
        :type root: TreeNode
        :rtype: List[List[int]]
        """
        if root == None:
            return []
        stack = [root]
        result = []
        while len(stack) > 0:
            insert_list = [i.val for i in stack]
            result.insert(0, insert_list)
            temp = []
            for i in stack:
                if i.left is not None:
                    temp.append(i.left)
                if i.right is not None:
                    temp.append(i.right)
            stack = temp
        return result


if __name__ == '__main__':
    root = TreeNode(0)
    root.left = TreeNode(1)
    root.right = TreeNode(2)
    solution = Solution()
    print(solution.levelOrderBottom(root))
