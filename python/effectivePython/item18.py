def log(message, values):
    if not values:
        print(message)
    else:
        values_str = ", ".join(str(x) for x in values)
        print("%s: %s" % (message, values_str))


log('My numbers are', [1, 2])
log('Hi there', [])


def log(message, *values):
    if not values:
        print(message)
    else:
        values_str = ", ".join(str(x) for x in values)
        print("%s: %s" % (message, values_str))


log('My numbers are', 1, 2)
log('Hi there')
colors = [7, 33, 99]
log('Favorite colors', *colors)


def my_generator():
    for i in range(10):
        yield i


def my_func(*args):
    print(args)


it = my_generator()
my_func(*it)
