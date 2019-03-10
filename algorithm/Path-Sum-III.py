# You are given a binary tree in which each node contains an integer value.

# Find the number of paths that sum to a given value.

# The path does not need to start or end at the root or a leaf, but it must go downwards (traveling only from parent nodes to child nodes).

# The tree has no more than 1,000 nodes and the values are in the range -1,000,000 to 1,000,000.

# Example:

# root = [10,5,-3,3,2,null,11,3,-2,null,1], sum = 8

#       10
#      /  \
#     5   -3
#    / \    \
#   3   2   11
#  / \   \
# 3  -2   1

# Return 3. The paths that sum to 8 are:

# 1.  5 -> 3
# 2.  5 -> 2 -> 1
# 3. -3 -> 11

# Definition for a binary tree node.


class TreeNode(object):
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution(object):
    def pathSum(self, root, sum):
        """
        :type root: TreeNode
        :type sum: int
        :rtype: int
        """
        if not root:
            return 0
        ans = self.helper(root, sum)
        ans += self.pathSum(root.left, sum)
        ans += self.pathSum(root.right, sum)
        return ans

    def helper(self, root, sum):
        if not root:
            return 0
        ans = 1 if root.val == sum else 0
        ans += self.helper(root.left, sum - root.val)
        ans += self.helper(root.right, sum - root.val)
        return ans

    def pathSum1(self, root, sum):
        d = {0: 1}

        def dfs(root, cuSum, sum):
            if not root:
                return 0
            count = 0
            cuSum += root.val
            diff = cuSum - sum
            count += d.get(diff, 0)
            d[cuSum] = d.get(cuSum, 0) + 1

            count += dfs(root.left, cuSum, sum)
            count += dfs(root.right, cuSum, sum)
            # 将之前加入到d中的数字再删除，不影响其他相同层次的递归函数
            d[cuSum] -= 1
            return count

        return dfs(root, 0, sum)
