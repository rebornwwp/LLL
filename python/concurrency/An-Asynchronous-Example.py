import typing as T
import asyncio.subprocess
import logging
import sys
import json

from concurrent.futures import ProcessPoolExecutor, Executor
from functools import partial
from contextlib import contextmanager


@contextmanager
def event_loop() -> asyncio.AbstractEventLoop:
    loop = asyncio.get_event_loop()
    # default asyncio event loop executor is
    # ThreadPoolExecutor which is usually fine for IO-bound
    # tasks, but bad if you need to do computation
    with ProcessPoolExecutor() as executor:
        loop.set_default_executor(executor)
        yield loop
    loop.close()
    print('\n\n---loop closed---\n\n')


# any `async def` function is a coroutine
async def read_json_from_subprocess(
        loop: asyncio.AbstractEventLoop = asyncio.get_event_loop(),
        executor: T.Optional[Executor] = None
) -> None:
    # wait for asyncio to initiate our subprocess
    process: asyncio.subprocess.Process = await create_process()

    while True:
        bytes_ = await process.stdout.readline()
        string = bytes_.decode('utf8')
        # deserialize_json is a function that
        # we'll send off to our executor
        deserialize_json = partial(json.loads, string)

        try:
            # run deserialize_json in the loop's default executor (ProcessPoolExecutor)
            # and wait for it to return
            output = await loop.run_in_executor(executor, deserialize_json)
            print(f'{process} -> {output}')
        except json.decoder.JSONDecodeError:
            logging.error('JSONDecodeError for input: ' + string.rstrip())


def create_process() -> asyncio.subprocess.Process:
    return asyncio.create_subprocess_exec(
        sys.executable, '-u', 'printer.py',
        stdout=asyncio.subprocess.PIPE
    )


async def run_for(
    n: int,
    loop: asyncio.AbstractEventLoop = asyncio.get_event_loop()
) -> None:
    """
    Return after a set amount of time,
    cancelling all other tasks before doing so.
    """
    start = loop.time()

    while True:

        await asyncio.sleep(0)

        if abs(loop.time() - start) > n:
            # cancel all other tasks
            for task in asyncio.Task.all_tasks(loop):
                if task is not asyncio.Task.current_task():
                    task.cancel()
            return


with event_loop() as loop:
    coroutines = (read_json_from_subprocess() for _ in range(5))
    # create Task from coroutines and schedule
    # it for execution on the event loop
    asyncio.gather(*coroutines)  # this returns a Task and schedules it implicitly

    loop.run_until_complete(run_for(5))
