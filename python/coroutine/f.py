#!/usr/bin/env python
# -*- coding:utf-8 -*-
import asyncio
import time

now = lambda : time.time()

async def do(x):
    print("waiting: ", x)
    await asyncio.sleep(x)
    return "Done after {}s".format(x)

async def main():
    coroutine1 = do(1)
    coroutine2 = do(2)
    coroutine4 = do(4)

    tasks = [
            asyncio.ensure_future(coroutine1),
            asyncio.ensure_future(coroutine2),
            asyncio.ensure_future(coroutine4),
            ]

    dones, pending = await asyncio.wait(tasks)
    for task in dones:
        print(task.result())

start = now()

loop = asyncio.get_event_loop()
task = asyncio.ensure_future(main())
try:
    loop.run_until_complete(task)
except KeyboardInterrupt as e:
    print(asyncio.Task.all_tasks())
    print(asyncio.gather(*asyncio.Task.all_tasks()).cancel())
    loop.stop()
    loop.run_forever()
finally:
    loop.close()

print("TIME: ", now() - start)
