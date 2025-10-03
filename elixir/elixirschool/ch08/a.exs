# 模块
defmodule Example do
  def greeting(name) do
    "Hello #{name}"
  end
end

"Sean" |> Example.greeting() |> IO.puts()

# 允许嵌套的模块
defmodule Example.Greetings do
  def morning(name) do
    "Good morning #{name}."
  end

  def evening(name) do
    "Good night #{name}."
  end
end

"Sean" |> Example.Greetings.morning() |> IO.puts()

# 模块属性 greeting 为hello
defmodule Example1 do
  @greeting "hello"
  def greeting(name) do
    ~s(#{@greeting} #{name}.)
  end
end

"Sean" |> Example1.greeting() |> IO.puts()

# 结构体 defstruct
# 结构体是字典的特殊形式，它们的键是预定义的，一般都有默认值。
defmodule Example.User do
  defstruct name: "Sean", roles: []
end

# 组合(composition) 用alias
defmodule Sayings.Greetings do
  def basic(name), do: "Hi, #{name}"
end

defmodule Example2 do
  alias Sayings.Greetings

  def greeting(name), do: Greetings.basic(name)
end

defmodule Example3 do
  def greeting(name), do: Sayings.Greetings.basic(name)
end

# 别名冲突
defmodule Example4 do
  alias Sayings.Greetings, as: Hi

  def print_message(name), do: Hi.basic(name)
end

# 指定多个别名
defmodule Example5 do
  # alias Sayings.{Greetings, Farewells}
end

# import
# 需要List模块中的last函数
import List

[1, 2, 3] |> last() |> IO.puts()

# 默认情况下，import 会导入模块中的所有函数和宏（Macro），我们可以通过 :only 和 :except 来过滤导入当前模块的函数和宏：

# 如同haskell中import Data.List hiding(...)
# only 只导入
# except 过滤
import List, only: [last: 1]

# Elixir 还提供了两个特殊的原子，functions 和 :macros，来让我们只导入函数或宏
import List, only: :functions
import List, only: :macros

# require 调用其他模板中的宏，和import的区别就是，require对宏有效，对函数无效
defmodule Example6 do
  # require SuperMacros

  # SuperMacros.do_stuff
end

# use 用来修改我们当前的模块。当我们在当前模块中调用 use 时，Elixir 会执行指定模块中所定义的 __using__ 回调。
defmodule Hello do
  defmacro __using__(_opts) do
    quote do
      def hello(name), do: "Hi, #{name}"
    end
  end
end

# 创建一个新模块来使用上面的代码
defmodule Example7 do
  use Hello
end

"Sean" |> Example7.hello() |> IO.puts()
