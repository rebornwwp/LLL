def framework(logic, callback):
    s = logic()
    print('[fx] logix', s)
    print('[fx] do something')
    callback('asyn: ' + s)

def logic():
     s = 'mylogic'
     return s

def callback(s):
    print(s)

framework(logic, callback)
