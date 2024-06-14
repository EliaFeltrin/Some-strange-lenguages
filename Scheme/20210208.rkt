#lang racket
#|
SCHEME: 
Write a function 'depth-encode' that takes in input a list possibly containing
other lists at multiple nesting levels, and returns it as a flat list where
each element is paired with its nesting level in the original list.

E.g. (depth-encode '(1 (2 3) 4 (((5) 6 (7)) 8) 9 (((10))))) 
returns
((0 . 1) (1 . 2) (1 . 3) (0 . 4) (3 . 5) (2 . 6) (3 . 7) (1 . 8) (0 . 9) (3 . 10))
|#

(define (depth-encode List)
  (define acc '())
  (define (helper L d)
      (when (cons? L)
        (let ((x (car L)) (y (cdr L)))
          (if (list? x) 
              (helper x (add1 d))
              (set! acc (append acc (list (cons d x)))))
          (helper y d))))
  (begin
    (helper List 0)
    acc))

(depth-encode '(1 (2 3) 4 (((5) 6 (7)) 8) 9 (((10))))) 
      
          
          