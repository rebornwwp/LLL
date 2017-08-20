def sort_priority(values, group):
    def helper(x):
        if x in group:
            return (0, x)
        else:
            return (1, x)
    values.sort(key=helper)


numbers = [8, 3, 1, 2, 5, 4, 7, 6]
group = {2, 3, 4, 7}
sort_priority(numbers, group)
print(numbers)


def sort_priority2(values, group):
    found = False

    def helper(x):
        if x in group:
            found = True
            return (0, x)
        else:
            return (1, x)
    values.sort(key=helper)
    return found


found = sort_priority2(numbers, group)
print(numbers, found)


def sort_priority2(values, group):
    found = False

    def helper(x):
        nonlocal found
        if x in group:
            found = True
            return (0, x)
        else:
            return (1, x)
    values.sort(key=helper)
    return found


found = sort_priority2(numbers, group)
print(numbers, found)


class Sorter(object):
    def __init__(self, group):
        self.group = group
        self.found = False

    def __call__(self, x):
        if x in self.group:
            self.found = True
            return (0, x)
        else:
            return (1, x)


numbers = [8, 3, 1, 2, 5, 4, 7, 6]
group = {2, 3, 4, 7}
sorter = Sorter(group)
numbers.sort(key=sorter)
print(numbers)
assert sorter.found is True
