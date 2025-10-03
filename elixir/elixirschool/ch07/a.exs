# foo(bar(baz(new_function(other_function()))))
# 上面的函数很是难度，混乱
# 利用管道操作符之后
# other_function() |> new_function() |> baz() |> bar() |> foo()

"Elixir rocks" |> String.split() |> IO.puts()
"Elixir rocks" |> String.upcase() |> String.split() |> IO.puts()
"Elixir rocks" |> String.ends_with?("ixir") |> IO.puts()
