#!/usr/bin/env python
import sys


leaguePath = sys.argv[1]

d = dict()

with open(leaguePath) as f:
    lines = f.readlines()
    leagues = [line.strip() for line in lines]
    for league in leagues:
        d[league] = 0


for line in sys.stdin:
    line = line.strip()
    id, count = line.split('\t')
    if id in leagues:
        try:
            count = int(count)
        except ValueError:
            continue
        d[id] = count

for id, count in d.items():
    print("%s\t%d" % (id, count))
