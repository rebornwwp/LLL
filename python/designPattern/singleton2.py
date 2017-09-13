class Borg(object):
    _state = {}
    def __init__(self):
        self.__dict__ = self._state


class Myclass(Borg):
    a = 1

a = Myclass()
b = Myclass()

print(a is b)
print(a.__dict__ is b.__dict__)
print(id(a.__dict__))
print(id(b.__dict__))
