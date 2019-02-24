from multiprocessing import Process, Lock
import time
import random


def f(l, i):
    l.acquire()
    try:
        time.sleep(random.randint(0, 10))
        print("hello world", i)
    finally:
        l.release()


if __name__ == "__main__":
    lock = Lock()

    for num in range(10):
        Process(target=f, args=(lock, num)).start()
