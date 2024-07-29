# learn rust https://course.rs/basic/base-type/char-bool.html

## Common Programming Concepts

### Variable and Mutability

``` rust
// default variables are immutable
let x = 5;

// declare mutable variable
let mut y = 5;
y = 10;

// declare a constant
const MAX_POINTS: u32 = 100_000;

// patterns
let (a, b) = (1, 2);

// type annotations
let z: i32 = 5;

// scope and shadowing
fn main() {
    // 变量绑定在一个作用域中，限制在被定义的快块中，{}包含之中
    let x: i32 = 17;
    {
        let y: i32 = 3;
        println!("The value of x is {} and value of y is {}", x, y);
    }
    println!("The value of x is {} and value of y is {}", x, y); // This won't work.
}

let x: i32 = 8;
{
    println!("{}", x); // Prints "8".
    let x = 12;
    println!("{}", x); // Prints "12".
}
println!("{}", x); // Prints "8".
// 变量可以被隐藏。这意味着一个后声明的并位于同一作用域的相同名字的变量绑定将会覆盖前一个变量绑定
let x =  42;
println!("{}", x); // Prints "42".
```

## function

``` rust
// 不带参数
fn foo(){
    println!("hello world");
}

// 带参数, 参数一定要带类型
fn print_number(x: i32){
    println!("x is {}", x);
}

// 待返回值的函数
fn add_one(x: i32) -> i32 {
    // 无分号
    x+1
}
```

加上分号之后就会有错误，这揭露了关于 Rust 两个有趣的地方：它是一个基于表达式的语言，并且分号与其它基于“大括号和分号”的语言不同。这两个方面是相关的。
