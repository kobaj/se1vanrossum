(in-package "ACL2")

;(require "Mcalc_slope_intercept.lisp")
;(require "Main_module.lisp") ;this will need to be modularized
;(require "Mavl-string-keys.lisp")
;(require "Mlinear_regression_functions.lisp")

;(module Tstcalc_slope_intercept
  ;(import Icalc_slope_intercept)
  ;(import Imain_module)
  ;(include-book "testing" :dir :teachpacks)
  ;(include-book "doublecheck" :dir :teachpacks)
  
(include-book "testing" :dir :teachpacks)
(include-book "doublecheck" :dir :teachpacks)
(include-book "calc_slope_intercept")
(include-book "main-no_module")

; Test suite for avl-flatten-both
(check-expect (avl-flatten-both (make-subtree)) '(("20120101" nil)
 ("20120202" nil)
 ("20130101" nil)))
(check-expect (avl-flatten-both (make-different-subtree)) '(("20080101" nil)
 ("20090101" nil)
 ("20090202" nil)))
(check-expect (avl-flatten-both (make-tree)) '(("GOOG"
  (("20120101" . "2.0")
   ("20120202" . "3.0")
   ("20130101" . "1.0")))))
(check-expect (avl-flatten-both (make-complex-tree))
              '(("AA"(("20120101" . "2.0") ("20120202" . "3.0") ("20130101" . "1.0")))
                ("AAPL" (("20120101" . "2.0") ("20120202" . "3.0") ("20130101" . "1.0")))
                ("GOOG" (("20120101" . "2.0") ("20120202" . "3.0") ("20130101" . "1.0")))))

; Test suite for build-total-date-tree
(check-expect (build-total-date-tree (avl-flatten-both (make-tree)))
              '(2 "20120202" 3 (1 "20120101" 2 nil nil) (1 "20130101" 1 nil nil)))
(check-expect (build-total-date-tree (avl-flatten-both (make-complex-tree)))
              '(2 "20120202" 9 (1 "20120101" 6 nil nil) (1 "20130101" 3 nil nil)))

; Test suite for get_xs
(check-expect (get_xs (build-total-date-tree (avl-flatten-both (make-tree))) 1)
              '(1 2 3 4 5))
(check-expect (get_xs (build-total-date-tree (avl-flatten-both (make-complex-tree))) 1)
              '(1 2 3 4 5))
(check-expect (get_xs (avl-flatten (build-total-date-tree (avl-flatten-both (make-tree)))) 1)
              '(1 2 3))
(check-expect (get_xs (avl-flatten (build-total-date-tree (avl-flatten-both (make-complex-tree)))) 1)
              '(1 2 3))

; Test suite for get_ys
(check-expect (get_ys (avl-flatten (build-total-date-tree (avl-flatten-both (make-tree)))))
              '(2 3 1))
(check-expect (get_ys (avl-flatten (build-total-date-tree (avl-flatten-both (make-complex-tree)))))
              '(6 9 3))