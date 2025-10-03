#lang racket

5

"hello world"

(substring "the boy out of the country" 4 7)

(define (extract str)
  (substring str 4 7))

(extract "the boy out of the country")
(extract "the country out of the boy")

; the file load this file
; (load "1.rkt")
; (extract "the dog out")

