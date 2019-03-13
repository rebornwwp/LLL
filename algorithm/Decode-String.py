# Given an encoded string, return it's decoded string.

# The encoding rule is: k[encoded_string], where the encoded_string inside the square brackets is being repeated exactly k times. Note that k is guaranteed to be a positive integer.

# You may assume that the input string is always valid; No extra white spaces, square brackets are well-formed, etc.

# Furthermore, you may assume that the original data does not contain any digits and that digits are only for those repeat numbers, k. For example, there won't be input like 3a or 2[4].

# Examples:

# s = "3[a]2[bc]", return "aaabcbc".
# s = "3[a2[c]]", return "accaccacc".
# s = "2[abc]3[cd]ef", return "abcabccdcdcdef".


class Solution:
    def decodeString(self, s: str) -> str:
        stack = []
        res = ''
        num = 0
        for c in s:
            if c.isdigit():
                num = num * 10 + int(c)
            elif c == '[':
                stack.append(res)
                stack.append(num)
                res = ''
                num = 0
            elif c == ']':
                pre_num = stack.pop()
                pre_res = stack.pop()
                res = pre_res + pre_num * res
            else:
                res += c
        return res


s = Solution()
print(s.decodeString("3[a]2[bc]"))
print(s.decodeString('2[abc]3[cd]ef'))
