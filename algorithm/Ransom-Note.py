class Solution(object):
    def canConstruct(self, ransomNote, magazine):
        """
        :type ransomNote: str
        :type magazine: str
        :rtype: bool
        """
        from collections import defaultdict
        ransomNoteDict = defaultdict(int)
        magazineDict = defaultdict(int)
        for s in ransomNote:
            ransomNoteDict[s] += 1
        for s in magazine:
            magazineDict[s] += 1
        ransomNoteSet = set(ransomNote)
        for s in ransomNoteSet:
            if ransomNoteDict[s] > magazineDict[s]:
                return False
        return True


if __name__ == '__main__':
    a = 'aab'
    b = 'aabbb'
    solution = Solution()
    print(solution.canConstruct(a, b))
