IO.puts(Enum.join([3.14, :pie, "Apple"], " "))
list = [3.14, :pie, "Apple"]
IO.puts(Enum.join(["n"] ++ list, " "))
IO.puts(Enum.join([1, 2, 3] ++ [3, 4], " "))
IO.puts(Enum.join([1, 2] -- [1], " "))
IO.puts(hd([1, 2, 3]))
IO.puts(tl([1, 2, 3]))
[head | tail] = list
IO.puts(head)
IO.puts(Enum.join(tail, " "))
IO.inspect({3.14, :pie, "Apple"})
IO.inspect(File.read("la/file"))
IO.inspect([foo: "bar", hello: "world"])
IO.inspect([{:foo, "bar"}, {:hello, "world"}])

map = %{:foo => "bar", "hello" => :world}
IO.inspect(map)
IO.inspect(map[:foo])
IO.inspect(map["hello"])
IO.inspect(%{:foo => "bar", :foo => "hello world"})
# 不用=> 的形式
IO.inspect(%{foo: "bar", hello: "world"})
