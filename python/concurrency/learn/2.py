# encoding=utf-8
import _thread
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
    _thread.start_new_thread(loop1, ())
    _thread.start_new_thread(loop2, ())
    # 利用sleep作为同步机制
    sleep(6)
    print("end main at ", ctime())


if __name__ == "__main__":
    main()
