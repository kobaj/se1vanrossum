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
      (cons (chrs->str(car reqs)) (cddr reqs))
      )
  nil)



;TODO WRITE SOMETHING TO REMOVE ALL WHITESPACE FROM THE FILE
(defun read-file-and-prune (filename)
  (prune(parse-analysis-req(cdr(packets-set '(#\<,#\A,#\R,#\>) 
               (str->chrs
                (car (file->string "in_file.txt" state))))))))

(defun prune (reqs tree))