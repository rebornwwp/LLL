# 无锁线程

import random
import threading
import time

total = 0


def update_total(amount):
    """
    upadte the total by the given amount
    """
    global total
    total += amount
    time.sleep(random.randint(0, 10))
    print(total)


if __name__ == "__main__":
    for i in range(10):
        thread = threading.Thread(target=update_total, args=(5,))
        thread.start()
