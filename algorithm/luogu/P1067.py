N = int(input())


nums = [int(i) for i in input().split()]

ans = ""
for i, num in enumerate(nums):
    if num != 0:
        if N - i != 0:
            mi = "" if N - i == 1 else "^{}".format(N - i)
            if len(ans) != 0:
                num_str = "+{}".format(num) if num > 0 else "{}".format(num)
            else:
                #  开始时候
                if abs(num) > 1:
                    num_str = "{}".format(num)
                else:
                    num_str = "-" if num == -1 else ""
            if len(ans) != 0 and abs(num) == 1:
                num_str = num_str[0]

            ans += "{}x{}".format(num_str, mi)
        else:
            num = num_str = "+{}".format(num) if num > 0 else "{}".format(num)
            ans += num

print(ans)

