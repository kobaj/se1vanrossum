;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;75 Chars *****************************************************************

;Team Van Rossum
;Software Engineering 1 
;defines main interface with user 

;how to use this file
; execute the command (do) with three parameters
; out_html - the file name of the output html 
; in_req   - the file name of the input requirements file
; in_hist  - the file name of the ticker statistics

(require "minput.lisp")
(require "mbuild-tree.lisp")
(require "mread-sort.lisp")
(require "mcalc_slope_intercept.lisp")
(require "mhtml.lisp")

; main interface
(interface Imain
  (sig do(out_html in_req in_hist)))

; main module
(module Mmain-private
  (import Iinput)
  (import Ibuild-tree)
  (import Iread-sort)
  (import Icalc_slope_intercept)
  (import I-HTMLGenerator)
  
  (set-state-ok t)
  
  ;simply stack everything as a single command
  (defun do (out_html in_req in_hist)
    (writeHTML out_html 
               (get_list_and_slope_intercept
                (prune (read-req-file in_req)
                       (delegate-into-tree
                        (parse-input (file->tuples in_hist state))
   )))))
  
  (export Imain)
  )

; build all the correct links
(link Mmain
  (import 
          Iinput
          Ibuild-tree
          Iread-sort
          Icalc_slope_intercept
          I-HTMLGenerator
          )
  (export Imain)
  (Mmain-private))

(link Rmain
      (import)
      (export Imain)
      (  
          Minput
          Mbuild-tree
          Mread-sort
          Mcalc_slope_intercept
          M-HTMLGenerator
          Mmain))

; run
(invoke Rmain)