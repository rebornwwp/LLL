fn main() {
    print_number(5);
}

const MAX_POINTS: u32 = 100_000;

fn print_number(x: i32) {
    println!("x is: {}", x);
    let (a, mut b): (bool, bool) = (true, false);
    println!("a = {:?}, b = {:?}", a, b);

    b = true;
    assert_eq!(a, b);
    println!("maxpoints = {:?}", MAX_POINTS);
    let guess: u32 = "42".parse().expect("not a number!");
    println!("maxpoints = {:?}", guess);
}
