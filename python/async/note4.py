import asyncio
import time

async def firstWorker():
    while True:
        await asyncio.sleep(1)
        print("First Worker Executed")

async def secondWorker():
    while True:
        await asyncio.sleep(1)
        print("Second Worker Executed")


loop = asyncio.get_event_loop()
try:
    asyncio.async(firstWorker())
    asyncio.async(secondWorker())
    loop.run_forever()
except KeyboardInterrupt:
    pass
finally:
    print("Closing Loop")
    loop.close()
