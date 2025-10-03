#!/usr/bin/env python

import sys
import string


stopWordsPath = sys.argv[1]
delimitersPath = sys.argv[2]


with open(stopWordsPath) as f:
    lines = f.readlines()
    stopWords = [line.strip() for line in lines]


with open(delimitersPath) as f:
    delimiters = f.readline()


for line in sys.stdin:
    line = line.strip()
    line = ''.join([s.lower() if s not in delimiters else ' ' for s in line])
    words = line.split()
    for word in words:
        if word not in stopWords:
            print("%s\t%s" % (word, 1))
