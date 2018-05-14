#!/usr/bin/env python
import sys


counts = []

for line in sys.stdin:
    line = line.strip()
    count = int(line)
    counts.append(count)

import math
mean = math.floor(sum(counts) / len(counts))
var = math.floor(sum([(x-mean)**2 for x in counts]) / len(counts))
print('Mean\t%d' % mean)
print('Sum\t%d' % sum(counts))
print('Min\t%d' % min(counts))
print('Max\t%d' % max(counts))
print('Var\t%d' % var)