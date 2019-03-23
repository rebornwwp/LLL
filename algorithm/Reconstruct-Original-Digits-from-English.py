# Given a non-empty string containing an out-of-order English representation of digits 0-9, output the digits in ascending order.

# Note:
# Input contains only lowercase English letters.
# Input is guaranteed to be valid and can be transformed to its original digits. That means invalid inputs such as "abc" or "zerone" are not permitted.
# Input length is less than 50,000.
# Example 1:
# Input: "owoztneoer"

# Output: "012"
# Example 2:
# Input: "fviefuro"

# Output: "45"


class Solution(object):
    def originalDigits(self, s):
        """
        :type s: str
        :rtype: str
        """
        import collections
        g, ans = collections.Counter(s), []
        for x, y, z in zip('zwxgsvinft', 'zero two six eight seven five nine one four three'.split(), '0 2 6 8 7 5 9 1 4 3'.split()):
            while g[x] > 0:
                ans.append(z)
                for k in y:
                    g[k] -= 1
        return ''.join(sorted(ans))


n = "asd"
s = Solution()
print(s.originalDigits(n))
