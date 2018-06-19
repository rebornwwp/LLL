mydict = {'carl': 40,
          'alan': 2,
          'bob': 1,
          'danny': 3}

# sort by key:
for key in sorted(mydict.keys()):
    print(mydict[key])

# sort by value:
for key, value in sorted(mydict.items(), key=lambda kv: (kv[1], kv[0])):
    print(key, value)
