class Solution:
    def rearrangeBarcodes(self, barcodes: List[int]) -> List[int]:
        from collections import Counter
        counter = Counter(barcodes)
        ans = [0 for _ in range(len(barcodes))]
        sortCount = sorted(counter, key=counter.get, reverse=True)
        j = 0
        for i in range(0, len(barcodes), 2):
            if counter[sortCount[j]] == 0:
                j += 1
            ans[i] = sortCount[j]
            counter[sortCount[j]] -= 1
        for i in range(1, len(barcodes), 2):
            if counter[sortCount[j]] == 0:
                j += 1
            ans[i] = sortCount[j]
            counter[sortCount[j]] -= 1
        return ans
