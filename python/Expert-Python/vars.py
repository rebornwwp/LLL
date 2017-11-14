import sys

print(vars() is locals())
print(vars(sys) is sys.__dict__)
