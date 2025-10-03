#!/bin/bash

echo $(( 12 ))        # use the default of base ten (decimal)
echo $(( 10#12 ))     # explicitly specify base ten (decimal)
echo $(( 2#1100 ))    # base two (binary)
echo $(( 8#14 ))      # base eight (octal)
echo $(( 16#C ))      # base sixteen (hexadecimal)
echo $(( 8 + 2#100 )) # eight in base ten (decimal), plus four in base two (binary)
