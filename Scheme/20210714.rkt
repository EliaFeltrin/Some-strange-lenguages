#lang racket
#|
Define a defun construct like in Common Lisp, where (defun f (x1 x2 ...) body) is used for defining a
function f with parameters x1 x2 ....
Every function defined in this way should also be able to return a value x by calling (ret x).
|#
(define *ret-stack* '())

(define (ret x)
  ((car *ret-stack*) x))

(define-syntax defun
  (syntax-rules () ((_ f (var ...) body ...)
    (define (f var ...)
      (let ((out (call/cc (lambda (cc) 
                                        (set! *ret-stack* (cons cc *ret-stack*))
                                        body ... ))))
      (set! *ret-stack* (cdr *ret-stack*))
      out)))))

(defun test (n ok ko)
  ret ko)

(test 1 2 3)
      