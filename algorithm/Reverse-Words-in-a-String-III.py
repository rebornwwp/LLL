class Solution(object):
    def reverseWords(self, s):
        """
        :type s: str
        :rtype: str
        """
        s_items = s.split()
        s_reversed_items = [s_item[::-1] for s_item in s_items]
        return ' '.join(s_reversed_items)

    def reverseWords2(self, s):
        """
        :param s: str
        :return: str
        """
        return " ".join(s.split()[::-1])[::-1]


if __name__ == '__main__':
    solution = Solution()
    s = "Let's take LeetCode contest"
    print(solution.reverseWords(s))
