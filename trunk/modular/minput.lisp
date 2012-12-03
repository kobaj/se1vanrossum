;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;75 Chars *****************************************************************

;Team Van Rossum
;Software Engineering 1 
;defines how a file is imported for tree creation

(interface Iinput
  (sig break-on-<sr> (filename state))
  (sig extract-fields (xs))
  (sig generate-tuples (xs))
  (sig file->tuples (filename state)))

(module Minput-private
  (include-book "list-utilities" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  (set-state-ok t)
  
  ; (break-on-<sr> filename state)
  ; This function takes in a file and a state and delivers a list of
  ; lists of strings
  ; filename = string representation of the file to read
  ; state = file->string state
  (defun break-on-<sr> (filename state)
    (let* ((rawinput (car (file->string filename state)))
           (srsplit (packets "<sr>" (words rawinput))))
      (cdr srsplit)))
  
  ; (extract-fields xs)
  ; This function takes a list of strings and returns a list of three
  ; strings representing the ticker, closing price, and trading date
  ; of a particular stock record, respectively
  ; xs = list of strings representing fields in a stock record
  (defun extract-fields (xs)
    (let* ((tk (nth 0 xs))
           (cp (nth 5 xs))
           (td (nth 1 xs)))
      (cons tk (list cp td))))
  
  ; (generate-tuples xs)
  ; This function takes a list of a list of strings, where each list
  ; of strings represents a stock record, and each string is a field.
  ; It returns a list of lists of strings, in which each list of
  ; strings only contains the ticker, closing price, and trading
  ; date of the corresponding stock record, respectively
  ; xs = list of lists of strings representing stock records
  (defun generate-tuples (xs)
    (if (consp xs)
        (let* ((first (extract-fields (car xs)))
               (rest (generate-tuples (cdr xs))))
          (cons first rest))
        nil))
  
  ; (file->tuples filename state)
  ; This function takes a file and a state and returns a list of lists
  ; of strings, in which each list of strings contains the ticker,
  ; closing price, and trade date of a given stock record, respectively
  ; filename = string representation of the file to read
  ; state = file->string state
  (defun file->tuples (filename state)
    (generate-tuples (break-on-<sr> filename state)))
  
  (export Iinput)
  )

(link Minput
      (import)
      (export Iinput)
      (Minput-private))