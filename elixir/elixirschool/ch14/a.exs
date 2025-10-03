# 字符串
string = <<104, 101, 108, 108, 111>>
string |> IO.puts()
(string <> <<0>>) |> IO.puts()

# 字符列表
'hello' |> IO.inspect()

# 字素和字码点
st = "\u0061\u0301"
String.codepoints st |> IO.inspect()
String.graphemes st |> IO.inspect()

# 字符串函数
String.length("Hello") |> IO.puts()
String.replace("Hello", "e", "a") |> IO.puts()
String.duplicate("Oh my ", 3) |> IO.puts()
String.split("Hello World", " ") |> IO.inspect()

defmodule Anagram do
  def anagrams?(a, b) when is_binary(a) and is_binary(b) do
    sort_string(a) == sort_string(b)
  end

  def sort_string(string) do
    string
    |> String.downcase()
    |> String.graphemes()
    |> Enum.sort()
  end
end
