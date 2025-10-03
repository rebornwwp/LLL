#!/usr/bin/env python
import sys


for line in sys.stdin:
    line = line.strip()
    id, links_str = line.split(':')
    links = links_str.split()
    if links:
        print('%s\t%s' % (id, 1))
        for link in links:
            print('%s\t%s' % (link, 0))
