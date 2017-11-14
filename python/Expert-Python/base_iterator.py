class Data(object):
    def __init__(self, *args):
        self._data = list(args)
        self._index = 0

    def __iter__(self):
        return self

    def __next__(self):
        return self.next()

    def next(self):
        if self._index >= len(self._data):
            raise StopIteration()
        d = self._data[self._index]
        self._index += 1
        return d

d = Data(1,2,3,4)
for i in d:
    print(i)
