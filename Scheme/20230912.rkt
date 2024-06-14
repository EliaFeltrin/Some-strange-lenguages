#lang racket
#|
1. Design a construct to define multiple functions with the same number of arguments at the same time. The
proposed syntax is the following:
(multifun <list of function names> <list of parameters> <list of bodies>).
E.g. (multifun (f g) (x)
((+ x x x)
(* x x)))
defines the two functions f with body (+ x x x) and g with body (* x x), respectively.
|#
(define-syntax multifun
  (syntax-rules ()
    ((_ (f) (params ...) (body))
     (define (f params ...) body))
    ((_ (f . fs) (params ...) (body . bodies))
     (begin
       (define (f params ...) body)
       (multifun fs (params ...) bodies)))))

(multifun (f g) (x)
((+ x x x)
(* x x)))

(f 3)
(g 3)

#|
2. Would be possible to define something similar, but using a procedure and lambda functions instead of a
macro? If yes, do it; if no, explain why.
|#

#|It coul be ppssible to use lambdas, but in this case the scope of the so defined functions wuoldn't be the top level one, so the answer is no.|# 

