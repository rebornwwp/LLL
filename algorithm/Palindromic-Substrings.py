# Given a string, your task is to count how many palindromic substrings in this string.
#
# The substrings with different start indexes or end indexes are counted as different substrings even they consist of same characters.
#
# Example 1:
# Input: "abc"
# Output: 3
# Explanation: Three palindromic strings: "a", "b", "c".
# Example 2:
# Input: "aaa"
# Output: 6
# Explanation: Six palindromic strings: "a", "a", "a", "aa", "aa", "aaa".
# Note:
# The input string length won't exceed 1000.


class Solution:
    def countSubstrings(self, s):
        """
        :type s: str
        :rtype: int
        """

        total = 0
        for i in range(len(s)):
            a = i
            b = i
            while a >= 0 and b < len(s):
                isPalindromic = self.helper(s, a, b)
                if not isPalindromic:
                    break
                total += isPalindromic
                a -= 1
                b += 1
            a = i
            b = i + 1
            while a >= 0 and b < len(s):
                isPalindromic = self.helper(s, a, b)
                if not isPalindromic:
                    break
                total += isPalindromic
                a -= 1
                b += 1
        return total

    def helper(self, s, i, j):
        while i <= j:
            if s[i] != s[j]:
                return 0
            i += 1
            j -= 1
        return 1


if __name__ == "__main__":
    s = Solution()
    print(s.helper("aaa", 0, 0))
    print(s.helper("aaa", 0, 1))
    print(s.helper("aaa", 0, 2))
    print(s.countSubstrings("aaa"))
