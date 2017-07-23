class Solution(object):
    def countAndSay(self, n):
        """
        :type n: int
        :rtype: str
        """
        if n == 1:
            return '1'
        else:
            upper_result_string = self.countAndSay(n-1)
            count = 0
            count_word = ''
            result = ''
            for i in upper_result_string:
                if count_word == '':
                    count_word = i
                    count = 1
                    continue
                if count_word != i:
                    result += str(count) + count_word
                    count_word = i
                    count = 1
                elif count_word == i:
                    count += 1
            if count > 0:
                result += str(count) + count_word
            return result


if __name__ == '__main__':
    solution = Solution()
    print(solution.countAndSay(4))
