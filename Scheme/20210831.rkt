#lang racket
#|
1) Define a procedure which takes a natural number n and a default value, and creates a n by n matrix
filled with the default value, implemented through vectors (i.e. a vector of vectors).
|#

(define (create-matrix n d)
  (define vec (make-vector n #f))
    (let loop ((i 0))
      (if (= i n)
          vec
          (begin
            (vector-set! vec i (make-vector n d))
      (loop (add1 i))))))

(define v (create-matrix 3 5))
v


#|
2) Let S = {0, 1, ..., n-1} x {0, 1, ..., n-1} for a natural number n. Consider a n by n matrix M, stored in a
vector of vectors, containing pairs (x,y) ∈ S, as a function from S to S (e.g. f(2,3) = (1,0) is represented
by M[2][3] = (1,0)). Define a procedure to check if M defines a bijection (i.e. a function that is both
injective and surjective).
|#

(define (bij? m)
  (define l (vector-length m))
  (define seen (create-matrix l #f))
  (call/cc (lambda (exit)
             (let extloop ((i 0))
               (when (< i l)
                 (let inloop ((j 0))
                   (when (< j l)
                     (let ((tuple (vector-ref (vector-ref m i) j)))
                     (if (vector-ref (vector-ref seen (car tuple)) (cadr tuple)) 
                       (exit #f)
                       (vector-set! (vector-ref seen (car tuple)) (cadr tuple) #t)))
                     (inloop (add1 j))))
               (extloop (add1 i))))
           #t)))

(define test (create-matrix 2 #f))
(vector-set! (vector-ref test 0) 0 (list 0 0))
(vector-set! (vector-ref test 0) 1 (list 0 1))
(vector-set! (vector-ref test 1) 0 (list 1 0))
(vector-set! (vector-ref test 1) 1 (list 1 1))
test

(bij? test)
