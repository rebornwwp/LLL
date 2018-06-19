#!/usr/bin/env python
# -*- coding:utf-8 -*-
import functools
from queue import Queue

import six


def coroutine(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        cr = func(*args, **kwargs)
        six.next(cr)
        return cr
    return wrapper


class Task(object):
    taskid = 0

    def __init__(self, target):
        Task.taskid += 1
        self.tid = Task.taskid
        self.target = target
        self.sendval = None

    def run(self):
        self.target.send(self.sendval)


class SystemCall(object):
    def handle(self):
        pass


class GetTid(SystemCall):
    def handle(self):
        self.task.sendval = self.task.tid
        self.sched.schedule(self.task)


class Scheduler(object):
    def __init__(self):
        self.queue = Queue()
        self.taskmap = {}

    def new(self, target):
        new_task = Task(target)
        self.taskmap[new_task.tid] = new_task
        self.schedule(new_task)
        return new_task.tid

    def schedule(self, task):
        self.queue.put(task)

    def exit(self, task):
        print("Task %d terminated." % task.tid)
        del self.taskmap[task.tid]

    def mainloop(self):
        while self.taskmap:
            task = self.queue.get()
            try:
                result = task.run()
                if isinstance(result, SystemCall):
                    result.task = task
                    result.sched = self
                    result.handle()
            except StopIteration:
                self.exit(task)
                continue
            self.schedule(task)


def foo():
    mytid = yield GetTid()
    for i in range(10):
        print("I am foo.", mytid)
        yield


def bar():
    mytid = yield GetTid()
    for i in range(5):
        print("I am bar.", mytid)
        yield


scheduler = Scheduler()
f = foo()
scheduler.new(f)
b = bar()
scheduler.new(b)
scheduler.mainloop()

