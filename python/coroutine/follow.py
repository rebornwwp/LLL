import time

# a Python version of Unix 'tail -f'
def follow(thefile):
    thefile.seek(0, 2)
    while True:
        line = thefile.readline()
        if not line:
            time.sleep(0.1)
            continue
        yield line

if __name__ == "__main__":
    # example use: watch a web-server log file
    logfile = open("access-log")
    for line in follow(logfile):
        print(line)
