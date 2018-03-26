#!/usr/bin/env python
# -*- coding:utf-8 -*-

import threading

# 传统的对一个用户做操作


class Student(object):
    def __init__(self, name):
        self.name = name

    def __repr__(self):
        return self.name

    def __str__(self):
        return self.name


def process_student(name):
    std = Student('Allen')
    do_task_with_argument_1(std)
    do_task_with_argument_2(std)


def do_task_with_argument_1(std):
    print("%s do the task with argument 1" % std)


def do_task_with_argument_2(std):
    print("%s do the task with argument 2" % std)


def main1():
    # 没有全局变量存储这个学生的信息，每个函数将学生数据当作函数参数传入函数中，被函数使用
    process_student("Allen")


# 通过一个全局的dict来实现数据的存储
global_dict = {}


def std_thread(name):
    std = Student(name)
    global_dict[threading.current_thread()] = std
    do_task_without_argument_1()
    do_task_without_argument_2()


def do_task_without_argument_1():
    std = global_dict[threading.current_thread()]
    print("%s do the task without argument 1" % std)


def do_task_without_argument_2():
    std = global_dict[threading.current_thread()]
    print("%s do the task without argument 2" % std)


def main2():
    std_thread("Bob")


# 通过一个threading.local全局变量来实现数据的存储共享,可以将local理解为一个比dict更优雅的变量。

local_data = threading.local()


def std_thread_local(name):
    std = Student(name)
    local_data.student = std
    do_task_with_local_1()
    do_task_with_local_2()


def do_task_with_local_1():
    std = local_data.student
    print("%s do the task with local 1" % std)


def do_task_with_local_2():
    std = local_data.student
    print("%s do the task with local 2" % std)


def main3():
    std_thread_local("Cici")


def main():
    main1()
    main2()
    main3()


if __name__ == '__main__':
    main()
