;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;75 Chars *****************************************************************

;Team Van Rossum
;Software Engineering 1 
;Testing for the HTML generator

(require "mhtml.lisp")

(module T-HTMLGenerator-private
  (import I-HTMLGenerator)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  ;check expects
  (check-expect (regressionList '(1 2 3 4)  2 3) '(5 7 9 11))
  (check-expect (regressionList '()  2 3) nil)
  (check-expect (regressionList '(1 2 3 4 5)  0 0) '(0 0 0 0 0))
  )

(link T-HTMLGenerator
      (M-HTMLGenerator T-HTMLGenerator-private))

(invoke T-HTMLGenerator)