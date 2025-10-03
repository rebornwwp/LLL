# 栈的压入和弹出序列
# 题目描述
# 输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二
# 个序列是否可能为该栈的弹出顺序。假设压入栈的所有数字均不
# 相等。例如序列1,2,3,4,5是某栈的压入顺序，序列4,5,3,2,
# 1是该压栈序列对应的一个弹出序列，但4,3,5,1,2就不可能是
# 该压栈序列的弹出序列。（注意：这两个序列的长度是相等的）


class Solution:
    def IsPopOrder(self, pushV, popV):
        l = []
        while len(pushV) > 0:
            first = pushV[0]
            pushV = pushV[1:]
            l.append(first)
            while len(l) > 0 and len(popV) > 0 and l[-1] == popV[0]:
                l.pop()
                popV = popV[1:]

        return len(l) == 0


if __name__ == "__main__":
    a = [1, 2, 3, 4, 5]
    b = [4, 5, 3, 2, 1]
    c = [4, 3, 5, 1, 2]
    s = Solution()
    print(s.IsPopOrder(a, c))
