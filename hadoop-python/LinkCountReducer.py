#!/usr/bin/env python
import sys
from collections import defaultdict

d = defaultdict(set)

# input comes from STDIN
for line in sys.stdin:
    line = line.strip()
    link, sink_link, count = line.split("\t")
    d[sink_link].add("{}:{}".format(link, count))


for sink_link, link_set in d.items():
    print('%s\t%d' % (sink_link, len(link_set)))
