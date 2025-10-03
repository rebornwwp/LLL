#!/usr/bin/env python
import sys
from collections import defaultdict

d = defaultdict(int)

# input comes from STDIN
for line in sys.stdin:
    line = line.strip()
    id, count = line.split('\t')
    try:
        count = int(count)
    except ValueError:
        continue
    d[id] = count

d_list = d.items()
sort_d = sorted(d_list, key=lambda x: x[0], reverse=True)
for k, v in sort_d:
    print('%s\t%d' % (k, v))

