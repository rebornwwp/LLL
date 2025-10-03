# Given a pattern and a string str, find if str follows the same pattern.

# Here follow means a full match, such that there is a bijection between a letter in pattern and a non-empty word in str.

# Example 1:

# Input: pattern = "abba", str = "dog cat cat dog"
# Output: true
# Example 2:

# Input:pattern = "abba", str = "dog cat cat fish"
# Output: false
# Example 3:

# Input: pattern = "aaaa", str = "dog cat cat dog"
# Output: false
# Example 4:

# Input: pattern = "abba", str = "dog dog dog dog"
# Output: false
# Notes:
# You may assume pattern contains only lowercase letters, and str contains lowercase letters separated by a single space.


class Solution(object):
    def wordPattern(self, pattern, strs):
        """
        :type pattern: str
        :type str: str
        :rtype: bool
        """
        def parse_string(pattern):
            d = {}
            count = 0
            digits_pattern = ''
            for p in pattern:
                if p in d:
                    digits_pattern += d[p]
                else:
                    digits_pattern += str(count)
                    d[p] = str(count)
                    count += 1
            return digits_pattern

        return parse_string(pattern) == parse_string(strs.split())

    def wordPattern1(self, pattern, str):
        """
        :type pattern: str
        :type str: str
        :rtype: bool
        """
        strsplit = str.split(' ')

        ss = [strsplit.index(i) for i in strsplit]
        pp = [pattern.index(i) for i in pattern]

        return ss == pp


s = Solution()
print(s.wordPattern('abba', 'dog dog dog dog'))
print(s.wordPattern('abba', 'dog Tog Tog dog'))
print(s.wordPattern('abba', 'abba'))
