def singleton(cls, *args, **kwargs):
    instance = {}
    def _singleton():
        if cls not in instance:
            instance[cls] = cls(*args, **kwargs)
        return instance[cls]
    return _singleton


@singleton
class MyClass(object):
    a = 1
    def __init__(self, x=0):
        self.x = x

a = MyClass()
b = MyClass()
print(a is b)
print(id(a))
print(id(b))
print(a.x)
print(b.x)


a.x= 10
print(a.x)
print(b.x)
