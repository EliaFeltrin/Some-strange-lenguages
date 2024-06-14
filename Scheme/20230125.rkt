#lang racket
#|
We want to implement a for-each/cc procedure which takes a condition, a list and a body and performs a for-each.
The main difference is that, when the condition holds for the current value, the continuation of the body is stored in
a global queue of continuations. We also need an auxiliary procedure, called use-cc, which extracts and call the
oldest stored continuation in the global queue, discarding it.
E.g. if we run:

(for-each/cc odd? '(1 2 3 4) (lambda (x) (displayln x)))

two continuations corresponding to the values 1 and 3 will be store in the global queue.
Then, if we run (use-scc) we will get on screen
2
3
4
|#

(define queue '())

(define (for-each/cc cond L body)
  (for-each (lambda (x)
      (call/cc
       (lambda (cc)
         (when (cond x)
           (set! queue (append queue (list cc))))
         (body x))))
      L))
           
(define (use-scc)
  (when (cons? queue)
    (let ((cc (car queue)))
      (set! queue (cdr queue))
      (cc))))


(for-each/cc odd? '(1 2 3 4) (lambda (x) (displayln x)))

(use-scc)
(use-scc)