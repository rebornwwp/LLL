# encoding=utf-8
from threading import Thread


# 通过类创建线程
class Worker(Thread):
    def __init__(self, id):
        super(Worker, self).__init__()
        self._id = id

    def run(self):
        print("I am worker %d" % self._id)


t1 = Worker(1)
t2 = Worker(2)
t1.start()
t2.start()


# 通过函数创建线程
def worker(worker_id):
    print("I am worker %d" % worker_id)


t1 = Thread(target=worker, args=(1,))
t2 = Thread(target=worker, args=(2,))

t1.start()
t2.start()
