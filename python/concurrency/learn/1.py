# encoding=utf-8

# 用时为两个函数运行时间相加
from time import sleep, ctime


def loop1():
    print("start loop 1 at ", ctime())
    sleep(4)
    print("end loop 1 at ", ctime())


def loop2():
    print("start loop 2 at ", ctime())
    sleep(2)
    print("end loop 2 at ", ctime())


def main():
    print("start main at ", ctime())
    loop1()
    loop2()
    print("end main at ", ctime())


if __name__ == "__main__":
    main()
