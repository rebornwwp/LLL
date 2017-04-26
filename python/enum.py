#!/usr/bin/env python
# encoding: utf-8


def enumeratee(collection):
    """
    >>> l=['a','b','c']
    >>> list(enumeratee(l))
    [(0, 'a'), (1, 'b'), (2, 'c')]
    """
    i = 0
    it = iter(collection)
    while True:
        yield (i, next(it))
        i += 1

if __name__ == "__main__":
    s = ['a', 'b', 'c']
    print(list(enumeratee(s)))
