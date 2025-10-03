#!/bin/bash
for ((c=1; c<=100; c++)); do
    for ((b=1; b<=c; b++)); do
        for ((a=1; a<=b; a++)); do
            if [[ $(($a * $a + $b * $b)) == $(($c * $c)) ]]; then
                echo $a $b $c
            fi
        done
    done
done
