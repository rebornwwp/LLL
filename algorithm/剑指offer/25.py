# 二叉搜索树的后序遍历序列
# 题目描述
# 输入一个整数数组，判断该数组是不是某二叉
# 搜索树的后序遍历的结果。如果是则输出True,
# 否则输出False。假设输入的数组的任意两个数字
# 都互不相同。


class Solution:
    def VerifySquenceOfBST(self, sequence):
        if len(sequence) == 0:
            return False
        return self.helper(0, len(sequence) - 1, sequence)

    def helper(self, start, end, sequence):
        if start >= end:
            return True

        i = start
        while i < end and sequence[i] < sequence[end]:
            i += 1

        for index in range(i):
            if sequence[index] > sequence[end]:
                return False

        for index in range(i, end):
            if sequence[index] < sequence[end]:
                return False

        return self.helper(start, i - 1, sequence) and self.helper(i, end - 1, sequence)


if __name__ == "__main__":
    s = Solution()
    print(s.VerifySquenceOfBST([1, 2, 3, 4, 5, 6]))
    print(s.VerifySquenceOfBST([1, 2, 3, 10, 11, 12, 6]))
