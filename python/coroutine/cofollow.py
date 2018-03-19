# -*- coding: utf-8 -*-

"""
pipeline sources and pipeline sinks

the pipe line needs a initial source(a producer) and the pipe line muse have an end-point(sink)

+--------+   send()    +-----------+   send()    +-----------+   send()    +------+
| source | ==========> | coroutine | ==========> | coroutine | ==========> | sink |
+--------+             +-----------+             +-----------+             +------+

the source like:
    def source(target):
        while not done:
            item = produce_an_item()
            ...
            target.send(item)
            ...
        target.close()

the sink like:
    @coroutine
    def sink():
        try:
            while True:
                item = (yield) # receive an item
                ...  # handle the data
        except GeneratorExit:
            # Done
            ...
"""

import time
from coroutine import coroutine

@coroutine
def printer():
    while True:
        line = (yield)
        print(line)


@coroutine
def follow(thefile, target):
    thefile.seek(0, 2)
    while True:
        line = thefile.readline()
        if not line:
            time.sleep(0.1)
            continue
        target.send(line)


@coroutine
def grep(pattern, target):
    while True:
        line = (yield)
        if pattern in line:
            target.send(line)


"""
+--------+   send()    +--------------+   send()    +-----------+
| follow | ==========> | grep(filter) | ==========> | printer   |
+--------+             +--------------+             +-----------+

重要:Generators pull data through the pipe with iteration. Coroutines push data into the pipeline with send().

"""
if __name__ == "__main__":
    f = open("access-log")
    follow(f, grep('python', printer()))
