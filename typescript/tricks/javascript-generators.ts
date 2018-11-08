// function * is the syntax used to create a generator function. 
// Calling a generator function returns a generator object. 
// The generator object just follows the iterator interface 

function* infiniteSequence() {
  let i = 0
  while (true) {
    yield i++
  }
}

let iterator = infiniteSequence()
while (true) {
  console.log(iterator.next())
}