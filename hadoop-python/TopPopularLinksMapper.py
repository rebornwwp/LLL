#!/usr/bin/env python
import sys
from collections import Counter

counter = Counter()


for line in sys.stdin:
    line = line.strip()
    k, v = line.split('\t')
    try:
        v = int(v)
    except ValueError:
        continue
    counter.update({k: v})

counter_list = counter.items()

sort_counter = sorted(counter_list, key=lambda x: x[1], reverse=True)
for k, v in sort_counter[:10]:
    print("%s\t%d" % (k, v))
