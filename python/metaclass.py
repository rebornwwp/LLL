"""
A metaclass is the class of a class. Like a class defines how an instance
of the class behaves, a metaclass defines how a class behaves. A class is
an instance of a metaclass.
another explaination is Metaclasses are the 'stuff' that creates classes.

             +------------------+-------------------+------------------+
             |    instance      |       class       |     metaclass    |
             +------------------+-------------------+------------------+
                     |                 ^        |                 ^
                     |                 |        |                 |
                     +-- instance of --+        +-- instance of --+

             +-------------+      +-----------+      +------------+
             |  MetaClass  | ---> |  MyClass  | ---> |  MyObject  |
             +-------------+      +-----------+      +------------+
note:
https://stackoverflow.com/questions/100003/what-is-a-metaclass-in-python/100037#100037
https://blog.ionelmc.ro/2015/02/09/understanding-python-metaclasses/
"""

# create class fool dynamically
def choose_class(name):
    if name == 'foo':
        class Foo(object):
            pass
        return Foo # return the class, not an instance
    else:
        class Bar(object):
            pass
        return Bar

# create class dynamically using smart type
# type(name of the class,
#      tuple of the parent class (for inheritance, can be empty),
#      dictionary containing attributes names and values)
typeClass = type('typeClass', (), {})

# add attribute to a class
# class Foo(object):
#     bar = True
# equal to
Foo = type('Foo', (), {'bar':True})

# inherit from Foo using type
FoooChild = type('FooChild', (Foo,), {})

# add methods to your class
def echo_bar(self):
    print(self.bar)
FooChild = type('FooChild', (Foo,), {'echo_bar': echo_bar})


if __name__ == '__main__':
    foo_class = choose_class('foo')
    foo_instance = foo_class()
    print(foo_class)
    print(foo_instance)
    typeClass_instance = typeClass()
    print(typeClass)
    print(typeClass_instance)
    Foo_instance = Foo()
    print(Foo_instance.bar)
    FooChild_instance = FooChild()
    print(FooChild_instance.bar)
    FooChild_instance.echo_bar()
