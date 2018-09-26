Vue.component('todo-item', {
  template: '<li>This is a todo</li>',
});

Vue.component('todo-items', {
  props: ['todos'],
  template: '<li>{{ todos.text }}</li>'
})

const app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!',
    seen: true,
    todos: [
      { text: 'learn JavaScript' },
      { text: 'learn Vue' },
      { text: 'build something awesome' },
    ],
    groceryList: [
      { id: 0, text: 'Vegetables' },
      { id: 1, text: 'Cheese' },
      { id: 2, text: 'jfkdsajfksajk' },
    ]
  },
  methods: {
    reverseMessage: function () {
      this.message = this.message.split('').reverse().join('');
    }
  }
});

app.todos.push({ text: 'learn Python' })

const app2 = new Vue({
  el: '#app-2',
  data: {
    titleMessage: '页面加载' + new Date().toLocaleString(),
  }
})

const app3 = new Vue({
  el: '#demo',
  data: {
    firstName: 'foo',
    lastName: 'Bar',
    fullName: 'foo Bar',
  },
  watch: {
    firstName: function (val) {
      this.fullName = val + ' ' + this.lastName
    },
    lastName: function (val) {
      this.fullName = this.firstName + ' ' + val
    }
  }
})

const app4 = new Vue({
  el: '#computed-setter',
  data: {
    firstName: 'Foo',
    lastName: 'Bar',
  },
  computed: {
    fullName: {
      get: function () {
        return this.firstName + ' ' + this.lastName
      },
      set: function (newValue) {
        const names = newValue.split(' ')
        this.firstName = names[0]
        this.lastName = names[1]
      }
    }
  }
})

const app5 = new Vue({
  el: '#watch-exmaple',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!',
  },
  watch: {
    question: function (newQuestion, oldQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.deBouncedGetAnswer()
    }
  },
  created: function () {
    // _.debounce is a function provided by lodash to limit how
    // often a particularly expensive operation can be run.
    // In this case, we want to limit how often we access
    // yesno.wtf/api, waiting until the user has completely
    // finished typing before making the ajax request. To learn
    // more about the _.debounce function (and its cousin
    // _.throttle), visit: https://lodash.com/docs#debounce
    this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
  },
  methods: {
    getAnswer: function () {
      if (this.question.indexOf('?') === -1) {
        this.answer = 'Questions usually contain a question mark. ;-)'
        return
      }
      this.answer = 'Thinking...'
      var vm = this
      axios.get('https://yesno.wtf/api')
        .then(function (response) {
          vm.answer = _.capitalize(response.data.answer)
        })
        .catch(function (error) {
          vm.answer = 'Error! Could not reach the API. ' + error
        })
    }
  }
})

// 对html中每个元素中的 class 进行动态绑定
const app6 = new Vue({
  el: '#html-class',
  data: {
    isActive: true,
    hasError: false,
    ok: true,
  }
})

// 列表渲染
const app7 = new Vue({
  el: '#list-render',
  data: {
    parentMessage: 'Parent',
    items: [
      { message: 'Foo' },
      { message: 'Bar' },
    ],
    object: {
      key: "helo",
      value: "world",
      index: 12,
    },
    numbers: [1, 2, 3, 4, 5, 6],
  },
  computed: {
    evenNumbers: function () {
      return this.numbers.filter(function (number) {
        return number % 2 === 0
      })
    }
  },
})