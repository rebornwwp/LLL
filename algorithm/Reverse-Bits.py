class Solution:
    # @param n, an integer
    # @return an integer
    def reverseBits(self, n):
        b = bin(n)
        return int(b + '0' * (32 - len(b)), 2)
