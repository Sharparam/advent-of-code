#lang racket

(define (sum l)
  (apply + l))

(displayln
  (sum (map string->number (file->lines "input.txt"))))
