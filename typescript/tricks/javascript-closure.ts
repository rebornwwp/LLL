// A function in JavaScript has access to any variables defined in the outer scope. 
// It allows you to compose objects easily e.g. the revealing module pattern:
function createCounter() {
  let val = 0
  return {
    increament() { val++ },
    getVal() { return val }
  }
}

let counter = createCounter()
counter.increament()
counter.increament()
console.log(counter.getVal())