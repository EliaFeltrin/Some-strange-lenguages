#lang racket
#|
Define a let** construct that behaves like the standard let*, but gives to variables provided without a binding the
value of the last defined variable. It also contains a default value, stated by a special keyword def:, to be used if the
first variable is given without binding.
For example:
(let** def: #f
(a (b 1) (c (+ b 1)) d (e (+ d 1)) f)
(list a b c d e f))
should return '(#f 1 2 2 3 3), because a assumes the default value #f, while d = c and f = e.
|#

(define-syntax let**
  (syntax-rules (def:)
    ((_ def: def-v (var) body ...)
     ((lambda (var) body ...) def-v))
    ((_ def: def-v ((var val)) body ...)
     ((lambda (var) body ...) val))
    ((_ def: def-v ((var val) . rest) body ...)
     ((lambda (var) (let** def: val rest body ...)) val))
    ((_ def: def-v (var . rest) body ...)
     ((lambda (var) (let** def: def-v rest body ...)) def-v))
    ))

(let** def: #f
(a (b 1) (c (+ b 1)) d (e (+ d 1)) f)
(list a b c d e f))