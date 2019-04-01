#
# @lc app=leetcode id=187 lang=python
#
# [187] Repeated DNA Sequences
#
# https://leetcode.com/problems/repeated-dna-sequences/description/
#
# algorithms
# Medium (35.55%)
# Total Accepted:    120.5K
# Total Submissions: 338.8K
# Testcase Example:  '"AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT"'
#
# All DNA is composed of a series of nucleotides abbreviated as A, C, G, and T,
# for example: "ACGAATTCCG". When studying DNA, it is sometimes useful to
# identify repeated sequences within the DNA.
#
# Write a function to find all the 10-letter-long sequences (substrings) that
# occur more than once in a DNA molecule.
#
# Example:
#
#
# Input: s = "AAAAACCCCCAAAAACCCCCCAAAAAGGGTTT"
#
# Output: ["AAAAACCCCC", "CCCCCAAAAA"]
#
#
#


class Solution(object):
    def findRepeatedDnaSequences(self, s):
        """
        :type s: str
        :rtype: List[str]
        """
        mask = 0xfffff
        val = set()
        repeat_val = set()
        encode = {
            'A': 0,
            'C': 1,
            'G': 2,
            'T': 3
        }

        temp = 0
        for i in range(len(s)):
            temp = ((temp << 2) | encode[s[i]]) & mask
            if i < 9:
                continue
            else:
                if temp in val:
                    repeat_val.add(s[i-9: i+1])
                else:
                    val.add(temp)
        return list(repeat_val)

    def findRepeatedDnaSequences1(self, s):
        d = {}
        ans = []
        for i in range(len(s)):
            if len(s[i:i+10]) == 10:
                d[s[i:i+10]] = d.get(s[i:i+10], 0) + 1
        for i in d:
            if d[i] > 1:
                ans.append(i)
        return ans
