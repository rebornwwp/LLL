#!/usr/bin/env python
from operator import itemgetter
import sys
from collections import Counter

word_counter = Counter()

# input comes from STDIN
for line in sys.stdin:
    line = line.strip()
    word, count = line.split('\t', 1)
    try:
        count = int(count)
    except ValueError:
        continue
    word_counter.update({word: count})

word_counter_list = word_counter.items()
for k, v in word_counter_list:
    print("%s\t%s" % (k, v))
