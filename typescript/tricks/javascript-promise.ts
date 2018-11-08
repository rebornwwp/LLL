Promise.resolve(123)
  .then((res) => {
    console.log(res); // 123
    return 456;
  })
  .then((res) => {
    console.log(res); // 456
    return Promise.resolve(123); // Notice that we are returning a Promise
  })
  .then((res) => {
    console.log(res); // 123 : Notice that this `then` is called with the resolved value
    return 123;
  })

function loadItem(id: number): Promise<{ id: number }> {
  return new Promise((resolve) => {
    console.log("loading item", id)
    setTimeout(() => {
      resolve({ id: id })
    }, 1000)
  });
}
let item1, item2;
loadItem(1)
  .then((res) => {
    item1 = res
    return loadItem(2)
  })
  .then((res) => {
    item2 = res
    console.log('done')
  })

// Parallel
Promise.all([loadItem(1), loadItem(2)])
  .then((res) => {
    [item1, item2] = res
    console.log('done')
  })

// converting callback functions to promise
const delay = (ms: number) => new Promise(res => setTimeout(res, ms))
