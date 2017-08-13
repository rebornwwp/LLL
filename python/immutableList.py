class ImmutableList(tuple):
    """
    this is from django/utils/datastructures.py
    """

    def __new__(cls, *args, warning='ImmutableList object is immutable.', **kwargs):
        self = super().__new__(cls, *args, **kwargs)
        self.warning = warning
        return self

    def complain(self, *args, **kwargs):
        if isinstance(self.warning, Exception):
            raise self.warning
        else:
            raise AttributeError(self.warning)

    __delitem__ = complain
    __delslice__ = complain
    __iadd__ = complain
    __imul__ = complain
    __setitem__ = complain
    __setslice__ = complain
    append = complain
    extend = complain
    insert = complain
    pop = complain
    remove = complain
    sort = complain
    reverse = complain


if __name__ == '__main__':
    l = ImmutableList(range(5))
    l[3] = 4
