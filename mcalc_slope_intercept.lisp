;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;75 Chars *****************************************************************

(in-package "ACL2")

(require "Icalc_slope_intercept.lisp")
(require "Mavl-string-keys.listp")
(require "Mlinear_regression_functions.lisp")

(module Mcalc_slope_intercept
  (import Iavl-string-keys)
  (import Ilinear_regression_functions)
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  (set-state-ok t)

(defun avl-flatten-both (tr)  ; delivers all key/data cons-pairs
  (if (empty-tree? tr)        ; with keys in increasing order
      nil                     ; and datum is also a flattened tree
      (append (avl-flatten-both (left tr))
              (list (cons (key tr) (list (avl-flatten (data tr)))))
              (avl-flatten-both (right tr)))))

(defun build-total-child-helper (flat-sub-tree return-tree)
  (if (consp flat-sub-tree)
     (let* ((key_date  (caar flat-sub-tree))
            (key_value (cdar flat-sub-tree))
            (old_tree  (avl-retrieve return-tree key_date))
            (old_value (cdr old_tree))
            (new-return-tree
     (if (equal old_tree nil)
         (avl-insert return-tree key_date (str->rat key_value))
         (avl-insert (avl-delete return-tree key_date) key_date (+ old_value (str->rat key_value)))
         )))
       (build-total-child-helper (cdr flat-sub-tree) new-return-tree))
           return-tree))

(defun build-total-helper (flat-tree return-tree)
  (if (consp flat-tree)
      (let* ((key_ticker (caar flat-tree))
             (date_list  (cadar flat-tree))
             (new-return (build-total-child-helper date_list return-tree)))
        (build-total-helper (cdr flat-tree) new-return)
        )
            return-tree))

;spits out a tree where the datum are total ints of all keys
;and the keys are string dates
(defun build-total-date-tree (flat-tree)
  (build-total-helper flat-tree (empty-tree)))
 
(defun get_xs (flat_dates_values number)
  (if (consp flat_dates_values)
      (cons number (get_xs (cdr flat_dates_values) (+ 1 number)))
      nil))

(defun get_ys (flat_dates_values)
  (if (consp flat_dates_values)
      (cons (cdar flat_dates_values) (get_ys (cdr flat_dates_values)))
      nil))

;this is the method to call
(defun get_list_and_slope_intercept (pruned_tree)
  (let* ((flat_dates_values
          (avl-flatten (build-total-date-tree (avl-flatten-both pruned_tree))))
         (xs (get_xs flat_dates_values 1))
         (ys (get_ys flat_dates_values))
         (b_a (compute_slope_intercept xs ys)))
    (list flat_dates_values b_a)))
  
  (export Icalc_slope_intercept))