def safe_division(number, divisor, ignore_overflow=False, ignore_zero_divisions=False):
    try:
        return number / divisor
    except OverflowError:
        if ignore_overflow:
            return 0
        else:
            raise
    except ZeroDivisionError:
        if ignore_zero_divisions:
            return 0
        else:
            raise


safe_division(10, 1)


def print_args(*args, **kwargs):
    print(args)
    print(kwargs)


print_args(1, 2, 3, 4, a=1, b=2, c=3)
