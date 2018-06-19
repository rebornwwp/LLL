# javaScript 总览
其有三部分组成
* ECMAScript 一个语言的标准
* DOM 文本对象模型
* BOM 浏览器对象模型

# 注释

``` javascript
// 这是单行注释

/*
这是多行注释
注释
*/
var x = 5;    // 这是行末注释
```

# 变量

``` javascript
var x = 1; 
var y; // y is equal to undefined.
var a = 1, b = 'hello world', c = 123; // 定义多个变量
d = 10; // 变量申明
```

# 数据类型

简单类型
* Undefined
* Null
* Boolean
* Number
* String

复杂类型
* Object
    * constructor 创建当前对象的函数
    * hasOwnProperty(propertyName) 用于检查给定的属性在当前对象实例中是否存在
    * isPrototypeOf(object) 用于检查传入的对象是否是传入对象的原型
    * propertyIsEnumerable(propertyName) 检查给定的属性是否能够使用`for-in`语句来枚举
    * toLocaleString() 返回对象的字符串表示, 该字符串与执行环境的地区对应
    * toString() 返回对象的字符串表示
    * valueOf() 返回对象的字符串, 数值或布尔值表示。通常和toString() 相同.

typeof 的出现，ECMAScript是松散类型的，所以需要用typeof来检测变量的数据类型。


``` javascript
var x = 'hello world'; // 字符串
var y = 12; //数字
var z = 123e5; // 科学计数
var a = true, b = false; // bool类型

var cars = new Array(); // 数组
cars[0] = "Saab";
cars[1] = "Volvo";
cars[2] = "BMW";
var a = Array();
var cars = new Array("Saab","Volvo","BMW");
var cars = ["Saab","Volvo","BMW"];

var person = {firstname:"John", lastname:"Doe", id:5566}; // 字典

cars = null;
person = null;

// 下面为申明变量类型
var carname = new String;
var x = new Number;
var y = new Boolean;
var cars = new Array;
var person = new Object;

// 数据类型的转换
/*
 * Number()
 * parseInt()
 * parseFloat()
 */
var num1 = Number("hello world"); // NaN
var num2 = Number(""); // 0
var num3 = Number("000011"); // 11
var num4 = Number(true); // 1

var num5 = parseInt("1234blue"); // 1234
var num6 = parseInt(""); // NaN
var num7 = parseInt("0xA"); // 10

var num8 = parseFloat("1234Blue"); // 1234
var num9 = parseFloat("22.5"); // 22.5

// 检测数据类型
person instanceof Object;
colors instanceof Array;
pattern instanceof RegExp;
```

# 函数

函数的规定

* 不能将函数命名为eval或arguments
* 不能将参数命名为eval或arguments
* 不能出现两个命名参数同名的情况

函数没有重载，如果定义两个相同名字的函数，实际运行时用的后定义的函数。
``` javascript
function myFunction() {
    alert("Hello World!");
}

function myFunction(var1,var2) {
    代码
}
// 带返回值
function myFunction() {
    var x=5;
    return x;
}

function myFunction(a,b) {
    if (a>b) {
        return;
    }
    x=a+b
}

function sayHi() {
    alert(arguments.length);
}

function factorial(num) {
    if (num <= 1) {
        return 1;
    } else {
        // arguments 保存的函数参数，其中的callee属性，是一个指针，指向拥有这个arguments对象的函数
        return num * arguments.callee(num-1);
    }
}

window.color = "red";
var o = {color: "blue"};
function sayColor() {
    alert(this.color);
}

sayColor(); // "red"
o.sayColor = sayColor;
o.sayColor(); // "blue"
```

# 运算符

``` javascript
+ - * / % ++ -- = += -= *= /= %= 
```

# 条件运算符

``` javascript
== 做数据转换
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

null == undefined; // true
null === undefined; // false

variable = boolean_expression ? true_value : false_value;

var max = (num1 > num2) ? num1 : num2;
```

# 条件语句

``` javascript
if (condition) {
    statement1;
} else {
    statement2;
}

if (time < 10) {
    x = "Good morning";
} else if (time<20) {
    x = "Good day";
} else {
    x="Good evening";
}


switch(n) {
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

``` javascript
for (语句 1; 语句 2; 语句 3) {
    被执行的代码块
}

var person = {fname:"John", lname:"Doe", age:25}; 

for (x in person) {
    txt = txt + person[x];
}

for (var i = 0; i < 10; i++) {
    alert(i);
}
alert(i); // 10 变量不存在块级作用域，循环内部的变量也可以在外部被访问.

while (condition) {
  statement;
}

do {
    x=x + "The number is " + i + "<br>";
    i++;
} while (i < 5);

var num = 0;
outermost:
for (var i = 0; i < 10; i++) {
    for (var j = 0; j < 10; j++) {
        if (i == 5 && j == 5) {
        break outermost; // 直接退出两个for循环 
        }
    }
}

var num = 0;
outermost:
for (var i = 0; i < 10; i++) {
    for (var j = 0; j < 10; j++) {
        if (i == 5 && j == 5) {
        continue outermost; // 此时不是针对内部for的continue，可是针对两个for的continue
        }
    }
}

with (location) {
    var qs = search.substring(1);
    var hostName = hostname;
    var url = href;
}

```

# 错误

``` javascript
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
# DOM

``` javascript
<div id="id" class="class" title="title"></div>

getElementById   id
getElementByTagName div
getElementByClassName class
getAttribute("title") title
setAttribute
```

