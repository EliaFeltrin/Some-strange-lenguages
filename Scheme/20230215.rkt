#lang racket
#|
Consider the following For construct, as defined in class:
(define-syntax For
(syntax-rules (from to break: do)
((_ var from min to max break: break-sym
do body ...)
(let* ((min1 min)
(max1 max)
(inc (if (< min1 max1) + -)))
(call/cc (lambda (break-sym)
(let loop ((var min1))
body ...
(unless (= var max1)
(loop (inc var 1))))))))))
Define a fix to the above definition, to avoid to introduce in the macro definition the special break symbol break-
sym, by providing a construct called break. E.g.
(For i from 1 to 10
do
(displayln i)
(when (= i 5)
(break #t)))
will return #t after displaying the numbers from 1 to 5.
|#
(define stack '())


(define-syntax For
  (syntax-rules (from to do)
    ((_ var from min to max do body ... )
     (let* ((min1 min) (max1 max) (inc (if (< min max) + -)))
       (call/cc (lambda (cc)
                  (set! stack (cons cc stack))
                  (let loop ((var min1))
                             body ...
                             (unless (= var max1)
                             (loop (inc var 1))))))))))

(define (break p)
  (let ((cc (car stack)))
    (set! stack (cdr stack))
    (cc p)))


#|(define (break p)
  ((car stack) p))
|#

(For i from 1 to 10
do
(display "i: ")
(displayln i)
(when (= i 5)
(break #t))
(For j from 1 to 10
do
(display "j: ")
(displayln j)
(when (= j 5)
(break #t))) 
)