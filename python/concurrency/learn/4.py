from threading import Thread
from time import sleep, ctime

loops = [4, 2]

def loop(nloop, nsec):
    print("loop ", nloop, "at ", ctime())
    sleep(nsec)
    print("end loop ", nloop, "at ", ctime())

def main():
    print("main start at ", ctime())
    nloops = range(len(loops))
    threads = []
    for i in nloops:
        t = Thread(target=loop, args=(i, loops[i]))
        threads.append(t)

    for i in nloops:
        threads[i].start()

    for i in nloops:
        # wait for all threads to finish
        threads[i].join()

    print("main end at ", ctime())

if __name__ == "__main__":
    main()
