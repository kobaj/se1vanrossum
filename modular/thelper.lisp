;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;75 Chars *****************************************************************

;Team Van Rossum
;Software Engineering 1 
;helper function that builds some trees for testing

(require "mavl-string-keys.lisp")

(interface Ihelper
  (sig make-subtree())
  (sig make-different-subtree())
  (sig make-tree())
  (sig make-complex-tree()))

(module Thelper-private
  (import Iavl-string-keys)
  
  (defun make-subtree()
    (let* ((start-tree (empty-tree))
           (start-tree2 (avl-insert start-tree "20120101" "2.0"))
           (start-tree3 (avl-insert start-tree2 "20120202" "3.0"))
           (start-tree4 (avl-insert start-tree3 "20130101" "1.0")))
      start-tree4))
  
  (defun make-different-subtree()
    (let* ((start-tree (empty-tree))
           (start-tree2 (avl-insert start-tree "20090101" "2.0"))
           (start-tree3 (avl-insert start-tree2 "20090202" "3.0"))
           (start-tree4 (avl-insert start-tree3 "20080101" "1.0")))
      start-tree4))
  
  (defun make-tree ()
    (avl-insert (empty-tree) "GOOG"
                (make-subtree)))
  
  (defun make-complex-tree ()
    (let* ((first
            (avl-insert (make-tree) "AA" (make-subtree)))
           (second
            (avl-insert first "AAPL" (make-subtree))))
      second))
  
  (export Ihelper)
  )

(link Thelper
      (import Iavl-string-keys)
      (export Ihelper)
      (Thelper-private))