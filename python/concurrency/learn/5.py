from threading import Thread
from time import sleep, ctime

loops = [4, 2]

class MyThread(Thread):
    def __init__(self, func, args, name=""):
        Thread.__init__(self)
        self.name = name
        self.func = func
        self.args = args

    def run(self):
        self.func(*self.args)


def loop(nloop, nsec):
    print("loop ", nloop, "at ", ctime())
    sleep(nsec)
    print("loop ", nloop, "end at ", ctime())


def main():
    print("main start at ", ctime())
    threads = []
    nloops = range(len(loops))

    for i in nloops:
        t = MyThread(loop, (i, loops[i]),
                loop.__name__)
        threads.append(t)

    for i in nloops:
        threads[i].start()

    for i in nloops:
        threads[i].join()

    print("main end at ", ctime())


if __name__ == "__main__":
    main()
