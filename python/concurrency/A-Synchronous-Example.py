from subprocess import Popen, PIPE
import logging; logging.getLogger().setLevel(logging.INFO)
import sys
import time
import json


PROG = """
import json
import time
from datetime import datetime

while True:
    data = {
       'time': datetime.now().strftime('%c %f milliseconds'),
       'string': 'hello, world',
    }
    print(json.dumps(data))
"""

with Popen([sys.executable, '-u', '-c', PROG], stdout=PIPE) as proc:
    last_line = ''
    start_time, delta = time.time(), 0

    while delta < 5: # only loop for 5 seconds

        line = proc.stdout.readline().decode()

        # pretend marshalling the data takes 1 second
        data = json.loads(line); time.sleep(1)

        if line != last_line:
            logging.info(data)

        last_line = line
        delta = time.time() - start_time
