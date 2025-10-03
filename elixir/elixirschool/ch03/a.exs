# Enum 中有70个操作枚举类型的函数

IO.puts(Enum.all?(["foo", "bar", "hello"], fn s -> String.length(s) == 3 end))
IO.puts(Enum.all?(["foo", "bar", "hello"], fn s -> String.length(s) > 1 end))

IO.puts(Enum.any?(["foo", "bar", "hello"], fn s -> String.length(s) == 5 end))

IO.inspect(Enum.chunk_every([1, 2, 3, 4, 5, 6], 2))

IO.inspect(Enum.chunk_by(["one", "two", "three", "four", "five"], fn x -> String.length(x) end))

IO.inspect(Enum.map_every([1, 2, 3, 4, 5, 6, 7, 8, 9], 3, fn x -> x + 100 end))

Enum.each(["one", "two", "three"], fn s -> IO.puts(s) end)

IO.inspect(Enum.map([0, 1, 2, 3], fn x -> x + 1 end))

IO.puts(Enum.min([5, 3, 0, -1, 10]))
IO.puts(Enum.max([5, 3, 0, -1, 10]))

IO.puts(Enum.min([], fn -> :foo end))

IO.inspect(Enum.filter([1, 2, 3, 4], fn x -> rem(x, 2) == 0 end))

IO.inspect(Enum.reduce([1, 2, 3], fn x, acc -> x + acc end))

IO.inspect(Enum.sort([5, 6, 1, 3, -1, 4]))

IO.inspect(Enum.uniq_by([1, 2, 3, 2, 1, 1, 1, 1, 1], fn x -> x end))
