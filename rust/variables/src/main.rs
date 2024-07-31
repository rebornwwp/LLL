#![allow(dead_code)]

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
}

const MAX_POINTS: u32 = 100_000;

fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

fn print_number(x: i32) {
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
