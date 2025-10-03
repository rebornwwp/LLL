# python中，__prepare__, __new__, __init__ 都是什么?


# 首先 __new__ 先执行，__init__ 之后执行。__new__ 方法的参数是一个类名，先通过这个
# 类型，创建并返回这个类的未初始化实例。__init__ 方法的参数中包含一个类的实例，并对这个实例初始化。

class A(object):
    def __new__(cls):
        print('__new__')
        return super(A, cls).__new__(cls)

    def __init__(self, a):
        print('__init__')
        self.a = a

# 之后 __prepare__ 方法，这个方法一般是在元类中使用，元类定义了prepare以后，会最先执行prepare方法，
# 返回一个空的定制的字典，然后再执行类的语句，类中定义的各种属性被收集入定制的字典，最后传给new和init方法

# 3.3.3.3. Preparing the class namespace Once the appropriate metaclass has been identified,
# then the class namespace is prepared. If the metaclass has a __prepare__ attribute, it is
# called as namespace = metaclass.__prepare__(name, bases, **kwds) (where the additional
# keyword arguments, if any, come from the class definition).

# If the metaclass has no __prepare__ attribute, then the class namespace is initialised as an empty ordered mapping.
