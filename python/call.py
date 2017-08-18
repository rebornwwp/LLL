class Factorial(object):
    def __init__(self):
        self.cache = {}

    def __call__(self, n):
        if n not in self.cache:
            if n == 0:
                self.cache[n] = 1
            else:
                self.cache[n] = n * self.cache[n - 1]
        return self.cache[n]


if __name__ == '__main__':
    fact = Factorial()
    for x in range(10):
        print(fact(x))

    print(fact.cache)
