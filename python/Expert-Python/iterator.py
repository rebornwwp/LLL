class Data(object):
    __slots__ = ['_data']
    def __init__(self):
        self._data = []
    def add(self, x):
        self._data.append(x)
    def data(self):
        return iter(self._data)

d = Data()
d.add(1)
d.add(2)
d.add(3)
for i in d.data():
    print(i)
