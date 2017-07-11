#encoding=utf-8
class Person(object):
    
    def __new__(cls, name, age):
        print ' __new__ called'
        return super(Person, cls).__new__(cls, name, age)

    def __init__(self, name, age):
        print '__init__ called'
        self.name = name
        self.age = age

    def __str__(self):
        return '<Person: %s(%s)>' %(self.name, self.age)


if __name__ == '__main__':
    # new 在init之前运行
    person =  Person('Allen', 23)
    print person

class Singleton(object):
    def __new__(cls):
        # 关键在于这，每一次实例化的时候，我们都只会返回这同一个instance对象
        if not hasattr(cls, 'instance'):
            cls.instance = super(Singleton, cls).__new__(cls)
        return cls.instance
 
 # 两个实例是同一个实例如同int() 和int()一样也是同一个实例
obj1 = Singleton()
obj2 = Singleton()
 
obj1.attr1 = 'value1'
print obj1.attr1, obj2.attr1
print obj1 is obj2
print int() is int()
