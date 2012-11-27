; @Author Shane Moore
; modules reads in an analysis file which
; will be used to prune the tree and get the data


(include-book "io-utilities" :dir :teachpacks)
(include-book "list-utilities" :dir :teachpacks)
(set-state-ok t)
 


;So here we will pretty much have a list
;where in fact every even numbered list part
; will be the stuff we need
(defun parse-analysis-req (reqs)
  (if (consp reqs)
      (cons (cdddr (car reqs)) (parse-analysis-req (cddr reqs)))
  nil))

(defun to-search-structure (xs)
  (if (consp xs)
      (cons (chrs->str (car xs)) (to-search-structure(cdr xs)))
  nil))

(defun split-csv-style (data)
  (if (consp data)
      (cons (to-search-structure (packets #\, (car data))) 
            (split-csv-style (cdr data)))
      nil))

;TODO WRITE SOMETHING TO REMOVE ALL WHITESPACE FROM THE FILE
(defun read-file-and-prune (filename)
  (split-csv-style
   (parse-analysis-req
   (cdr(packets-set '(#\<,#\A,#\R,#\>) 
       (str->chrs (car (file->string filename state)))
       )))))

(defun prune (reqs tree)
  nil)