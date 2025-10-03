#!/usr/bin/env python
import sys


for line in sys.stdin:
  line = line.strip()
  id, links = line.split(':')
  links = links.split()
  for link in links:
    print("%s\t%s\t%d" % (id, link, 1))
