* 括号“ [ ]”，“括号” ( )“，”管道“ |”和省略号“ ...”来描述可选的，必需的，互斥的和重复的 元素。一起，这些元素形成有效的使用模式，每个都以程序的名字开头naval_fate。
* 在使用模式下面，有一个包含说明的选项列表。它们描述一个选项是否具有short / long形式（-h，--help），一个选项是否有一个参数（--speed=<kn>），以及该参数是否具有默认值（[default: 10]）。


## usage

命令行的模板

```
Usage:
  my_program command --option <argument>
  my_program [<optional-argument>]
  my_program --another-option=<with-argument>
  my_program (--either-that-option | <or-this-argument>)
  my_program <repeating-argument> <repeating-argument>...
```

## argument

以`<>`包围的参数

```
Usage: my_program <host> <port>
```

## option

以一个或两个破折号开头的单词（除了“ -”，“ --”本身）分别被解释为短（一个字母）或长选项。

* 短选项可以“堆叠”的意思-abc相当于  -a -b -c。
* 长选项可以在空格或等号“ =” 之后指定参数： --input=ARG相当于--input ARG。
* 短选项可以在可选空格之后指定参数：-f FILE相当于-fFILE。


## command
不满足上面argument，option的都是命令
### [optional elements]
```
Usage: my_program [command --option <argument>]
```
### (required elements)
除了在`[]`中的元素，其他用其他符号包含的参数都是需要参数的。
```
Usage: my_program (--either-this <and-that> | <or-this>)
```
### element|another
管道符
```
Usage: my_program go (--up | --down | --left | --right)
```
### element...
```
Usage: my_program open <file>...
       my_program move (<from> <to>)...

# One or more arguments:
Usage: my_program <file>...

# Two or more arguments:
Usage: my_program <file> <file> ...
```
### [options]
"[options]" is a shortcut that allows to avoid listing all options (from list of options with descriptions) in a pattern.
```
Usage: my_program [options] <path>

--all             List everything.
--long            Long output.
--human-readable  Display in human-readable format.

# this is equivalent to 
Usage: my_program [--all --long --human-readable] <path>

--all             List everything.
--long            Long output.
--human-readable  Display in human-readable format.

Usage: my_program [-alh] <path>

-a, --all             List everything.
-l, --long            Long output.
-h, --human-readable  Display in human-readable format.
```


例子可在github上面官方库看到。
