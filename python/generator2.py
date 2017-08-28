# send a message to generator

def spam():
    msg = yield
    print("message:", msg)

try:
    g = spam()
    next(g)
    g.send("hello world")
except StopIteration:
    pass

# yield from expression

def subgen():
    try:
        yield 9809
    except ValueError:
        print("get value error")

def delegating_gen():
    yield from subgen()

g = delegating_gen()
try:
    next(g)
    g.throw(ValueError)
except StopIteration:
    print("gen stop")


# yield from + yield from
import inspect

def subgen():
    yield from range(5)

def delegating_gen():
    yield from subgen()

g = delegating_gen()
print(inspect.getgeneratorlocals(g))
next(g)
print(inspect.getgeneratorlocals(g))
g.close()
print(inspect.getgeneratorlocals(g))
