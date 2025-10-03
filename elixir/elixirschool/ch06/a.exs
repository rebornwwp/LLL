# 匿名函数
sum = fn a, b -> a + b end

IO.puts(sum.(1, 2))

# 参数获取通过&1 &2 &3 获得
sum2 = &(&1 + &2)
IO.puts(sum2.(1, 2))

handle_result = fn
  {:ok, result} -> IO.puts("handle resutl")
  {:ok, _} -> IO.puts("This would be never run as previous will be matched beforehand.")
  {:error} -> IO.puts("An error has occurred!")
end

handle_result.({:ok, 1})

# 命名函数

defmodule Greet do
  def hello(name) do
    "hello, " <> name
  end

  def hello2(name), do: "hello, " <> name
end

IO.puts(Greet.hello("Sean"))

# pattern matching
defmodule Length do
  def of([]), do: 0
  def of([_ | tail]), do: 1 + of(tail)
end

IO.puts(Length.of([1, 2, 3, 4, 5]))
IO.puts(Length.of([]))

defmodule Greeter2 do
  # hello/0
  def hello(), do: "Hello, anonymous person!"
  # hello/1
  def hello(name), do: "Hello, " <> name
  # hello/2
  def hello(name1, name2), do: "Hello, #{name1} and #{name2}"
end

defmodule Greeter do
  def hello(name), do: phrase <> name
  # 私有函数
  defp phrase, do: "Hello, "
end

# guard
defmodule Greeter do

  # 设置默认参数的函数头部
  def hello(names, language_code \\ "en")

  end
  def hello(names) when is_list(names) do
    names
    |> Enum.join(", ")
    |> hello
  end

  def hello(name) when is_binary(name) do
    phrase() <> name
  end

  defp phrase, do: "Hello, "
end

# 默认参数
defmodule Greeter do
  def hello(name, language_code \\ "en") do
    phrase(language_code) <> name
  end

  defp phrase("en"), do: "Hello, "
  defp phrase("es"), do: "Hola, "
end
