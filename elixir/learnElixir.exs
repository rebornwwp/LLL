# 单行注释
# 没有多行的注释

# shell `iex`
# 编译模块 `elixirc`

# 数据类型

# integer
3
# integer
0x1F

# float
3.0

# 原子类型
:hello

# tuple
{1, 2, 3}

# list
[1, 2, 3]

# 对list访问
[head | tail] = [1, 2, 3]
# => 1
head
# => [2,3]
tail

# `=` 符号代表模式匹配

# binary
<<1, 2, 3>>

# String and Char lists
# String
"hello"
# char list
'hello'

# 多行字符串
"""
I'm a multi-line
string.
"""

# String are all encoded in UTF-8

# 字符串是binaryes的，charlist就只是list
# =>"abc"
<<?a, ?b, ?c>>
# => 'abc'
[?a, ?b, ?c]

# `?a` 获得a字符的ascii编码
# => 97
?a

# concatenate list and binaries
[1, 2, 3] ++ [4, 5]
'hello ' ++ 'world'
<<1, 2, 3>> <> <<4, 5>>
"hello " <> "world"

1..10
# pattern matching
lower..upper = 1..10

# maps是一个键值对
genders = %{"david" => "male", "gillian" => "female"}
genders["david"]

# maps with atom keys
genders = %{david: "male", gillian: "female"}
genders.gillian

# 操作
1 + 1
10 - 5
5 * 2
# /的返回类型是浮点数
10 / 2

# 只获得整数
div(10, 2)
rem(10, 3)

# bool -- or and not
true and true
false or true

# || && ! 参数可以是任意类型
# 类型中只有false和nil被断定为false
1 || false
false && 1
nil && 20
!true

# 比较
1 == 1
1 != 1
1 < 2

# === !== 严格的比较
# => true
1 == 1.0
# => false
1 === 1.0

1 < :hello

# control flow

# if
if false do
  "this will never be seen"
else
  "this will"
end

unless true do
  "thie will never be seen"
else
  "this will"
end

case {:one, :two} do
  {:four, :five} ->
    "this won't match"

  {:one, x} ->
    "this will match and bind `x` to `:two` in this clause"

  _ ->
    "this will match any value"
end

[head | _] = [1, 2, 3]
[head | _tail] = [:a, :b, :c]

cond do
  1 + 1 == 3 ->
    "I will never be seen"

  2 * 5 == 12 ->
    "Me neither"

  1 + 2 == 3 ->
    "I will"
end

cond do
  1 + 1 == 3 ->
    "I will never be seen"

  2 * 5 == 12 ->
    "Me neither"

  true ->
    "But I will (this is essentially an else)"
end

try do
  throw(:hello)
catch
  message -> "Got #{message}"
after
  IO.puts("I'm the after clause")
end

# 匿名函数
square = fn x -> x * x end
square.(5)

f = fn
  x, y when x > 0 -> x + y
  x, y -> x * y
end

f.(1, 3)
f.(-1, 3)

is_number(10)
is_list("hell")
elem({1, 2, 3}, 0)

defmodule Math do
  def sum(a, b) do
    a(+b)
  end

  def square(x) do
    x * x
  end
end

Math.sum(1, 2)
Math.square(3)

# Inside a module we can define functions with `def` and private functions with `defp`.

defmodule PrivateMath do
  def sum(a, b) do
    do_sum(a, b)
  end

  # 私有函数
  defp do_sum(a, b) do
    a + b
  end
end

PrivateMath.sum(1, 2)

defmodule Geometry do
  def area({:rectangle, w, h}) do
    w * h
  end

  def area({:circle, r}) when is_number(r) do
    3.14 * r * r
  end
end

defmodule Recursion do
  def sum_list([head | tail], acc) do
    sum_list(tail, acc + head)
  end

  def sum_list([], acc) do
    acc
  end
end

Recursion.sum_list([1, 2, 3], 0)

defmodule MyMod do
  @moduledoc """
  This is a built-in attribute on a example module.
  """

  # This is a custom attribute.
  @my_data 100
  # => 100
  IO.inspect(@my_data)
end

# pipe operator
Range.new(1, 10)
|> Enum.map(fn x -> x * x end)
|> Enum.filter(fn x -> rem(x, 2) == 0 end)

defmodule Person do
  defstruct name: nil, age: 0, height: 0
end

joe_info = %Person{name: "joe", age: 30, height: 180}

joe_info.name

# 处理异常
try do
  raise "some error"
rescue
  RuntimeError -> "rescued a runtime error"
  _error -> "this will rescue any error"
end

try do
  raise "some error"
rescue
  x in [RuntimeError] ->
    x.message
end

# concurrency

f = fn -> 2 * 2 end
spawn(f)

defmodule Geometry do
  def area_loop do
    receive do
      {:rectangle, w, h} ->
        IO.puts("Area = #{w * h}")
        area_loop()

      {:circle, r} ->
        IO.puts("Area = #{3.14 * r * r}")
        area_loop()
    end
  end
end

pid = spawn(fn -> Geometry.area_loop() end)
