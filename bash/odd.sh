#!/bin/bash
for ((i=0; i<100; i++))
do
    if [[ $((i%2)) -eq 0 ]]; then
        continue
    fi
    echo $i
done
