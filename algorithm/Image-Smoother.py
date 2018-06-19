#!/usr/bin/env python
# -*- coding:utf-8 -*-


class Solution:
    def imageSmoother(self, M):
        """
        :type M: List[List[int]]
        :rtype: List[List[int]]
        """
        w, h = len(M[0]), len(M)
        m = [[0] * w for _ in range(h)]

        for i in range(h):
            for j in range(w):
                count = 0
                for jc in (j-1, j, j+1):
                    for ic in (i-1, i, i+1):
                        if 0 <= jc < w and 0 <= ic < h:
                            m[i][j] += M[ic][jc]
                            count += 1
                m[i][j] = m[i][j] // count
        return m


def main():
    solution = Solution()
    m = [[1, 1, 1],
         [1, 0, 1],
         [1, 1, 1]]
    print(solution.imageSmoother(m))


if __name__ == '__main__':
    main()
