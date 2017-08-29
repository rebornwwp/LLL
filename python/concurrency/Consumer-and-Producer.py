# This architecture make concurrency easy

import time
from Queue import Queue
from random import random
from threading import Thread

q = Queue()


def fib(n):
    if n <= 2:
        return 1
    else:
        return fib(n - 1) + fib(n - 2)


def producer():
    while True:
        wt = random() * 5
        time.sleep(wt)
        q.put((fib, 35))


def comsumer():
    while True:
        task, arg = q.get()
        print(task(arg))
        q.task_done()


t1 = Thread(target=producer)
t2 = Thread(target=comsumer)
t1.start()
t2.start()
