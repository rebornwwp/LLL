class Solution(object):
    def detectCapitalUse(self, word):
        """
        :type word: str
        :rtype: bool
        """
        if word.islower():
            return True
        if word.isupper():
            return True
        if word[:1].isupper() and word[1:].islower():
            return True
        return False

    def detectCapitalUse2(self, word):
        """
        :param word: str
        :return: bool
        """
        return word.islower() or word.isupper() or word.istitle()


if __name__ == '__main__':
    word = 'ABF'
    solution = Solution()
    print(solution.detectCapitalUse(word))
