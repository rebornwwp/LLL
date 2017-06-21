#!/usr/bin/env python
# -*- coding:utf-8 -*-

import re
from collections import Counter


def create_list(filename):
    dataList = []
    with open(filename) as f:
        for line in f.readlines():
            content = re.sub("\"|,|\.", "", line)
            dataList.extend(content.strip().split())
    return dataList


def word_count(filename):
    c = Counter(create_list(filename))
    for k, v in c.items():
        print(k + ", " + str(v))


if __name__ == "__main__":
    filename = "test.txt"
    word_count(filename)
