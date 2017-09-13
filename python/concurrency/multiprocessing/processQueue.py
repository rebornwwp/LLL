from multiprocessing import Process, Queue

def foo(q):
    q.put([42, None, 'hello'])


if __name__ == "__main__":
    q = Queue()
    p = Process(target=foo, args=(q,))
    p.start()
    print(q.get())
    p.join()
