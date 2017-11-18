import asyncio
import time

# Define a coroutine that takes in a future
async def myCoroutine():
    print("start Working")
    time.sleep(5)
    print("end Working")

# Spin up a quick and simple event loop
# and run until completed
loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(myCoroutine())
finally:
    loop.close()
