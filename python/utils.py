#!/usr/bin/env python
# encoding: utf-8

def restack(stack, index=0):
    """
    return the element at index after moving it to the top of the stack.

           >>> x = [1, 2, 3, 4]
           >>> restack(x)
           1
           >>> x
           [2, 3, 4, 1]
    """
    x = stack.pop(index)
    stack.append(x)
    return x

def listget(lst, ind, default=None):
    """
    return 'lst[ind]' if exits, 'default' otherwise.
           >>> listget([1,2,3],2,0)
           3
           >>> listget(['a'],1)
           >>> listget(['a','b','c'],4,0)
           0

    """
    if len(lst) - 1 < ind:
        return default
    return lst[ind]

def intget(integer, default=None):
    """
        >>> intget('3')
        3
        >>> intget('3a')
        >>> intget('3a', 0)
        0
    """
    try:
        return int(integer)
    except (TypeError, ValueError):
        return default

def dictreverse(mapping):
    """
        >>> dictreverse({2:1,3:4})
        {1: 2, 4: 3}
    """
    return {v: k for k, v in mapping.items()}

def dictinc(dictionary, element):
    """
    D.setdefault(k[,d]) -> D.get(k,d), also set D[k]=d if k not in D
        >>> d = {1:2, 3:4}
        >>> dictinc(d,1)
        3
        >>> d[1]
        3
        >>> dictinc(d, 5)
        1
        >>> d[5]
        1
    """
    dictionary.setdefault(element, 0)
    dictionary[element] += 1
    return dictionary[element]

def dictadd(*dicts):
    """
        >>> dictadd({1: 0, 2: 0}, {2: 1, 3: 1})
        {1: 0, 2: 1, 3: 1}
    """
    result = {}
    for dct in dicts:
        result.update(dct)
    return result

def numify(string):
    """
    Removes all non-digit characters from `string`.
    >>> numify("222-12")
    '22212'
    >>> numify("123.123.12")
    '12312312'
    """
    return ''.join([s for s in str(string) if s.isdigit()])

def denumify(string, pattern):
    """
    >>> denumify("123456789", "(XXX)XXXXXX")
    '(123)456789'
    """
    out = []
    for c in pattern:
        if c == "X":
            out.append(string[0])
            string = string[1:]
        else:
            out.append(c)
    return ''.join(out)

def nthstr(n):
    """
        >>> nthstr(1)
        '1st'
        >>> nthstr(0)
        '0th'
        >>> [nthstr(x) for x in [2, 3, 4, 5, 10, 11, 12, 13, 14, 15]]
        ['2nd', '3rd', '4th', '5th', '10th', '11th', '12th', '13th', '14th', '15th']
        >>> [nthstr(x) for x in [91, 92, 93, 94, 99, 100, 101, 102]]
        ['91st', '92nd', '93rd', '94th', '99th', '100th', '101st', '102nd']
        >>> [nthstr(x) for x in [111, 112, 113, 114, 115]]
        ['111th', '112th', '113th', '114th', '115th']
    """

    assert n >= 0
    if n % 100 in [11, 12, 13]:
        return "%sth" % n
    return {1: "%sst", 2: "%snd", 3: "%srd"}.get(n % 10, "%sth") % n


if __name__ == "__main__":
    import doctest
    doctest.testmod()

