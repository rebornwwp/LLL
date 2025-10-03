# 注释 -- 三种

# `#`
# `@moduledoc`
# `@doc`

defmodule Greeter do
  @moduledoc """
  Provides a function `hello/1` to greet a human
  """

  @doc """
  Prints a hello message

  ## Parameters

    - name: String that represents the name of the person.

  ## Examples

      iex> Greeting.hello("Sean")
      "hello, Sean"

      iex> Greeting.hello("pete")
      "hello, pete"

  """

  # @spec这个注解一般用于代码的静态分析。
  @spec hello(String.t()) :: String.t()
  def hello(name) do
    "hello, " <> name
  end
end
