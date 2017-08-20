class ReadVisits(object):
    """
    优点可产生一个新迭代器，一个迭代器可以复用，每次返回执行长生迭代器的代码，这点可以产生效率问题
    """

    def __init__(self, data_path):
        self.data_path = data_path

    def __iter__(self):
        with open(self.data_path) as f:
            for line in f:
                yield line


def normalize_defensive(numbers):
    # 这要是下面这个代码可以将传入的参数numbers必须是一个container，如果是迭代器，将会抛出异常
    if iter(numbers) is iter(numbers):
        raise TypeError("Must supply a container")

    result = []
    total = sum(numbers)
    for number in numbers:
        percent = 100 * numbers / total
        result.append(percent)
    return result
