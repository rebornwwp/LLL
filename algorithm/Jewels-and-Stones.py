# You're given strings J representing the types of stones that are jewels, and S representing the stones you have.  Each character in S is a type of stone you have.  You want to know how many of the stones you have are also jewels.
#
# The letters in J are guaranteed distinct, and all characters in J and S are letters. Letters are case sensitive, so "a" is considered a different type of stone from "A".
#
# Example 1:
#
# Input: J = "aA", S = "aAAbbbb"
# Output: 3
# Example 2:
#
# Input: J = "z", S = "ZZ"
# Output: 0
# Note:
#
# S and J will consist of letters and have length at most 50.
# The characters in J are distinct.
class Solution:
    def numJewelsInStones(self, J, S):
        """
        :type J: str
        :type S: str
        :rtype: int
        """
        counter = {}
        for c in J:
            counter[c] = 0

        total = 0
        for c in S:
            if c in counter:
                total += 1
        return total

    def numJewelsInStones1(self, J, S):
        s = S
        for c in J:
            s = s.replace(c, '')
        return len(S) - len(s)


if __name__ == "__main__":
    s = Solution()
    print(s.numJewelsInStones("aA", "aAAbbbb"))
    print(s.numJewelsInStones1("aA", "aAAbbbb"))
