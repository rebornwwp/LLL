#lang slideshow
(require pict/flash)
(require slideshow/code)
(require racket/class
         racket/gui/base)

; definitions
(define c (circle 10))
(define r (rectangle 10 20))

; go
5
"hello world"
(circle 100)
(rectangle 100 100)
(hc-append (circle 100) (rectangle 100 100))
(hc-append 20 c r c)

(define (square n)
  ; A semi-colon starts a line comment.
  ; The expression below is the function body.
  (filled-rectangle n n))

(square 40)

; local binding
(define (four p)
  (define two-p (hc-append p p))
  (vc-append two-p two-p))

(four (circle 10))

(define (checker p1 p2)
  (let ([p12 (hc-append p1 p2)]
        [p21 (hc-append p2 p1)])
    (vc-append p12 p21)))

(checker (colorize (square 10) "red")
         (colorize (square 10) "black"))

(define (checkerboard p)
  (let* ([rp (colorize p "red")]
         [bp (colorize p "black")]
         [c (checker rp bp)]
         [c4 (four c)])
    (four c4)))

(checkerboard (square 10))

; functions are values
circle

(define (series mk)
  (hc-append 4 (mk 5) (mk 10) (mk 20)))
(series circle)
(series (lambda (size) (checkerboard (square size))))

; lexical scope
(define (rgb-series mk)
  (vc-append
   (series (lambda (sz) (colorize (mk sz) "red")))
   (series (lambda (sz) (colorize (mk sz) "green")))
   (series (lambda (sz) (colorize (mk sz) "blue")))))

(rgb-series circle)
(rgb-series square)

(define (rgb-maker mk)
  (lambda (sz)
    (vc-append (colorize (mk sz) "red")
               (colorize (mk sz) "green")
               (colorize (mk sz) "blue"))))
(series (rgb-maker circle))

; list
(list "red" "green" "blue")

(define (rainbow p)
  (map (lambda (color)
         (colorize p color))
       (list "red" "orange" "yellow" "green" "blue" "purple")))
(rainbow (square 5))

(apply vc-append (rainbow (square 5)))

(filled-flash 40 30)

; macros
(code (circle 10))

(define-syntax pict+code
  (syntax-rules ()
    [(pict+code expr)
     (hc-append 10
                expr
                (code expr))]))

(pict+code (circle 10))

(define (add-drawing p)
  (let ([drawer (make-pict-drawer p)])
    (new canvas% [parent f]
                 [style '(border)]
                 [paint-callback (lambda (self dc)
                                   (drawer dc 0 0))])))
(add-drawing (pict+code (circle 10)))
