#!/bin/bash

# Tip:
# If you need to call a function that modifies one or more variables,
# but you don't actually want those variables to be modified, you can
# wrap the function call in parentheses, so it takes place in a subshell.
# This will "isolate" the modifications and prevent them from affecting
# the surrounding execution environment. (That said: when possible,
# it's better to write functions in such a way that this problem doesn't
# arise to begin with. As we'll see soon, the local keyword can help with
# this.)

foo=bar
echo "$foo" # prints 'bar'

# subshell:
(
  echo "$foo" # prints 'bar' - the subshell inherits its parents' variables
  baz=bip
  echo "$baz" # prints 'bip' - the subshell can create its own variables
  foo=foo
  echo "$foo" # prints 'foo' - the subshell can modify inherited variables
)

echo "$baz" # prints nothing (just a newline) - the subshell's new variables are lost
echo "$foo" # prints 'bar' - the subshell's changes to old variables are lost
