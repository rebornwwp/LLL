# Given n pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

# For example, given n = 3, a solution set is:

# [
#   "((()))",
#   "(()())",
#   "(())()",
#   "()(())",
#   "()()()"
# ]


class Solution(object):
    def generateParenthesis(self, n):
        """
        :type n: int
        :rtype: List[str]
        """
        if n == 0:
            return ['']

        def dfs(left, right, temp, ans):
            if left == 0 and right == 0:
                ans.append(temp[:])
            if left > 0:
                dfs(left - 1, right, temp + ['('], ans)

            if right > left:
                dfs(left, right - 1, temp + [')'], ans)

        ans = []
        dfs(n, n, [], ans)
        return [''.join(x) for x in ans]

s = Solution()
print(s.generateParenthesis(3))
