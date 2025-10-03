class Solution:
    def addToArrayForm(self, A: List[int], k: int) -> List[int]:

        A[-1] += k

        for i in range(len(A) - 1, -1, -1):
            curry, A[i] = divmod(A[i], 10)
            if i > 0:
                A[i - 1] += curry

        if curry > 0:
            A = [int(i) for i in str(curry)] + A

        return A
