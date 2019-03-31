#
# @lc app=leetcode id=318 lang=python
#
# [318] Maximum Product of Word Lengths
#
# https://leetcode.com/problems/maximum-product-of-word-lengths/description/
#
# algorithms
# Medium (48.00%)
# Total Accepted:    76.6K
# Total Submissions: 159.6K
# Testcase Example:  '["abcw","baz","foo","bar","xtfn","abcdef"]'
#
# Given a string array words, find the maximum value of length(word[i]) *
# length(word[j]) where the two words do not share common letters. You may
# assume that each word will contain only lower case letters. If no such two
# words exist, return 0.
#
# Example 1:
#
#
# Input: ["abcw","baz","foo","bar","xtfn","abcdef"]
# Output: 16
# Explanation: The two words can be "abcw", "xtfn".
#
# Example 2:
#
#
# Input: ["a","ab","abc","d","cd","bcd","abcd"]
# Output: 4
# Explanation: The two words can be "ab", "cd".
#
# Example 3:
#
#
# Input: ["a","aa","aaa","aaaa"]
# Output: 0
# Explanation: No such pair of words.
#
#


class Solution(object):
    def maxProduct(self, words):
        """
        :type words: List[str]
        :rtype: int
        """
        bits = [0] * len(words)
        for i, word in enumerate(words):
            temp = 0
            for s in word:
                temp |= 1 << (ord(s) - ord('a') + 1)
            bits[i] = temp

        ans = 0
        for i, bit1 in enumerate(bits):
            for j, bit2 in enumerate(bits):
                if bit1 & bit2 == 0:
                    ans = max(ans, len(words[i]) * len(words[j]))
        return ans
