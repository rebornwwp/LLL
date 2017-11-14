def framework(logic):
    try:
        it = logic()
        s = next(it)
        print("[FX] logic: ", s)
        print("[FX] do something")
        it.send("async: " + s)
    except StopIteration:
        pass
def logic():
    s = "mylogic"
    r = yield s
    print(r)

framework(logic)
