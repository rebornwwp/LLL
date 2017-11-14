"""
add the end clause
"""

__builtins__.end = None

def test(x):
    if x > 1:
        print('a')
    else:
        print('b')
    end
end


def main():
    test(1)
    print("I can use end in python")
end

main()
print(dir(__builtins__))
