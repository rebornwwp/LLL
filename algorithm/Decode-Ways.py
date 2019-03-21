# A message containing letters from A-Z is being encoded to numbers using the following mapping:

# 'A' -> 1
# 'B' -> 2
# ...
# 'Z' -> 26
# Given a non-empty string containing only digits, determine the total number of ways to decode it.

# Example 1:

# Input: "12"
# Output: 2
# Explanation: It could be decoded as "AB" (1 2) or "L" (12).
# Example 2:

# Input: "226"
# Output: 3
# Explanation: It could be decoded as "BZ" (2 26), "VF" (22 6), or "BBF" (2 2 6).


class Solution(object):
    def numDecodings(self, s):
        """
        :type s: str
        :rtype: int
        """
        # TIME LIMIT EXCEEDED
        def dfs(s):
            de = set(str(i) for i in range(1, 27))
            if len(s) == 0:
                return 1
            elif s[0] == '0':
                return 0

            count = 0
            min_range = min(2, len(s))
            for i in range(0, min_range):
                if s[:i + 1] in de:
                    count += dfs(s[i + 1:])
            return count

        return dfs(s)


s = Solution()

print(s.numDecodings('12'))
