# iterating a  list

for i in [1, 2, 3, 4]:
    print(i)

# iterating a dict
a = dict(a=1, b=2, c=3, d=4)
for i in a:
    print(i)

# iterating a string
for i in 'abcdefg':
    print(i)

# iterating a file
# for line in open("file.txt"):
#     print(line)

items = [1, 2, 3, 4]
it = iter(items)
print(next(it))


# this just support python2, To do this, you just have to make the object implement __iter__() and next(),
# generator for class
class countdown(object):
    def __init__(self, start):
        self.count = start

    def __iter__(self):
        return self

    def next(self):
        if self.count <= 0:
            raise StopIteration
        r = self.count
        self.count -= 1
        return r

for x in countdown(10):
    print(x)

# generator for function
def countdown(n):
    while n > 0:
        yield n
        n -= 1
for i in countdown(5):
    print(i)

it = countdown(5)
print(it.next())

items = [1, 2, 3, 4]
it = (x**2 for i in items)
print(it)


