# sed

## basic

### basic use
```
sed SCRIPT INPUTFILE...

# example 
sed 's/hello/world/' input.txt > output.txt

# equivalent
sed 's/hello/world/' input.txt > output.txt
sed 's/hello/world/' < input.txt > output.txt
cat input.txt | sed 's/hello/world/' - > output.txt
```

### inplace use

```
# use in mac-os
sed -i 'something' 's/hello/halo/' input.txt output.txt # something，备份文件后缀，inplace编辑的时候，需要注意
```

### map function to every line
the form is [address[,address]]function[arguments], （前两个代表位置(address),后面函数(function)，及其函数相关的参数）
```
# print the 45th line, 45 stands for line number, 'p' stands for print function
sed -n '45p' file.txt
```
### example
```
sed 's/hello/world/' input.txt > output.txt

# e is expression
sed -e 's/hello/world/' input.txt > output.txt
sed --expression='s/hello/world/' input.txt > output.txt

# f - file 在文件中写流处理
echo 's/hello/world/' > myscript.sed
sed -f myscript.sed input.txt > output.txt
sed --file=myscript.sed input.txt > output.txt
```
## sed script overview
```
# syntax
[addr]X[options] addr表示文件中需要处理行位置，X代表我们对这些行做的处理，option：are used for some sed commands.
# eg:
sed '30,35d' input.txt > output.txt
# description: The example deletes lines 30 to 35 in the input. 30,35 is an address range. d is the delete command:
```






