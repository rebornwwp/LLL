from coroutine import coroutine


@coroutine
def grep(pattern):
    # print("Looking for %s" % pattern)
    try:
        while True:
            line = (yield)
            if pattern in line:
                print(line)
    except GeneratorExit:
        print("Going away. bye")


if __name__ == "__main__":
    g = grep("python")
    g.send("hello world")
    g.send("python world")
    g.send("halo python ! yeah")

    # 协程可以抛出异常
    g.throw(RuntimeError, "you're hosed")
