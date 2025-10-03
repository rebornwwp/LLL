# encoding=utf8
#
# @lc app=leetcode id=241 lang=golang
#
# [241] Different Ways to Add Parentheses
#
# https://leetcode.com/problems/different-ways-to-add-parentheses/description/
#
# algorithms
# Medium (49.22%)
# Total Accepted:    70.4K
# Total Submissions: 142.9K
# Testcase Example:  '"2-1-1"'
#
# Given a string of numbers and operators, return all possible results from
# computing all the different possible ways to group numbers and operators.
# The valid operators are +, - and *.
#
# Example 1:
#
#
# Input: "2-1-1"
# Output: [0, 2]
# Explanation:
# ((2-1)-1) = 0
# (2-(1-1)) = 2
#
# Example 2:
#
#
# Input: "2*3-4*5"
# Output: [-34, -14, -10, -10, 10]
# Explanation:
# (2*(3-(4*5))) = -34
# ((2*3)-(4*5)) = -14
# ((2*(3-4))*5) = -10
# (2*((3-4)*5)) = -10
# (((2*3)-4)*5) = 10
#
#


class Solution:
    def diffWaysToCompute(self, input):
        ans = []
        for i, val in enumerate(input):
            if val in '-+*':
                # 符号左边可能的所有值
                left = self.diffWaysToCompute(input[0:i])
                # 符号右边可能的所有值
                right = self.diffWaysToCompute(input[i+1:])
                for num1 in left:
                    for num2 in right:
                        if val == '-':
                            ans.append(num1 - num2)
                        if val == '+':
                            ans.append(num1 + num2)
                        if val == '*':
                            ans.append(num1 * num2)
        if len(ans) == 0:
            ans.append(int(input))
        return ans

s = Solution()
print(s.diffWaysToCompute("2-1-1"))