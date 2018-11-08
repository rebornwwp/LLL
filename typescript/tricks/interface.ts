// nterfaces have zero runtime JS impact. There is a lot of
// power in TypeScript interfaces to declare the structure of variables.
// The following two are equivalent declarations, the first
// uses an inline annotation, the second uses an interface:

// sample A
declare var myPoint: { x: number, y: number }

// sample B
interface Point {
  x: number
  y: number
}

declare var myPoint1: Point

// However, the beauty of Sample B is that if someone authors
// a library that builds on the myPoint library to add new 
// members, they can easily add to the existing declaration of myPoint

// Lib a.d.ts
interface Point2 {
  x: number
  y: number
}

declare var Point3: Point2

// Lib b.d.ts
interface Point {
  z: number
}

// your code

// classes can implement interfaces