#!/usr/bin/env python
# encoding: utf-8


def uniq(seq, key=None):
    """
        >>> uniq([9,0,2,1,0])
        [9, 0, 2, 1]
        >>> uniq(["Foo", "foo", "bar"], key=lambda s: s.lower())
        ['Foo', 'bar']
    """
    key = key or (lambda x: x)
    result = list()
    containers = set()
    for v in seq:
        if key(v) in containers:
            continue
        containers.add(key(v))
        result.append(v)
    return result


if __name__ == "__main__":
    import doctest
    doctest.testmod()
