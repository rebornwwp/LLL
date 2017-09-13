# encoding=utf-8
# this Singleton can be implemented in python2. 

class Singleton(type):
    def __init__(cls, name, bases, dict):
        super(Singleton, cls).__init__(name, bases, dict)
        cls.instance = None

    def __call__(cls,*args,**kw):
        if cls.instance is None:
            cls.instance = super(Singleton, cls).__call__(*args, **kw)
        return cls.instance

class MyClass(object):
    __metaclass__ = Singleton

a = MyClass()
b = MyClass()

print(a is b)
print(id(a))
print(id(b))
