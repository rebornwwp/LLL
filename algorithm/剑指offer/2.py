# 替换空格
# 题目描述
# 请实现一个函数，将一个字符串中的每个
# 空格替换成“%20”。例如，当字符串为
# We Are Happy.则经过替换之后的字
# 符串为We%20Are%20Happy。


class Solution:
    def replaceSpace(self, s):
        result = ''
        for i in s:
            if i == ' ':
                result += '%20'
            else:
                result += i
        return result


if __name__ == "__main__":
    s = Solution()
    print(s.replaceSpace("We are happy"))
    print(s.replaceSpace("We  are happy"))
    print(s.replaceSpace("We  are  happy"))
