# 注释
```
// 这是单行注释

/*
这是多行注释
注释
*/
var x=5;    // 这是行末注释
```

# 变量
```
var x = 1; 
var y; //y is equal to undefined.
vat a=1, b='hello world', c=123; // 定义多个变量
```

# 数据类型
```
var x='hello world'; // 字符串
var y=12; //数字
var z=123e5; // 科学计数
var a=true, b=false; // bool类型

var cars=new Array(); // 数组
cars[0]="Saab";
cars[1]="Volvo";
cars[2]="BMW";
var cars=new Array("Saab","Volvo","BMW");
var cars=["Saab","Volvo","BMW"];

var person={firstname:"John", lastname:"Doe", id:5566}; // 字典

cars=null;
person=null;

// 下面为申明变量类型
var carname=new String;
var x=      new Number;
var y=      new Boolean;
var cars=   new Array;
var person= new Object;
```

# 函数
```
function myFunction()
{
alert("Hello World!");
}

function myFunction(var1,var2)
{
代码
}
// 带返回值
function myFunction()
{
var x=5;
return x;
}

function myFunction(a,b)
{
if (a>b)
  {
  return;
  }
x=a+b
}
```
# 运算符
```
+ - * / % ++ -- = += -= *= /= %= 
```

# 条件运算符
```
==
=== 绝对相等
!=
!==
>
<
>=
<=

条件运算符

&&
||
!
```
# 条件语句
```
if (time<10)
  {
  x="Good morning";
  }
else if (time<20)
  {
  x="Good day";
  }
else
  {
  x="Good evening";
  }


switch(n)
{
case 1:
  执行代码块 1
  break;
case 2:
  执行代码块 2
  break;
default:
 n 与 case 1 和 case 2 不同时执行的代码
}
```

# 循环
```
for (语句 1; 语句 2; 语句 3)
  {
  被执行的代码块
  }

var person={fname:"John",lname:"Doe",age:25}; 

for (x in person)
  {
  txt=txt + person[x];
  }

while (条件)
  {
  需要执行的代码
  }

do
  {
  x=x + "The number is " + i + "<br>";
  i++;
  }
while (i<5);
```

# 错误
```
try
  {
  //在这里运行代码
  }
catch(err)
  {
  //在这里处理错误
  }

throw exception
```
# 

