# generate sequence

def chain():
    for _ in 'ab':
        yield _
    for _ in range(4):
        yield _

print(list(chain()))

def chain2():
    yield from 'ab'
    yield from range(4)

print(list(chain2()))
