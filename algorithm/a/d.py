# the number of the deepest parenthesis
def nesting(chars):
    print(chars)
    if len(chars) == 0:
        return 0

    if chars[0] == ')':
        return 0

    c = chars.pop(0)

    n = nesting(chars)

    c = chars.pop(0)

    m = nesting(chars)

    return max(n+1, m)

print(nesting(list("((())((())))")))

