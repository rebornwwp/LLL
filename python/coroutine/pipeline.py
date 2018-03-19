"""
some notes

generator ca pipelines

One of the most powerful applications of generators is setting up processing pipelines
Similar to shell pipes in Unix


+-----------------+    +-----------+    +-----------+    +-----------+    +------------+
| input sequence  | => | generator | => | generator | => | generator | => | for x in a |
+-----------------+    +-----------+    +-----------+    +-----------+    +------------+
Idea: You can stack a series of generator functions together into a pipe and pull items through it with a for-loop

"""

from follow import follow

def grep(pattern, lines):
    for line in lines:
        if pattern in line:
            yield(line)

logfile = open('access-log')
loglines = follow(logfile)
pylines = grep("python", loglines)

for line in pylines:
    print(line)
