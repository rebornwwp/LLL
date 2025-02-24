#![allow(dead_code)]
use std::fmt::Debug;
mod two_sum;

const A_GLOBAL: i32 = 10;

fn main() {
    print_number(5);
    let somef = Some(5);
    let result = plus_one(somef);
    println!("result some: {:?}", result);
    let condition = true;
    let x = if condition { 5 } else { 6 };
    println!("result some: {:?}", x);
    let rect1 = Rectangle {
        width: 10,
        height: 2,
    };
    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
    vector_demo();
    use crate::Stage::*;
    let _stage = Advanced;
    println!("{}", Color::Red as i32);

    let outer_var = 42;
    let closure_annotated = |i: i32| -> i32 {
        let y = i + outer_var;
        y + 100
    };
    let closure_inferred = |i| i + outer_var;
    closure_annotated(10);
    closure_inferred(10);

    // A closure taking no arguments which returns an `i32`.
    // The return type is inferred.
    let one = || 1;
    one();
    let color = String::from("green");
    let print = || println!("`color`: {}", color);
    print();
    let _reborrow = &color;
    let _color_moved = color;
    let mut count = 0;
    let mut inc = || {
        count += 1;
        println!("count is: {}", count);
    };
    inc();
    inc();
    println!("result count is: {}", count);
    let _count_reborrowed = &mut count;
    println!("result count is: {}", _count_reborrowed);
    use std::mem;
    let movable = Box::new(3);
    let consume = || {
        println!("move is {:?}", movable);
        mem::drop(movable);
    };
    consume();

    let x = 7;

    // Capture `x` into an anonymous type and implement
    // `Fn` for it. Store it in `print`.
    let print = || println!("{}", x);

    apply(print);
    apply(print);
    let fn_plain = create_fn();
    let mut fn_mut = create_fnmut();
    let fn_once = create_fnonce();

    fn_plain();
    fn_mut();
    fn_once();

    fn is_odd(n: u32) -> bool {
        n % 2 == 1
    }
    let upper = 10;
    // Functional approach
    let sum_of_squared_odd_numbers: u32 = (0..)
        .map(|n| n * n) // All natural numbers squared
        .take_while(|&n_squared| n_squared < upper) // Below upper limit
        .filter(|&n_squared| is_odd(n_squared)) // That are odd
        .sum(); // Sum them
    println!("functional style: {}", sum_of_squared_odd_numbers);
    phantom_example();

    owner();
    main1();
    let xxxx = 5;
    let yyyy = xxxx.clone();
    println!("XXXXfukc {} {}", xxxx, yyyy);
}

const MAX_POINTS: u32 = 100_000;

fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

fn print_number(x: i32) {
    let _x11 = "";
    let _x11 = 123;
    println!("x is: {}", x);
    let (a, mut b): (bool, bool) = (true, false);
    println!("a = {:?}, b = {:?}", a, b);

    b = true;
    assert_eq!(a, b);
    println!("maxpoints = {:?}", MAX_POINTS);
    let guess: u32 = "42".parse().expect("not a number!");
    println!("maxpoints = {:?}", guess);
    let s1 = String::from("hello");
    let s2 = s1.clone();
    println!("x = {}, y = {}", s1, s2);
    let mut mut_x = 1;
    mut_x += 1;
    println!("mut_x {}", mut_x);
    // scope
    {
        let mut mut_x = 10;
        mut_x += 10;
        println!("scope mut_x {}", mut_x);
        let inner_x = 100;
        println!("scope inner {}", inner_x);
    }
    println!("mut_x {}", mut_x);

    let dec_x;
    dec_x = 10;
    println!("dec_x {}", dec_x);

    // freeze
    let mut _mutable_integer = 7i32;

    {
        // Shadowing by immutable `_mutable_integer`
        let _mutable_integer = _mutable_integer;

        // Error! `_mutable_integer` is frozen in this scope
        // _mutable_integer = 50;
        // FIXME ^ Comment out this line

        // `_mutable_integer` goes out of scope
    }

    // Ok! `_mutable_integer` is not frozen in this scope
    _mutable_integer = 3;

    // data cast
    let _cast_x = 128 as i16;
    let _cast_y = f32::NAN as u8;
    unsafe {
        // 300.0 as u8 is 44
        println!(" 300.0 as u8 is : {}", 300.0_f32.to_int_unchecked::<u8>());
        // -100.0 as u8 is 156
        println!(
            "-100.0 as u8 is : {}",
            (-100.0_f32).to_int_unchecked::<u8>()
        );
        // nan as u8 is 0
        println!("   nan as u8 is : {}", f32::NAN.to_int_unchecked::<u8>());
    }
}

#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

// trait
fn add<T: std::ops::Add<Output = T>>(a: T, b: T) -> T {
    a + b
}

struct Point<T, U> {
    x: T,
    y: U,
}

// interface in golang or class in haskell
pub trait Summary {
    fn summarize(&self) -> String;
}

pub struct Post {
    pub title: String,   // 标题
    pub author: String,  // 作者
    pub content: String, // 内容
}

