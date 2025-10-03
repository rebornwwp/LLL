#lang racket

; number
1
3.14
1/2
6.02e+23
1+2i
99999999999999999

; boolean and all non-#f values are treated as true
#t
#f

; string, string are written between doublequotes
"Hello, world!"
"Benjamin \"Bugsy\" Siegel"
"λx:x.x"

; definitions 函数定义中最后一行表达式是函数返回的值
(define pie 3)
(define (piece str)
  (substring str 0 pie))

pie
piece
(piece "key lime")

(define (bake flavor)
  (printf "preheating oven...\n")
  (string-append flavor " pie"))

(bake "apple")

(define (nobake flavor)
  string-append flavor "jello")

(nobake "green")

; function calls

(string-append "rope" "twine" "yarn")
(substring "corduroys" 0 4)
(string-length "shoelace")
(string? "ceci n'est pas une string")
(string? 1)
(sqrt 16)
(+ 2 2)
(- 2 1)
(< 2 1)
(>= 2 1)
(number? "hello world")
(number? 1)
(equal? 6 6)
(equal? "half dozen" "half dozen")

; conditionals with if and or cond
(if (> 2 3)
    "bigger"
    "smaller")

(define (reply s)
  (if (equal? "hello" (substring s 0 5))
      "hi!"
      "huh?"))
(reply "hello racket")
(reply "racket hello")

(define (replys s)
  (if (string? s)
      (if (equal? "hello" (substring s 0 5))
          "hi!"
          "huh?")
      "huh?"))

(define (replyss s)
  (if (and (string? s)
           (>= (string-length s) 5)
           (equal? "hello" (substring s 0 5)))
      "hi!"
      "huh?"))

(replyss "hello racket")

(define (reply-more s)
  (cond
    [(equal? "hello" (substring s 0 5))
     "hi!"]
    [(equal? "goodbye" (substring s 0 7))
     "bye!"]
    [(equal? "?" (substring s 0 1))
     "I don't know"]
    [else "huh?"]))

(reply-more "hello racker")
(reply-more "goodbye cruel world")
(reply-more "what is your favourite color")
(reply-more "mine is lime green")

(define (double v)
  ((if (string? v) string-append +) v v))

(double "hello")
(double 5)

; anonymous functions with lambda
(define a 1)
(define b 2)
(+ a b)

(define (twice f v)
  (f (f v)))

(twice sqrt 16)

(twice (lambda (s) (string-append s "?!"))
       "hello")

(define louder
  (lambda (s)
    (string-append s "!")))

; local binding with define let and let*
(define (converse s)
  (define (starts? s2) ; local to converse
    (define len2 (string-length s2)) ; local to starts
    (and (>= (string-length s) len2)
         (equal? s2 (substring s 0 len2))))
  (cond
    [(starts? "hello") "hi!"]
    [(starts? "goodbye") "bye!"]
    [else "huh?"]))

(converse "hello")
(converse "urp")

; let 绑定值，是不能在其他绑定中复用的
(let ([x (random 4)]
      [o (random 4)])
  (cond
    [(> x o) "X wins"]
    [(> o x) "O wins"]
    [else "cat's game"]))

; let* 绑定值，是可以在其他绑定中复用的
(let* ([x (random 4)]
       [o (random 4)]
       [diff (number->string (abs (- x o)))])
  (cond
    [(> x o) (string-append "X wins by " diff)]
    [(> o x) (string-append "O wins by " diff)]
    [else "cat's game"]))

; list
(list "red" "green" "blue")

(define l (list "hop" "skip" "jump"))
(length l) ; count the elements
(list-ref l 0) ; extract by position
(list-ref l 1)
(append l (list "jumps")) ; combine lists
(reverse l) ; reverse order
(member "fall" l) ; check for an element

; redefined list loops
(map sqrt (list 1 4 9 16))
(map (lambda (i)
       (string-append i "!"))
     (list "peanuts" "popcorn" "crackerjack"))
(andmap string? (list "a" "b" "c"))
(andmap string? (list "a" "b" 6))
(ormap number? (list "a" "b" 6))

; like zipMap in haskell
(map (lambda (s n) (substring s 0 n))
     (list "peanuts" "popcorn" "crackerjack")
     (list 6 3 7))

