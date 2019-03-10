import array
import time

numbers = array.array('h', [-2, -1, 0, 1, 2])

memv = memoryview(numbers)
print(dir(memv))

print(len(memv))
print(memv[0])

memv_oct = memv.cast('B')

print(memv_oct.tolist())
print(len(memv_oct))
print(numbers)
memv_oct[5] = 4
print(numbers)
