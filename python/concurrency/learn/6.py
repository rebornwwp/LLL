from threading import Thread
from time import ctime, sleep

def fib(x):
    sleep(0.005)
    if x < 2:
        return 1
    else:
        return fib(x-1) + fib(x-2)

def fac(x):
    sleep(0.1)
    if x < 2:
        return 1
    else:
        return x*fac(x-1)

def sum(x):
    sleep(0.1)
    if x < 2:
        return 1
    else:
        return x + sum(x-1)

def main():
    n = 12
    print("start single ", ctime())
    fac(12)
    sum(12)
    fib(12)
    print("end single ", ctime())

    threads = []
    print("start multi", ctime())
    threads.append(Thread(target=fib, args=(12,)))
    threads.append(Thread(target=sum, args=(12,)))
    threads.append(Thread(target=fac, args=(12,)))
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()
    print("end multi", ctime())

if __name__ == "__main__":
    main()
