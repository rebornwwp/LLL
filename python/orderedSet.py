from collections import OrderedDict
from contextlib import suppress


class OrderedSet(object):
    def __init__(self, iterable=None):
        self.dict = OrderedDict(((x, None) for x in iterable) if iterable else [])

    def add(self, item):
        self.dict[item] = None

    def remove(self, item):
        del self.dict[item]

    def discard(self, item):
        with suppress(KeyError):
            self.remove(item)

    def __iter__(self):
        return iter(self.dict)

    def __contains__(self, item):
        return item in self.dict

    def __bool__(self):
        return bool(self.dict)

    def __len__(self):
        return len(self.dict)

if __name__ == '__main__':
    ordset = OrderedSet(list('abc'))
    print(ordset)
    ordset.add('d')
    print(ordset)
    print(bool(ordset))
    print(len(ordset))
    print('a' in ordset)
    ordset.remove('a')
    for i in ordset:
        print(i, end=' ')
