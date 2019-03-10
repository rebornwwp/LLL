from unicodedata import normalize

s1 = 'café'
s2 = 'cafe\u0301'

# s2为组合字符, s1和s2代表的字符串一样，但是其长度不同
print("s1: {} {}", len(s1), s1)
print("s2: {} {}", len(s2), s2)


# normalize 函数的第一个参数意识
# 1. NFC (Normalization Form C) 使用最少的码位构成等价的字符串
# 2. NFD 把组合字符分解成基字符和单独的组合字符
# 3. NFKC
# 4. NFKD

def nfc_equal(str1, str2):
    """
    """
    return normalize('NFC', str1) == normalize('NFC', str2)


def fold_equal(str1, str2):
    return (normalize('NFC', str1).casefold() ==
            normalize('NFC', str2).casefold())


print(len(normalize('NFC', s1)), len(normalize('NFC', s2)))
print(len(normalize('NFD', s1)), len(normalize('NFD', s2)))
print(s1 == s2)
print(nfc_equal(s1, s2))
print(nfc_equal('A', 'a'))

print(fold_equal(s1, s2))
print(fold_equal('A', 'a'))

# 大小写折叠 所有文本的改成小写，再做些其他变换。 str.casefold()
