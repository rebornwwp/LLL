#lang racket

; build-in datatypes

; booleans
; #t for true and #f for false. Uppercase #T and #F are parsed as the same values, but the lowercase forms are preferred.
(= 2 (+ 1 1))
(boolean? #t)
(boolean? #f)
(boolean? "no")
(if "no" 1 0)

; numbers
; A Racket number is either exact or inexact:
; An exact number is either
; an arbitrarily large or small integer, such as 5, 99999999999999999, or -17;
; a rational that is exactly the ratio of two arbitrarily small or large integers, such as 1/2, 99999999999999999/2, or -3/4; or
; a complex number with exact real and imaginary parts (where the imaginary part is not zero), such as 1+2i or 1/2+3/4i.

; An inexact number is either
; an IEEE floating-point representation of a number, such as 2.0 or 3.14e+87, where the IEEE infinities and not-a-number are written +inf.0, -inf.0, and +nan.0 (or -nan.0); or
; a complex number with real and imaginary parts that are IEEE floating-point representations, such as 2.0+3.0i or -inf.0+nan.0i; as a special case, an inexact complex number can have an exact zero real part with an inexact imaginary part.
; #e or #i can prefix a number to force its parsing as an exact or inexact number. The prefixes #b, #o, and #x specify binary, octal, and hexadecimal interpretation of digits.

0.5
#e0.5
#i0.5
#x03BB

; convert between two types of numbers
(/ 1 2)
(/ 1 2.0)
(if (= 3.0 2.999) 1 2)
(inexact->exact 0.1)
(exact->inexact 1)
(sin 0) ; rational
(sin 1/2) ; not rational

(define (sigma f a b)
  (if (= a b)
      0
      (+ (f a) (sigma f (+ a 1) b))))

(time (round (sigma (lambda (x) (/ 1 x)) 1 2000)))
(time (round (sigma (lambda (x) (/ 1.0 x)) 1 2000)))

(integer? 1)
(rational? 1.0)
(real? 1+0i)
(complex? 1+1i)
(number? 1)
(number? 1+1i)
(abs -5)
(sin -5+2i)

; = procedure是判断数字的相等性(numerical equality)，如果给的是精确和不精确的拿来做比较，当会把不精确数字转换成精确数字然后拿来做比较
; eqv? 相反做的是(exactness and numerical equality)
(= 1 1.0)
(eqv? 1 1.0)
(eqv? 1.0 1.0)
(equal? 1 1.0)
(equal? 1 1)
(equal? 1.0 1.0)
; Beware of comparisons involving inexact numbers, which by their nature can have surprising behavior.
; 浮点数的比较要注意了,其中存在转换，转换代表了语言隐藏了某些实现细节
(= 1/2 0.5)
(= 1/10 0.1) ; 这就是在转换中存在火葬场的情况
(inexact->exact 0.1)

; charactor
(integer->char 65)
(char->integer #\A)
#\λ
(integer->char 17)
(char->integer #\space)
#\A
(display #\A)
(char-alphabetic? #\A)
(char-numeric? #\1)
(char-whitespace? #\newline)
(char-downcase #\A)

(char=? #\a #\A)
(char-ci=? #\a #\A)
(eqv? #\a #\A)

; string
"Apple"
"\u03BB"
(display "Apple")
(display "a \"quoted\" thing")
(display "two\nlines")
(display "\u03BB")

(string-ref "Apple" 0)
(define s (make-string 5 #\.))
s
(string-set! s 2 #\λ)

(string<=? "apple" "Banana")
(string-ci<=? "apple" "Banana")
(string-upcase "Strae")
(parameterize ([current-locale "C"])
  (string-locale-upcase "Strae"))

; bytes and byte strings
; a byte is an exact integer between 0 and 255
(byte? 0)
(byte? 256)
; a byte string is similar to a string. it is prefixed with a #
#"Apple"
(bytes-ref #"Apple" 0)
(make-bytes 3 65)
(define b (make-bytes 2 0))
b
(bytes-set! b 0 1)
(bytes-set! b 1 255)
b
(display #"Apple")
(display "\316\273")
(display #"\316\273")

; symbol
; For any sequence of characters, exactly one corresponding symbol is interned; calling the string->symbol procedure, or reading a syntactic identifier, produces an interned symbol. Since interned symbols can be cheaply compared with eq? (and thus eqv? or equal?), they serve as a convenient values to use for tags and enumerations.
'a
(symbol? 'a)
(string->symbol "a")
(eq? 'a 'a)
(eq? 'a (string->symbol "a"))
(eq? 'a 'b)
(eq? 'a 'A)
; Symbols are case-sensitive. By using a #ci prefix or in other ways, the reader can be made to case-fold character sequences to arrive at a symbol, but the reader preserves case by default.
#ci'A
; Whitespace or special characters can be included in an identifier by quoting them with | or \.
(string->symbol "one, two")
(string->symbol "6")
; the write functiono prints a symbol without a ' prefix. the display form of a symbol is the same as the corresponding string.
(write 'Apple)
(display 'Apple)
(write '|6|)
(display '|6|)
; The gensym and string->uninterned-symbol procedures generate fresh uninterned symbols that are not equal (according to eq?) to any previously interned or uninterned symbol.
(define ss (gensym))
ss
(eq? ss 'g4)

; keywords
; A keyword value is similar to a symbol (see Symbols), but its printed form is prefixed with #:

(string->keyword "apple")
'#:apple
(eq? '#:apple (string->keyword "apple"))

; pairs and lists
(cons 1 2)
(cons (cons 1 2) 3)
(car (cons 1 2))
(cdr (cons 1 2))
(pair? (cons 1 2))

null
(cons 0 (cons 1 (cons 2 null)))
(list? null)
(list? (cons 1 (cons 2 null)))
(list? (cons 1 2))
(write (cons 1 2))
(display (cons 1 2))
(write null)
(display null)
(write (list 1 2 "3"))
(display (list 1 2 "3"))

(map (lambda (i) (/ 1 i))
     '(1 2 3))
(andmap (lambda (i) (i . < . 3))
        '(1 2 3))
(filter (lambda (i) (i . < . 3))
        '(1 2 3))
(foldl (lambda (v i) (+ v i))
       10
       '(1 2 3))
(for-each (lambda (i) (display i))
          '(1 2 3))
(member "keys"
        '("Florida", "Keys", "U.S.A"))
(assoc 'where
       '((when "3:30") (where "Florida") (who "Mickey")))
(define p (mcons 1 2))
p
(pair? p)
(set-mcar! p 0)
(write p)

; vector
; 和list有点类似，有差别的是，vector是一个可以常数时间进行访问和更新内部数据的数据结构
#("a" "b" "c")
#(name (that tune))
#4(baldwin bruce)
(vector-ref #("a" "b" "c") 1)
(vector-ref #(name (that tune)) 1)
(vector->list #("a" "b" "c"))
(list->vector '(1 2 3))
(list->vector (map string-titlecase
                   (vector->list #("three" "bind" "mice"))))

; hash tables
(define ht (make-hash))
; set keys and values
(hash-set! ht "apple" '(red round))
(hash-set! ht "banana" '(yellow long))
(hash-ref ht "apple")
(hash-ref ht "banana")
(hash-ref ht "coconut" "not there")
(define hf (hash "apple" 'red "banana" 'yellow))
(hash-ref hf "apple")
(define hr #hash(("apple" . red)
                 ("banana" . yellow)))
(hash-ref hr "apple")

; boxes
(define b (box "apple"))
(unbox b)
(set-box! b '(banana boat))

; void and undefined
(void)
(void 1 2 3)
(list (void))

(define (fails)
  (define x x)
  x)
(fails)