impl Summary for Post {
    fn summarize(&self) -> String {
        format!("文章{}, 作者是{}", self.title, self.author)
    }
}

fn hello_type() {
    let a: i32 = 10;
    let b: u16 = 100;

    if a < b.into() {
        println!("Ten is less than one hundred.");
    }
}

fn vector_demo() {
    let xs: [i32; 5] = [1, 2, 3, 4, 5];
    for i in 0..xs.len() + 1 {
        match xs.get(i) {
            Some(xval) => println!("{}: {}", i, xval),
            None => println!("none"),
        }
    }
}

enum Stage {
    Beginner,
    Advanced,
}

enum Color {
    Red = 0xff0000,
    Green = 0x00ff00,
    Blue = 0x0000ff,
}

enum List {
    // Cons: Tuple struct that wraps an element and a pointer to the next node
    Cons(u32, Box<List>),
    // Nil: A node that signifies the end of the linked list
    Nil,
}

use crate::List::*;

//  Methods can be attached to an enum
impl List {
    // Create an empty list
    fn new() -> List {
        // `Nil` has type `List`
        Nil
    }

    // Consume a list, and return the same list with a new element at its front
    fn prepend(self, elem: u32) -> List {
        // `Cons` also has type List
        Cons(elem, Box::new(self))
    }

    // Return the length of the list
    fn len(&self) -> u32 {
        // `self` has to be matched, because the behavior of this method
        // depends on the variant of `self`
        // `self` has type `&List`, and `*self` has type `List`, matching on a
        // concrete type `T` is preferred over a match on a reference `&T`
        // after Rust 2018 you can use self here and tail (with no ref) below as well,
        // rust will infer &s and ref tail.
        // See https://doc.rust-lang.org/edition-guide/rust-2018/ownership-and-lifetimes/default-match-bindings.html
        match *self {
            // Can't take ownership of the tail, because `self` is borrowed;
            // instead take a reference to the tail
            Cons(_, ref tail) => 1 + tail.len(),
            // Base Case: An empty list has zero length
            Nil => 0,
        }
    }

    // Return representation of the list as a (heap allocated) string
    fn stringify(&self) -> String {
        match *self {
            Cons(head, ref tail) => {
                // `format!` is similar to `print!`, but returns a heap
                // allocated string instead of printing to the console
                format!("{}, {}", head, tail.stringify())
            }
            Nil => {
                format!("Nil")
            }
        }
    }
}

// const: An unchangeable value (the common case).
// static: A possibly mutable variable with 'static lifetime. The static lifetime is inferred and does not have to be specified. Accessing or modifying a mutable static variable is unsafe.
// Globals are declared outside all other scopes.
static LANGUAGE: &str = "Rust";
const THRESHOLD: i32 = 10;

// type alias
type NanoSecond = u64;

// `F` must implement `Fn` for a closure which takes no
// inputs and returns nothing - exactly what is required
// for `print`.
fn apply<F>(f: F)
where
    F: Fn(),
{
    f();
}

fn create_fn() -> impl Fn() {
    let text = "Fn".to_owned();

    move || println!("This is a: {}", text)
}

fn create_fnmut() -> impl FnMut() {
    let text = "FnMut".to_owned();

    move || println!("This is a: {}", text)
}

fn create_fnonce() -> impl FnOnce() {
    let text = "FnOnce".to_owned();

    move || println!("This is a: {}", text)
}

mod my_mod {
    fn private_func() {
        println!("private");
    }
    pub fn public_func() {
        private_func();
    }
    pub mod inner_mod {
        pub fn public_func() {
            println!("XXX");
        }
    }
}

struct Val {
    val: f64,
}

struct GenVal<T> {
    gen_val: T,
}

// impl of Val
impl Val {
    fn value(&self) -> &f64 {
        &self.val
    }
}

// impl of GenVal for a generic type `T`
impl<T> GenVal<T> {
    fn value(&self) -> &T {
        &self.gen_val
    }
}

fn hello_generic() {
    let x = Val { val: 3.0 };
    let y = GenVal { gen_val: 3i32 };

    println!("{}, {}", x.value(), y.value());
}

use std::marker::PhantomData;

struct A;
struct B;

// A phantom tuple struct which is generic over `A` with hidden parameter `B`.
#[derive(PartialEq)] // Allow equality test for this type.
struct PhantomTuple<A, B>(A, PhantomData<B>);

// A phantom type struct which is generic over `A` with hidden parameter `B`.
#[derive(PartialEq)] // Allow equality test for this type.
struct PhantomStruct<A, B> {
    first: A,
    phantom: PhantomData<B>,
}

fn phantom_example() {
    // Here, `f32` and `f64` are the hidden parameters.
    // PhantomTuple type specified as `<char, f32>`.
    let _tuple1: PhantomTuple<char, A> = PhantomTuple('Q', PhantomData);
    // PhantomTuple type specified as `<char, f64>`.
    let _tuple2: PhantomTuple<char, B> = PhantomTuple('Q', PhantomData);

    // Type specified as `<char, f32>`.
    let _struct1: PhantomStruct<char, A> = PhantomStruct {
        first: 'Q',
        phantom: PhantomData,
    };
    // Type specified as `<char, f64>`.
    let _struct2: PhantomStruct<char, B> = PhantomStruct {
        first: 'Q',
        phantom: PhantomData,
    };
}

