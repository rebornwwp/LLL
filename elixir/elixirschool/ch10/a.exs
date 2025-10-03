# 魔符语法糖 一个魔符以~开头然后接上一个字符。Elixir已经提供了一些内置的魔符。当然，如果你有需要的话，也可以创造自己的魔符。

# ~C 创建一个不处理插值和转义字符的字符列表
# ~c 创建一个处理插值和转义字符的字符列表
# ~R 创建一个不处理插值和转义字符的正则表达式
# ~r 创建一个处理插值和转义字符的正则表达式
# ~S 创建一个不处理插值和转义字符的字符列表
# ~s 创建一个处理插值和转义字符的字符列表
# ~W 创建一个不处理插值和转义字符的单词列表
# ~w 创建一个处理插值和转义字符的单词列表
# ~N 创建一个 NaiveDateTime 格式的数据结构
#
# 可用的分隔符如下:
#
# <...> 尖括号
# {...} 大括号
# [...] 中括号
# (...) 小括号
# |...| 两条直线(反斜杠上面那个)
# /.../ 斜杠
# "..." 双引号
# '...' 单引号

# 字符列表
~c/2 + 7 = #{2 + 7}/ |> IO.puts()
~C/2 + 7 = #{2 + 7}/ |> IO.puts()

# 正则表达式
re = ~r/elixir/
("Elixir" =~ re) |> IO.puts()
("elixir" =~ re) |> IO.puts()

# 大小写不敏感
re1 = ~r/elixir/i
("Elixir" =~ re1) |> IO.puts()
("elixir" =~ re1) |> IO.puts()

string = "100_000_000"
Regex.split(~r/_/, string) |> IO.puts()

# 字符串
# ~s 和 ~S 这两个魔符用来创建字符串
~s/the cat in the hat on the mat/ |> IO.puts()

~S/the cat in the hat on the mat/ |> IO.puts()

~s/welcome to elixir #{String.downcase("school")}/ |> IO.puts()
~S/welcome to elixir #{String.downcase "school"}/ |> IO.puts()

# 单词列表
# 这个魔符可以在处理表示句子的字符串的时候省下很多精力。
# 它可以降低代码复杂度、节省时间、按键次数。因为它能够将一个字符串自动分割并返回一个列表。
~w/i love elixir school/ |> IO.puts()
~W/i love elixir school/ |> IO.puts()

~w/i love #{'e'}lixir school/ |> IO.puts()
~W/i love #{'e'}lixir school/ |> IO.puts()

# 时间日期
(NaiveDateTime.from_iso8601("2015-01-23 23:50:07") == {:ok, ~N[2015-01-23 23:50:07]}) |> IO.puts()

# 定义你自己的魔符

defmodule MySigils do
  def sigil_u(string, []), do: String.upcase(string)
end

# import MySigils
# ~u/elixir school/ |> IO.puts()
