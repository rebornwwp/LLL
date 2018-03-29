#!/usr/bin/env python
# -*- coding:utf-8 -*-
import asyncio
import time

now = lambda : time.time()

async def do(x):
    print("waiting: ", x)
    await asyncio.sleep(x)
    return "Done after {}s".format(x)

start = now()

coroutine1 = do(1)
coroutine2 = do(2)
coroutine4 = do(4)

tasks = [
        asyncio.ensure_future(coroutine1),
        asyncio.ensure_future(coroutine2),
        asyncio.ensure_future(coroutine4),
        ]

loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(asyncio.wait(tasks))
except KeyboardInterrupt:
    print(asyncio.Task.all_tasks())
    for task in asyncio.Task.all_tasks():
        print(task.cancel())
    loop.stop()
    loop.run_forever()
finally:
    loop.close()

print("TIME: ", now() - start)

