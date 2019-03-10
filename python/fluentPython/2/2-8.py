import bisect
import random

HAYSTACK = [1, 4, 5, 6, 8, 12, 15, 20, 21, 23, 23, 26, 29, 30]
NEEDELS = [0, 1, 2, 5, 8, 10, 22, 23, 29, 30, 31]

ROW_FMT = '{0:2d} @ {1:2d}    {2}{0:<2d}'


def demo(bisect_n):
    for needle in reversed(NEEDELS):
        positon = bisect_n(HAYSTACK, needle)
        offset = positon * '  |'
        print(ROW_FMT.format(needle, positon, offset))


print('DEMO', bisect.bisect.__name__)
print('haystack ->' + ' '.join('%2d' % n for n in HAYSTACK))
demo(bisect.bisect)


print('DEMO', bisect.bisect_left.__name__)
print('haystack ->' + ' '.join('%2d' % n for n in HAYSTACK))
demo(bisect.bisect_left)

SIZE = 7

my_list = []
for i in range(10):
    bisect.insort(my_list, random.randrange(SIZE * 2))
    print(my_list)
