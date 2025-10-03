# 树的子结构
# 题目描述
# 输入两棵二叉树A，B，判断B是不是A的子结构。（ps：我们约定空树不是任意一个树的子结构）


class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None


class Solution:
    def HasSubtree(self, pRoot1, pRoot2):
        if not pRoot2:
            return False
        l = [pRoot1]
        while len(l) > 0:
            a = l.pop()
            if self.equal(a, pRoot2):
                return True
            if a:
                l.append(a.left)
                l.append(a.right)
        return False

    def equal(self, root1, root2):
        if root1 and root2:
            return root1.val == root2.val and self.equal(root1.left, root2.left) and self.equal(root1.right, root2.right)
        elif not root1 and root2:
            return False
        elif root1 and not root2:
            return True
        else:
            return True


if __name__ == "__main__":
    node = TreeNode(1)
    node.left = TreeNode(2)
    node.right = TreeNode(3)
    node1 = TreeNode(2)
    s = Solution()
    print(s.HasSubtree(node, node1))
    print(s.equal(node, node))
