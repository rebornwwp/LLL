class Solution:
    def gardenNoAdj(self, N, paths):
        sets = []
        for g1, g2 in paths:
            for s in sets:
                if g1 not in 