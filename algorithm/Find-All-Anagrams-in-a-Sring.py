# Given a string s and a non-empty string p, find all the start indices of p's anagrams in s.

# Strings consists of lowercase English letters only and the length of both strings s and p will not be larger than 20,100.

# The order of output does not matter.

# Example 1:

# Input:
# s: "cbaebabacd" p: "abc"

# Output:
# [0, 6]

# Explanation:
# The substring with start index = 0 is "cba", which is an anagram of "abc".
# The substring with start index = 6 is "bac", which is an anagram of "abc".
# Example 2:

# Input:
# s: "abab" p: "ab"

# Output:
# [0, 1, 2]

# Explanation:
# The substring with start index = 0 is "ab", which is an anagram of "ab".
# The substring with start index = 1 is "ba", which is an anagram of "ab".
# The substring with start index = 2 is "ab", which is an anagram of "ab".


class Solution:
    def findAnagrams(self, s, p):
        sort_p = sorted(p)
        length = len(p)

        result = []
        for i in range(len(s)):
            if sorted(s[i:i + length]) == sort_p:
                print(sorted(s[i:i + length]))
                result.append(i)
        return result

    def findAnagrams1(self, s, p):
        from collections import Counter
        count = Counter(p)
        length = len(p)
        a = 0
        result = []
        for i in range(len(s)):
            if s[i] in count and Counter(s[i:i + length]) == count:
                result.append(i)
        return result

    def findAnagrams2(self, s, p):
        length_p = len(p)

        vp = [0] * 26
        sp = [0] * 26
        for i in p:
            vp[ord(i) - ord('a')] += 1

        ans = []
        for i in range(len(s)):
            if i >= length_p:
                sp[ord(s[i - length_p]) - ord('a')] -= 1
            sp[ord(s[i]) - ord('a')] += 1
            if sp == vp:
                ans.append(i - length_p + 1)

        return ans


if __name__ == "__main__":
    s = "cbaebabacd"
    p = "abc"
    a = Solution()
    print(a.findAnagrams2(s, p))
