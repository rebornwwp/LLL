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
            while a >= 0 and b < len(s) and s[a] == s[b]:
                total += 1
                a -= 1
                b += 1
            a = i
            b = i + 1
            while a >= 0 and b < len(s) and s[a] == s[b]:
                total += 1
                a -= 1
                b += 1
        return total

    def countSubstrings1(self, s):
        """
        对上面算法的优化
        """
        N = len(s)
        total = 0
        for center in range(2 * N - 1):
            # 回文可能是奇数和偶数的情况直接考虑其中
            left = center // 2
            right = left + center % 2
            while left >= 0 and right < N and s[left] == s[right]:
                total += 1
                left -= 1
                right += 1
        return total

    def countSubstrings2(self, s):
        """
        Manacher algorithm
        """
        return sum([v // 2 for v in self.manacher(s)])

    def manacher(self, s):
        S = '#' + '#'.join(s) + '#'
        id, mx = 0, 0
        l = len(S)
        p = [0] * l
        for i in range(l):
            if i >= mx:
                p[i] = 1
            else:
                p[i] = min(p[2 * id - i], mx - i)

            while i - p[i] >= 0 and i + p[i] < l and S[i - p[i]] == S[i +
                                                                      p[i]]:
                p[i] += 1

                if i + p[i] - 1 > mx:
                    mx = i + p[i] - 1
                    id = i
        return p


if __name__ == "__main__":
    s = Solution()
    print(s.countSubstrings("aaa"))
    print(s.countSubstrings1("aaa"))
    print(s.manacher("aaa"))
    print(s.countSubstrings2("aaa"))
