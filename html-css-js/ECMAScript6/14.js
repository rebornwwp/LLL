// Promise 是异步编程的一种解决方案，比传统的解决方案——回调函数和事件——更合理和更强大。它由社区最早提出和实现，ES6 将其写进了语言标准，统一了用法，原生提供了Promise对象。

// 所谓Promise，简单说就是一个容器，里面保存着某个未来才会结束的事件（通常是一个异步操作）的结果。从语法上说，Promise 是一个对象，从它可以获取异步操作的消息。Promise 提供统一的 API，各种异步操作都可以用同样的方法进行处理。


// 特点 无副作用，真正的函数式
// 对象的状态不受外界影响。Promise对象代表一个异步操作，有三种状态：pending（进行中）、fulfilled（已成功）和rejected（已失败）
// 一旦状态改变，就不会再变，任何时候都可以得到这个结果。Promise对象的状态改变，只有两种可能：从pending变为fulfilled和从pending变为rejected。

// 基本用法
const promise = new Promise(function (resolve, reject) {
    // ... some code

    if (true/* 异步操作成功 */) {
        resolve(value);
    } else {
        reject(error);
    }
});
// Promise构造函数接受一个函数作为参数，该函数的两个参数分别是resolve和reject。它们是两个函数，由 JavaScript 引擎提供，不用自己部署。

// resolve函数的作用是，将Promise对象的状态从“未完成”变为“成功”
// （即从 pending 变为 resolved），在异步操作成功时调用，并将异步操
// 作的结果，作为参数传递出去；reject函数的作用是，将Promise对象的状
// 态从“未完成”变为“失败”（即从 pending 变为 rejected），在异步操作
// 失败时调用，并将异步操作报出的错误，作为参数传递出去。

// Promise实例生成以后，可以用then方法分别指定resolved状态和rejected状态的回调函数。

promise.then(function (value) {
    // sucess
}, function (error) {
    // failure
});

function timeout(ms) {
    return new Promise((resolve, reject) => {
        setTimeout(resolve, ms, 'done');
    });
}

timeout(100).then((value) => {
    console.log(value);
});

// 异步加载图片的例子。
function loadImageAsync(url) {
    return new Promise(function (resolve, reject) {
        const image = new Image();

        image.onload = function () {
            resolve(image);
        };

        image.onerror = function () {
            reject(new Error('Could not load image at ' + url));
        };
        image.src = url;
    });
}

// Promise 实例具有then方法，也就是说，then方法是定义在原型对象Promise.prototype上的。它的作用是为 Promise 实例添加状态改变时的回调函数。前面说过，then方法的第一个参数是resolved状态的回调函数，第二个参数（可选）是rejected状态的回调函数。

// 采用链式的then，可以指定一组按照次序调用的回调函数。

// Promise.prototype.catch() Promise.prototype.catch方法是.then(null, rejection)的别名，用于指定发生错误时的回调函数。
promise.then(() => { }).catch(() => { });

// 写法比较
// bad
promise
    .then(function (data) {
        // success
    }, function (err) {
        // error
    });

// good
promise
    .then(function (data) { //cb
        // success
    })
    .catch(function (err) {
        // error
    });

// Promise.prototype.finally() finally方法用于指定不管 Promise 对象最后状态如何，都会执行的操作。该方法是 ES2018 引入标准的。
promise
    .then(result => { })
    .catch(error => { })
    .finally(() => { });

// Promise.all()
// Promise.all方法用于将多个 Promise 实例，包装成一个新的 Promise 实例
// Promise.race() Promise.race方法同样是将多个 Promise 实例，包装成一个新的 Promise 实例。只要p1、p2、p3之中有一个实例率先改变状态，p的状态就跟着改变。
// Promise.resolve() 有时需要将现有对象转为 Promise 对象，Promise.resolve方法就起到这个作用。
// romise.reject() Promise.reject(reason)方法也会返回一个新的 Promise 实例，该实例的状态为rejected
// Promise.try() 实际开发中，经常遇到一种情况：不知道或者不想区分，函数f是同步函数还是异步操作，但是想用 Promise 来处理它。因为这样就可以不管f是否包含异步操作，都用then方法指定下一步流程，用catch方法处理f抛出的错误。一般就会采用下面的写法。
Promise.resolve().then(f) // 缺点，就是如果f是同步函数，那么它会在本轮事件循环的末尾执行。

const f = () => console.log('now');
Promise.resolve().then(f);
console.log('next'); // 上面代码中，函数f是同步的，但是用 Promise 包装了以后，就变成异步执行了。

// 让同步函数同步执行，异步函数异步执行，并且让它们具有统一的 API 呢？回答是可以的，并且还有两种写法。第一种写法是用async函数来写。

// 让一个函数具有异步和同步两种形式
const f = () => console.log('now');
(async () => f())(); // 一个立即执行的匿名函数，会立即执行里面的async函数，因此如果f是同步的，就会得到同步的结果；如果f是异步的，就可以用then指定下一步
console.log('next');
// async () => f()会吃掉f()抛出的错误。所以，如果想捕获错误，要使用promise.catch方法。