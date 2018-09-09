# 模式匹配

# = 就是模式匹配

list = [1, 2, 3]
[1 | tail] = list
IO.inspect(tail)

{:ok, value} = {:ok, "Successful"}
IO.puts(value)

x = 1
IO.puts(x)
