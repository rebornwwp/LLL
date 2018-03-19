
from coroutine import coroutine


class GrepHandler(object):
    def __init__(self, pattern, target):
        self.pattern = pattern
        self.target = target

    def send(self, line):
        if self.pattern in line:
            self.target.send(line)


@coroutine
def grep(pattern, target):
    while True:
        line = (yield)
        if pattern in line:
            target.send(line)
