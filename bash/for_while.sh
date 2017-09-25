#!/bin/bash

for i in "red" "green" "blue"
do
    echo $i
done

color1="red"
color2="green"
color3="blue"
for i in "$color1" $color2 "$color3"
do
    echo $i
done

for i in *.sh
do
    echo $i
done

for ((i=0; i<10; i++))
do
    echo $i
done

X=0
while [[ $X -lt 20 ]]
do
    echo $X
    # 自增
    X=$((X+1))
done

file=$(ls)
echo $file