(filter string? (list "a" "b" 6))
(filter positive? (list 1 -2 6 7 0))

(foldl (lambda (elem v)
         (+ v (* elem elem)))
       0
       '(1 2 3))

; list iteration from scratch

; first: get the first thing in the list
; rest: get the rest of the list
(first '(1 2 3))
(rest '(1 2 ))
empty
(cons "head" empty)
(cons "dead" (cons "head" empty))
(empty? empty)
(empty? (cons "head" empty))
(cons? empty)
(cons? (cons "head" empty))

(define (my-length lst)
  (cond
    [(empty? lst) 0]
    [else (+ 1 (my-length (rest lst)))]))

(my-length empty)
(my-length (list "a" "b" "c"))

(define (my-map f lst)
  (cond
    [(empty? lst) empty]
    [else (cons (f (first lst)) (my-map f (rest lst)))]))

(my-map string-upcase (list "ready" "set" "go"))

; tail recursion
(define (my-length-tail lst)
  ; local function iter
  (define (iter lst len)
    (cond
      [(empty? lst) len]
      [else (iter (rest lst) (+ len 1))]))
  (iter lst 0))

(my-length-tail '(1 2 3 4 5))

; this pattern has been defined in 'for/list'
(define (my-map-tail f lst)
  (define (iter lst backward-result)
    (cond
      [(empty? lst) (reverse backward-result)]
      [else (iter (rest lst)
                  (cons (f (first lst))
                        backward-result))]))
  (iter lst empty))

(my-map-tail (lambda (i) (* i 2))
             '(1 2 3 4 5))

; recursion versus iteration
(define (remove-dups l)
  (cond
    [(empty? l) empty]
    [(empty? (rest l)) l]
    [else
     (let ([i (first l)])
       (if (equal? i (first (rest l)))
           (remove-dups (rest l))
           (cons i (remove-dups (rest l)))))]))

(remove-dups '("a" "b" "c" "b" "b" "b"))

; paris list and racket syntax
; cons的第二个参数不是一个list的时候，组合之后的结果是一个pair
(cons 1 2)
(cons "banana" "split")

(car (cons 1 2))
(cdr (cons 1 2))
(pair? empty)
(pair? (cons 1 2))
(pair? (list 1 2 3))

(car (cons (list 1 2) 3))
(cons 1 (list 2 3))

; Quoting Pairs and Symbols with quote
(list (list 1) (list 2 3) (list 4 5))
(quote ("red" "green" "blue"))
(quote ((1) (2 3) (4)))

; the intrinsic value of a symbol is nothing more than its
; character content. In this sense, symbols and strings
; are almost the same thing, and the main difference is
; how they print. The functions symbol->string and string->symbol
; convert between them.

(quote jane-doe) ; A value that prints like a quoted identifier is a symbol
(quote (1 . 2))
(quote (0 . (1 . 2)))
(list (list 1 2 3) 5 (list "a" "b" "c"))
(quote ((1 2 3) 5 (list "a" "b" "c")))
; quote is '
'(1 2 3)
'(1 . 2)
(quote (1 . 2))
(quote (1 . (2 . 3)))

map
(quote map)
(symbol? (quote map))
(symbol? map)
(procedure? map)
(string->symbol "map")
(symbol->string (quote map))

(car (quote (road map)))
(symbol? (car (quote (road map))))

; The quote form has no effect on a literal expression such as a number or string:
(quote 43)
(quote "hello world")

; Abbreviating quote with '
'(1 2 3)
'road
'((1 2 3) road ("a" "b" "c"))

; The syntax of Racket is not defined directly in terms of character streams. Instead, the syntax is determined by two layers:
; a reader layer, which turns a sequence of characters into lists, symbols, and other constants; and
; an expander layer, which processes the lists, symbols, and other constants to parse them as an expression.
; The rules for printing and reading go together.
; 看了文档，quote一个东西之后，打印出来的东西，应该就是read layer，和expander layer解析出来的表达式，其中dot notation有点类似
; haskell中将所有的东西规定函数，并且函数和可以如同闭包一样的一个一个传入的函数(可能理解有误，会好好修改的)
(+ 1 . (2))
(1 . < . 2)
'(1 . < . 2)
'('(1 . <) 2)
