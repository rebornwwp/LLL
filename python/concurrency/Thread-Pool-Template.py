# producer and consumer architecture
from Queue import Queue
from threading import Thread


class Worker(Thread):
    def __init__(self, queue):
        super(Worker, self).__init__()
        self._q = queue
        self.daemon = True
        self.start()

    def run(self):
        while True:
            f, args, kwargs = self._q.get()
            try:
                print f(*args, **kwargs)
            except Exception as e:
                print e
            self._q.task_done()


class ThreadPool(object):
    def __init__(self, num_t=5):
        self._q = Queue(num_t)
        # Create Worker Thread
        for _ in range(num_t):
            Worker(self._q)

    def add_task(self, f, *args, **kwargs):
        self._q.put((f, args, kwargs))

    def wait_complete(self):
        self._q.join()


def fib(n):
    if n <= 2:
        return 1
    return fib(n - 1) + fib(n - 2)


if __name__ == '__main__':
    pool = ThreadPool()
    for _ in range(3):
        pool.add_task(fib, 35)
    pool.wait_complete()
