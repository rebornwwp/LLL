"""
多线程争夺锁的时候，允许第一个获取锁的线程进入临界区，并执行代码。之后到达的线程将被阻塞，直到第一个线程被执行完之后
才会释放锁，完了之后，其他阻塞的线程才会获取锁进入临界区。阻塞的线程是没有顺序的。
"""
from atexit import register
from random import randrange
from threading import Thread, currentThread, Lock
from time import sleep, ctime

lock = Lock()

class CleanOutoutSet(set):
    def __str__(self):
        return ", ".join(x for x in self)

loops = (randrange(2, 5) for x in range(randrange(3, 7)))
remaining = CleanOutoutSet()

def loop(nsec):
    name = currentThread().name
    lock.acquire()
    remaining.add(name)
    print("%s started %s" % (ctime(), name))
    lock.release()
    sleep(nsec)
    lock.acquire()
    remaining.remove(name)
    print("%s completed %s (%d sec)" % (ctime(), name, nsec))
    print("remaining is %s" % (remaining or None))
    lock.release()

def _main():
    for pause in loops:
        Thread(target=loop, args=(pause,)).start()

@register
def _atexit():
    print("all done at ", ctime())

if __name__ == "__main__":
    _main()
