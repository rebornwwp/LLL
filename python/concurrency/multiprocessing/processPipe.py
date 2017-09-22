"""
用pipe的时候只会产生两个终点(endpoint)
对一个端点同时sendmessage或者同时recvmessage将会产生错误。
"""
from multiprocessing import Process, Pipe


def f(conn):
    conn.send([42, None, "hello"])
    conn.close()


if __name__ == "__main__":
    parent_conn, child_conn = Pipe()
    p = Process(target=f, args=(child_conn,))
    p.start()
    print(parent_conn.recv())
    p.join()
