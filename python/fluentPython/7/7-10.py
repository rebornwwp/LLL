import functools

registry = set()


def register(active=True):
    @functools.wraps(func)
    def wraps(*args, **kwargs):
        if active:
            registry.add(func)
        else:
            registry.discard(func)
        result = func(*args, **kwargs)
        return result
    return wraps


@register(active=False)
def f1():
    pass


@register(active=True)
def f2():
    pass


print("registry -> ", register)
