"""
The Queue, SimpleQueue and JoinableQueue types are multi-producer, multi-consumer FIFO queues modelled on the queue.Queue class in the standard library. They differ in that Queue lacks the task_done() and join() methods introduced into Python 2.5’s queue.Queue class.
If you use JoinableQueue then you must call JoinableQueue.task_done() for each task removed from the queue or else the semaphore used to count the number of unfinished tasks may eventually overflow, raising an exception.
"""
import multiprocessing
import time
import random

def read(q):
    while True:
        try:
            value = q.get()
            print('Get %s from queue.' % value)
            time.sleep(random.random())
        finally:
            q.task_done()

def main():
    q = multiprocessing.JoinableQueue()
    pw1 = multiprocessing.Process(target=read, args=(q,))
    pw2 = multiprocessing.Process(target=read, args=(q,))
    pw1.daemon = True
    pw2.daemon = True
    pw1.start()
    pw2.start()
    for c in [chr(ord('A')+i) for i in range(26)]:
        q.put(c)
    try:
        q.join()
    except KeyboardInterrupt:
        print("stopped by hand")

if __name__ == '__main__':
    main()
