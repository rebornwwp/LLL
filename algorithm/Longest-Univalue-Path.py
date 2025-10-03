class Solution(object):
    def longestUnivaluePath(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        self.ans = 0

        def length_arrow(node):
            if not node:
                return 0
            left_length = length_arrow(node.left)
            right_length = length_arrow(node.right)
            left_arrow, right_arrow = 0, 0
            if node.left and node.left.val == node.val:
                left_arrow = left_length + 1
            if node.right and node.right.val == node.val:
                right_arrow = right_length + 1
            self.ans = max(self.ans, left_arrow + right_arrow)
            return max(left_arrow, right_arrow)
        length_arrow(root)
        return self.ans