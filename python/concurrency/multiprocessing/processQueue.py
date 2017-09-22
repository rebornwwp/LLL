"""
ipc就是进程间的通信模式
进程之间的通信，通过queue，通过对同一个queue的操作，如例子，通过foo子进程放入数据
在父进程中对数据取出并且操作,适合多生产者和多消费者。based on pipe
"""
from multiprocessing import Process, Queue

def foo(q):
    q.put([42, None, 'hello'])


if __name__ == "__main__":
    q = Queue()
    p = Process(target=foo, args=(q,))
    p.start()
    print(q.get())
    p.join()
