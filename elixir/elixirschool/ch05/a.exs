# if unless
if String.valid?("hello") do
  IO.puts("valid string")
else
  IO.puts("Invalid string")
end

unless is_integer("helo") do
  IO.puts("Not an Int")
end

# case
case {:ok, "Hello world"} do
  {:ok, result} -> result
  {:error} -> "uh oh"
  _ -> "Catch all"
end

case {1, 2, 3} do
  {1, x, 3} when x > 0 -> "Will match"
  _ -> "Won't match"
end

cond do
  2 + 2 == 5 -> "this will not be true"
  2 * 2 == 3 -> "Nor this"
  1 + 1 == 2 -> "but this will"
end
