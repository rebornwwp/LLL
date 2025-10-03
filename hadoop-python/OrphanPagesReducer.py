#!/usr/bin/env python
import sys
from collections import Counter

link_counter = Counter()


for line in sys.stdin:
    line = line.strip()
    id, is_link = line.split('\t')
    is_link = int(is_link)
    link_counter.update({id: is_link})


orphanPages = [k for k, v in link_counter.items() if v == 0]
for page in sorted(orphanPages):
    print(page)
