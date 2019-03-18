# Description
# Print numbers from 1 to the largest number with N digits by recursion.

# It's pretty easy to do recursion like:

# recursion(i) {
#     if i > largest number:
#         return
#     results.add(i)
#     recursion(i + 1)
# }
# however this cost a lot of recursion memory as the recursion depth maybe very large. Can you do it in another way to recursive with at most N depth?
# Example
# Example 1:

# Input : N = 1
# Output :[1,2,3,4,5,6,7,8,9]
# Example 2:

# Input : N = 2
# Output :[[1,2,3,4,5,6,7,8,9,10,11,12,...,99]
# Challenge
# Do it in recursion, not for-loop.


class Solution:
    """
    @param n: An integer
    @return: An array storing 1 to the largest number with n digits.
    """

    def numbersByRecursion(self, n):

        def tailRecursion(n, ans):
            for i in range(1, 10 ** n):
                ans.append(i)

        ans = []
        tailRecursion(n, ans)
        return ans

    def numbersByRecursion1(self, n):

        def helper(n, temp, ans):
            if n == 0:
                if temp > 0:
                    ans.append(temp)
                return
            for i in range(0, 10):
                helper(n - 1, temp * 10 + i, ans)

        ans = []
        helper(n, 0, ans)
        return ans


s = Solution()
l = s.numbersByRecursion1(2)
print(l)
