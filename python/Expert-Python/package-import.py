import imp
f, filename, description = imp.find_module('sys')
sys = imp.load_module('sys', f, filename, description)
print(sys)

os = __import__('os')
print(os)
print(__path__)
