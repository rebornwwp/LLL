# Implement strStr().

# Return the index of the first occurrence of needle in haystack, or -1 if needle is not part of haystack.

# Example 1:

# Input: haystack = "hello", needle = "ll"
# Output: 2
# Example 2:

# Input: haystack = "aaaaa", needle = "bba"
# Output: -1
# Clarification:

# What should we return when needle is an empty string? This is a great question to ask during an interview.

# For the purpose of this problem, we will return 0 when needle is an empty string. This is consistent to C's strstr() and Java's indexOf().


class Solution(object):
    def strStr(self, haystack, needle):
        """
        :type haystack: str
        :type needle: str
        :rtype: int
        """
        try:
            return haystack.index(needle)
        except:
            return -1

    def strStr1(self, haystack, needle):

        def kmp_get_next(pattern):
            i = 0
            j = -1
            _next = [0] * len(pattern)
            _next[0] = -1
            while i < len(pattern) - 1:
                if j == -1 or pattern[i] == pattern[j]:
                    print(i, j, _next)
                    i += 1
                    j += 1
                    _next[i] = j
                else:
                    j = _next[j]
            return _next

        _next = kmp_get_next(needle)
        str_index = 0
        pattern_index = 0
        pattern_len = len(needle)
        while str_index < len(haystack) and pattern_index < pattern_len:
            if pattern_index == -1 or haystack[str_index] == needle[pattern_index]:
                str_index += 1
                pattern_index += 1
            else:
                pattern_index = _next[pattern_index]
        if pattern_index == pattern_len:
            return str_index - pattern_index
        return -1


haystack = "hello"
needle = "ll"
s = Solution()
print(s.strStr1(haystack, needle))
