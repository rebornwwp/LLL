"""
Check to see if a string has the same amount of 'x's and 'o's. The method must return a boolean and be case insensitive. The string can contains any char.

Examples input/output:

    XO("ooxx") => true
    XO("xooxx") => false
    XO("ooxXm") => true
    XO("zpzpzpp") => true // when no 'x' and 'o' is present should return true
    XO("zzoo") => false
"""


def xo(s):
    diff = 0
    for i in s:
        if i.lower() == 'o':
            diff += 1
        if i.lower() == 'x':
            diff -= 1
    return diff == 0
