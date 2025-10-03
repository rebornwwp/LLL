# Given a string, find the length of the longest substring without repeating characters.

# Example 1:

# Input: "abcabcbb"
# Output: 3
# Explanation: The answer is "abc", with the length of 3.
# Example 2:

# Input: "bbbbb"
# Output: 1
# Explanation: The answer is "b", with the length of 1.
# Example 3:

# Input: "pwwkew"
# Output: 3
# Explanation: The answer is "wke", with the length of 3.
#              Note that the answer must be a substring, "pwke" is a subsequence and not a substring.


class Solution(object):
    def lengthOfLongestSubstring(self, s):
        """
        :type s: str
        :rtype: int
        """
        start = maxLength = 0
        usedChar = {}

        for i in range(len(s)):
            if s[i] in usedChar and start <= usedChar[s[i]]:
                start = usedChar[s[i]] + 1
            else:
                maxLength = max(maxLength, i - start + 1)
            usedChar[s[i]] = i
        return maxLength

    def lengthOfLongestSubstring1(self, s):
        start = maxLength = 0
        d = {}
        for i in range(len(s)):
            if s[i] in d and start <= d[s[i]]:
                start = d[s[i]] + 1
            else:
                maxLength = max(maxLength, i - start + 1)
            d[s[i]] = i

        return maxLength

    def lengthOfLongestSubstring2(self, s):

        if len(s) <= 1:
            return len(s)
        max_s = 1
        l = [False] * 256

        j = 0
        i = 0
        while i < len(s):
            while j < len(s):
                ord_j = ord(s[j])
                if not l[ord_j]:
                    l[ord_j] = True
                    j += 1
                else:
                    break
            max_s = max(max_s, j - i)
            l[ord(s[i])] = False
            i += 1
        return max_s


def main():
    solution = Solution()
    s = "aab"
    print(solution.lengthOfLongestSubstring2(s))


if __name__ == '__main__':
    main()
