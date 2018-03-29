#!/usr/bin/env python
# -*- coding:utf-8 -*-
import time
import asyncio
from threading import Thread

now = lambda : time.time()

def start_loop(loop):
    asyncio.set_event_loop(loop)
    loop.run_forever()

async def do(x):
    print("waiting {}".format(x))
    await asyncio.sleep(x)
    print("Done after {}s".format(x))

def more_work(x):
    print("More work {}".format(x))
    time.sleep(x)
    print("finished more work {}".format(x))

start = now()
new_loop = asyncio.new_event_loop()
t = Thread(target=start_loop, args=(new_loop,))
t.start()
print("TIME: {}".format(now()-start))

new_loop.call_soon_threadsafe(do(6), new_loop)
new_loop.call_soon_threadsafe(do(4), new_loop)
