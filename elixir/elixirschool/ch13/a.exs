# 推倒
import Integer

list = [1, 2, 3, 4, 5]
for(x <- list, do: x * x) |> IO.inspect()

for({_key, val} <- [one: 1, two: 2, three: 3], do: val) |> IO.inspect()

for {k, v} <- %{"a" => "A", "b" => "B"}, do: {k, v} |> IO.inspect()

for <<c <- "hello">>, do: <<c>> |> IO.puts()

for n <- list, times <- 1..n, do: String.duplicate("*", times) |> IO.inspect()

for(x <- 1..10, is_even(x), do: x) |> IO.inspect()

for c <- [72, 101, 108, 108, 111], into: "", do: <<c>> |> IO.inspect()
