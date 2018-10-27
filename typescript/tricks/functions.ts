// Parameter annotations

let sampleVariable: { bar: number }

// function parameter annotation
function foo(sampleParameter: { bar: number }) { }

interface Foo {
  foo: string;
}

// Return type annotated as `: Foo`
function foo1(sample: Foo): Foo {
  return sample;
}

// Optional Parameters
function foo2(bar: number, bas?: string): void {
  // ..
}

// Overloads
function padding(all: number);
function padding(topAndBottom: number, leftAndRight: number);
function padding(top: number, right: number, bottom: number, left: number);
// Actual implementation that is a true representation of all the cases the function body needs to handle
function padding(a: number, b?: number, c?: number, d?: number) {
  if (b === undefined && c === undefined && d === undefined) {
    b = c = d = a;
  }
  else if (c === undefined && d === undefined) {
    c = a;
    d = b;
  }
  return {
    top: a,
    right: b,
    bottom: c,
    left: d
  };
}
let a = <string>"123"
console.log(a)