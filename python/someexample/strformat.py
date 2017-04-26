#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   vito
#   E-mail  :   rebornwwp.gmail.com
#   Date    :   17/04/25 18:39:09
#   Desc    :   关于"{}".format()的格式规范
#

"""
花括号中的形式：
{field_name}
{field_name!conversion}
{field_name:format_specification}
{field_name!conversion:format_specification}

conversion: s, r, a
format_specification: main函数中做了一些概述, 一个总的概括为:fill align sign # 0 width , .precision type
"""
def extract_from_tag(tag, line):
    """
    >>> extract_from_tag("red", "what is <red>Rose</red> this is")
    'Rose'
    """
    opener = "<" + tag + ">"
    closer = "</" + tag + ">"
    try:
        i = line.index(opener)
        start = i + len(tag)
        end = line.index(tag)
        return line[start: end]
    except ValueError:
        return None


def extract_from_tag2(tag, line):
    """
    >>> extract_from_tag("red", "what is <red>Rose</red> this is")
    'Rose'
    """
    opener = "<" + tag + ">"
    closer = "</" + tag + ">"
    i = line.find(opener)
    if i != -1:
        start = i + len(opener)
        j = line.find(closer)
        if j != -1:
            return line[start: j]
    return None


if __name__ == "__main__":
    s = "hello world"
    print("{}".format(s))
    print("{0:25}".format(s))
    print("{0:<25}".format(s))  # 左对齐
    print("{0:>25}".format(s))  # 右对其
    print("{0:^25}".format(s))  # 居中
    print("{0:*^25}".format(s))  # 设置填充
    print("{0:.9}".format(s))  # 最小输出，9小于s的长度，所以只输出前9个字符

    import doctest
    doctest.testmod()
    print(locals())
