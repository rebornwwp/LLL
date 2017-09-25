#!/bin/bash
X=3
Y=4
empty_string=""

if [ $X -lt $Y ]; then
    echo "$X=${X},which is less than $Y=${Y}"
fi

if [ -n "$empty_string" ]; then
    echo "it is a empty string"
fi

if [ a = a ]; then
    echo yes
fi

# equivalent to

[[ -e source.txt ]] && cp source.txt destination.txt

if [[ -e source.txt ]]; then
    cp source.txt destination.txt
fi
