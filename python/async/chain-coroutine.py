import asyncio


async def compute(x, y):
    print("compute %s + %s ..." % (x, y))
    await asyncio.sleep(1)
    return x + y

async def print_sum(x, y):
    result = await compute(x, y)
    print("%s + %s = %s" % (x, y ,result))


loop = asyncio.get_event_loop()
loop.run_until_complete(print_sum(1, 3))
loop.close()
