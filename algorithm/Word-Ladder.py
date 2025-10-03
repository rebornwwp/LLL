# Given two words (beginWord and endWord), and a dictionary's word list, find the length of shortest transformation sequence from beginWord to endWord, such that:

# Only one letter can be changed at a time.
# Each transformed word must exist in the word list. Note that beginWord is not a transformed word.
# Note:

# Return 0 if there is no such transformation sequence.
# All words have the same length.
# All words contain only lowercase alphabetic characters.
# You may assume no duplicates in the word list.
# You may assume beginWord and endWord are non-empty and are not the same.
# Example 1:

# Input:
# beginWord = "hit",
# endWord = "cog",
# wordList = ["hot","dot","dog","lot","log","cog"]

# Output: 5

# Explanation: As one shortest transformation is "hit" -> "hot" -> "dot" -> "dog" -> "cog",
# return its length 5.
# Example 2:

# Input:
# beginWord = "hit"
# endWord = "cog"
# wordList = ["hot","dot","dog","lot","log"]

# Output: 0

# Explanation: The endWord "cog" is not in wordList, therefore no possible transformation.


class Solution(object):
    def ladderLength(self, beginWord, endWord, wordList):
        """
        :type beginWord: str
        :type endWord: str
        :type wordList: List[str]
        :rtype: int
        """
        d = set(wordList)
        if endWord not in d:
            return 0

        ascii_lowercase = 'abcdefghijklmnopqrstuvwxyz'

        queue = []
        queue.append(beginWord)

        length = len(beginWord)
        step = 1
        while len(queue) > 0:
            step += 1

            l = len(queue)
            for _ in range(l):
                first_ele = queue.pop(0)
                for i in range(length):
                    for x in ascii_lowercase:
                        new_elem = first_ele[:i] + x + first_ele[i + 1:]
                        if new_elem == endWord:
                            return step
                        elif new_elem not in d:
                            continue
                        # 这里用过就可以删除了, 看下面注释
                        d.remove(new_elem)
                        queue.append(new_elem)
        return 0

# 注意的一点，只要我们遍历过的就可以删除了，不用再变了。
# 如果不删除遍历，比如 beginWord = "hit"
# endWord = "cog"
# wordList = ["hot","hxt", "dot", "dog", "lot", "log", "cog"]
# bfs的遍历情况可以是这样的
# hit -> hot -> hxt ->...
# hit -> hot -> ...
# hit -> hxt ->...
# hit -> hxt -> hot
# 这样重复的遍历是没有必要，本题求的是最短路径,上面重复了
# 如果删除之后遍历将会是
# hit -> hot ->
# hit -> hxt ->


s = Solution()
beginWord = "hit"
endWord = "cog"
wordList = ["hot", "dot", "dog", "lot", "log", "cog"]
print(s.ladderLength(beginWord, endWord, wordList))
