#!/usr/bin/env python
# encoding: utf-8

def group(seq, size):
    """
        >>> list(group([1,2,3,4], 2))
        [[1, 2], [3, 4]]
        >>> list(group([1,2,3,4,5], 2))
        [[1, 2], [3, 4], [5]]
    """

    def take(seq, n):
        for _ in range(n):
            yield next(seq)

    if not hasattr(seq, 'next'):
        seq = iter(seq)

    while True:
        x = list(take(seq, size))
        if x:
            yield x
        else:
            break


if __name__ == "__main__":
    import doctest
    doctest.testmod()

