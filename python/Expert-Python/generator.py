class Data(object):
    def __init__(self, *args):
        self._data = list(args)

    def __iter__(self):
        for x in self._data:
            yield x


d = Data(1,2,3,4)
print(d)
for i in d:
    print(i)

print((i for i in range(3)))
