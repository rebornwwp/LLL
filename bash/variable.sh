#!/bin/bash
# It is generally a good idea to wrap variable expansions in double-quotes; for example, use "$var" rather than $var.
echo $HOME
echo $PATH
echo $PWD
echo $RANDOM
echo $UID
echo $PS1
echo $PS2

a="hello world"
echo $a
echo "\$USER $USER"

X=""
if [ -n $X ]; then
    echo "the variable X is not empty string"
fi

LS="ls"
LS_FLAGS="-al"

$LS $LS_FLAGS $HOME

b=hello
echo ${b}abc
