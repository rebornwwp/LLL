def sum_of_intervals(intervals):
    x = sorted(intervals)
    number = []
    for i in x:
        if len(number) == 0:
            number.append(i)
        else:
            know = number.pop(-1)
            print("know", know, "i", i)
            if know[0] <= i[0] <= know[1] and know[0] <= i[1] <= know[1]:
                number.append(know)

            if know[0] <= i[0] <= know[1] and know[1] < i[1]:
                number.append((know[0], i[1]))

            if i[0] > know[1]:
                number.append(know)
                number.append(i)
        print("number", number)
    result = 0
    for i in number:
        result += i[1] - i[0]
    return result
            
            
x = [(96, 428), (-48, 36), (321, 336), (124, 343), (454, 496), (-349, -238), (-150, 213), (-7, 380), (16, 353), (399, 440), (410, 472), (-386, -381), (7, 456), (493, 499), (386, 396), (-34, 355), (363, 399)]
x = sorted(x)
print(x)
print(sum_of_intervals(x))

def sum_of_intervals(intervals):
    s, top = 0, float("-inf")
    for a,b in sorted(intervals):
        if top < a: top    = a
        if top < b: s, top = s+b-top, b
    return s