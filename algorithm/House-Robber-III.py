# The thief has found himself a new place for his thievery again. There is only one entrance to this area, called the "root." Besides the root, each house has one and only one parent house. After a tour, the smart thief realized that "all houses in this place forms a binary tree". It will automatically contact the police if two directly-linked houses were broken into on the same night.

# Determine the maximum amount of money the thief can rob tonight without alerting the police.

# Example 1:

# Input: [3,2,3,null,3,null,1]

#      3
#     / \
#    2   3
#     \   \
#      3   1

# Output: 7
# Explanation: Maximum amount of money the thief can rob = 3 + 3 + 1 = 7.
# Example 2:

# Input: [3,4,5,1,3,null,1]

#      3
#     / \
#    4   5
#   / \   \
#  1   3   1

# Output: 9
# Explanation: Maximum amount of money the thief can rob = 4 + 5 = 9.

# Definition for a binary tree node.


class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution(object):
    def rob(self, root):
        """
        :type root: TreeNode
        :rtype: int
        """
        def dfs(root, l):
            if not root.left and not root.right:
                return self.helper()



    def helper(self, nums):
        if len(nums) == 0:
            return 0
        max_robs = [0] * len(nums)
        max_robs[0] = nums[0]
        if len(nums) >= 2:
            max_robs[1] = max(nums[0], nums[1])
        for i in range(2, len(nums)):
            max_robs[i] = max(max_robs[i - 1], max_robs[i - 2] + nums[i])

        return max_robs[-1]

