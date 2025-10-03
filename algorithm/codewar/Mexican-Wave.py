import string

def wave(str):
    a = str.upper()

    ans = []
    for i in range(len(str)):
        if str[i] in string.ascii_lowercase:
            ans.append(str[:i] + a[i] + str[i+1:])
    return ans
