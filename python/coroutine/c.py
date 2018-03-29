#!/usr/bin/env python
# -*- coding:utf-8 -*-
import asyncio
import time

now = lambda : time.time()

async def do(x):
    print("do", x)
    return x

start = now()

coroutine = do(2)
loop = asyncio.get_event_loop()
task = asyncio.ensure_future(coroutine)
loop.run_until_complete(task)

print(task.result())
print("TIME ", now() - start)