#[derive(Clone, Copy)]
struct Book {
    // `&'static str` is a reference to a string allocated in read only memory
    author: &'static str,
    title: &'static str,
    year: u32,
}

// This function takes a reference to a book
fn borrow_book(book: &Book) {
    println!(
        "I immutably borrowed {} - {} edition",
        book.title, book.year
    );
}

// This function takes a reference to a mutable book and changes `year` to 2014
fn new_edition(book: &mut Book) {
    book.year = 2014;
    println!("I mutably borrowed {} - {} edition", book.title, book.year);
}
struct PointA {
    x: i32,
    y: i32,
    z: i32,
}

fn owner() {
    // store in heap
    let x = Box::new(10);
    let y = x; // move ownership, y own the x resource
               // let z = x; // error

    // store in stack
    let x1 = 32u32;
    let y1 = x1; // copy
    let y2 = x1; // copy

    let immutable_box = Box::new(5u32);
    println!("immutable_box contains {}", immutable_box);
    // Mutability error
    //*immutable_box = 4;
    // *Move* the box, changing the ownership (and mutability)
    let mut mutable_box = immutable_box;
    println!("mutable_box contains {}", mutable_box);
    // Modify the contents of the box
    *mutable_box = 4;
    println!("mutable_box now contains {}", mutable_box);

    let immutabook = Book {
        author: "hello",
        title: "world",
        year: 1979,
    };

    let mut mutabook = immutabook;
    borrow_book(&immutabook);
    borrow_book(&mutabook);
    new_edition(&mut mutabook);
    // 不可变可以被借用多次, 只读
    // 可变数据 只能被一个场景借用，可读写
    // 一个不可变数据，可以在顺序的代码逻辑中，先多次被不可变借用，如果出现一次可变借用，原始数据就不能被传入不可变参数的函数执行，
    // 如果之后使用再被不可变借用，那么之后
    let mut point = PointA { x: 0, y: 0, z: 0 };

    let borrowed_point = &point;
    let another_borrow = &point;

    // Data can be accessed via the references and the original owner
    println!(
        "Point has coordinates: ({}, {}, {})",
        borrowed_point.x, another_borrow.y, point.z
    );

    // Error! Can't borrow `point` as mutable because it's currently
    // borrowed as immutable.
    // let mutable_borrow = &mut point;
    // TODO ^ Try uncommenting this line

    // The borrowed values are used again here
    println!(
        "Point has coordinates: ({}, {}, {})",
        borrowed_point.x, another_borrow.y, point.z
    );

    // The immutable references are no longer used for the rest of the code so
    // it is possible to reborrow with a mutable reference.
    let mutable_borrow = &mut point;

    // Change data via mutable reference
    mutable_borrow.x = 5;
    mutable_borrow.y = 2;
    mutable_borrow.z = 1;

    // Error! Can't borrow `point` as immutable because it's currently
    // borrowed as mutable.
    // let y = &point.y;
    // TODO ^ Try uncommenting this line

    // Error! Can't print because `println!` takes an immutable reference.
    // println!("Point Z coordinate is {}", point.z);
    // TODO ^ Try uncommenting this line

    // Ok! Mutable references can be passed as immutable to `println!`
    println!(
        "Point has coordinates: ({}, {}, {})",
        mutable_borrow.x, mutable_borrow.y, mutable_borrow.z
    );

    // The mutable reference is no longer used for the rest of the code so it
    // is possible to reborrow
    let new_borrowed_point = &point;
    println!(
        "Point now has coordinates: ({}, {}, {})",
        new_borrowed_point.x, new_borrowed_point.y, new_borrowed_point.z
    );
}

// 一个引用必须是静态生命周期，活得跟整个进程一样久，才能被标注为 &'static。

fn main1() {
    // https://zhuanlan.zhihu.com/p/604998484
    let s1 = "Hello world";

    println!("first word of s1: {}", first(&s1)); // first word of s1: Hello

    let s1 = String::from("zhangsan");
    let s2 = String::from("lisi");

    let result = max(&s1, &s2);

    println!("bigger one: {}", result);
    const I: i32 = 5;
    print_it(I);
}

// first函数的作用：接收一个字符串引用，找到第一个单词并返回
// 下面可编译器自动解决
fn first<'a>(s: &'a str) -> &'a str {
    let trimmed = s.trim();
    match trimmed.find(' ') {
        None => "",
        Some(pos) => &trimmed[..pos],
    }
}

fn max<'a>(s1: &'a str, s2: &'a str) -> &'a str {
    if s1 > s2 {
        s1
    } else {
        s2
    }
}

fn print_it<T: Debug + 'static>(input: T) {
    println!("'static value passed in is: {:?}", input);
}
