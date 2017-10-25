a = [1, 'hello', 2, 'world', 3]

print([x for x in a if not isinstance(x, str)])

print([x if not isinstance(x, str) else '' for x in a])
