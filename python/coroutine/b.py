#!/usr/bin/env python
# -*- coding:utf-8 -*-
import asyncio
import time

now = lambda : time.time()

async def do(x):
    print("hhhhh ", x)
    return "done after {}".format(x)

def callback(future):
    print("callback: ", future.result())

start = now()
coroutine = do(2)
loop = asyncio.get_event_loop()
task = asyncio.ensure_future(coroutine)
task.add_done_callback(callback)
loop.run_until_complete(task)

print("time", now()-start)
