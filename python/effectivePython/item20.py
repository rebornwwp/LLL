from datetime import datetime


def log(message, when=None):
    when = datetime.now() if when is None else when
    print("%s, %s" % (when, message))


log("hello")
