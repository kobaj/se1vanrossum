; @Author Shane Moore
; modules reads in an analysis file which
; will be used to prune the tree and get the data


(include-book "io-utilities" :dir :teachpacks)
(include-book "list-utilities" :dir :teachpacks)
(include-book "avl-string-keys")
(set-state-ok t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DATE SHIZNIT;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun check-day (date)
  (if (equal 31 (dgts->int (subseq (int->dgts date) 6 8)))
      t
      nil))
      
(defun fmt-date-helper (year mnth day)
  (if (equal 12 mnth)
      (append (int->dgts (1+ year)) '(0 1 0 1))
   (if (< mnth 9)
   (append (int->dgts year) (cons 0 (int->dgts (1+ mnth)))  '(0 1))    
   (append (int->dgts year) (int->dgts (1+ mnth))  '(0 1)))))
  
(defun fmt-date (date)
  (let* ((date-dgts  (int->dgts date))
         (mnth (dgts->int (subseq date-dgts 4 6)))
         (day (dgts->int (subseq date-dgts 6 8)))
         (year (dgts->int (subseq date-dgts 0 4))))
         (dgts->int (fmt-date-helper year mnth day))))

;;;;;;;;;;;;;;;;;;;;;;;;NOW TO GET THE CRAP OUTTA TREE;;;;;;;;;;;;;;;;;;;;;;;;

;Gets the start
(defun get-start (start tree)
  (if (equal (avl-retrieve tree start) nil)
     (get-start tree (1+ start))
     (avl-retrieve start tree)))

; Not really going to be used for this project
; Gets the last date listed in subtree
(defun get-end (end tree)
  (if (equal (avl-retrieve tree end) nil)
     (get-end (1- end) tree )
     (avl-retrieve end tree)))


; Function inserts the date and data into
; the new tree for output to html
(defun get-by-dates-helper (date-in tree ret-tree)
  (let* ((date date-in)
         (old-tree (avl-retrieve tree date)))
  (if (old-tree)
      (avl-insert ret-tree date (cdr old-tree)) ;insert data into new tree
      ret-tree)))
  

; Searching subtree for the corret dates
; First check if we have matched the start 
; make sure date format is correct
(defun get-by-dates (start end tree ret-tree)
    (if (equal start end)
        nil
        (let* ((start-date (if (check-day start) 
                               (fmt-date start)
                               (start))))
           (get-by-dates (1+ start-date) end tree 
             (get-by-dates-helper start-date tree ret-tree)))))

       
; After the retrieval file is parsed
; Prepare the data to search the tree
; Once the correct ticker name is found
(defun prune (reqs tree)
  (if (consp reqs)
      (let* ((ticker (car reqs))
             (start (cadr reqs))
             (end (caddr reqs)))
      (if (equal nil (avl-retrieve tree ticker))
          nil
          (get-by-dates start end (avl-retrieve tree ticker) (empty-tree))));subtree with dates
      nil))

;So here we will pretty much have a list
;where in fact every even numbered list part
; will be the stuff we need
(defun parse-analysis-req (reqs)
  (if (consp reqs)
      (cons (cdddr (car reqs)) (parse-analysis-req (cddr reqs)))
  nil))

; Get the data into the proper structure for
; Traversing tree
(defun to-search-structure (xs)
  (if (consp xs)
      (cons (chrs->str (car xs)) (to-search-structure(cdr xs)))
  nil))

; Just plain csv splitter to you know
; split comma delited stuff
(defun split-csv-style (data)
  (if (consp data)
      (cons (to-search-structure (packets #\, (car data))) 
            (split-csv-style (cdr data)))
      nil))

; Reads in file and sends to pruner
(defun read-req-file (filename)
  (split-csv-style
   (parse-analysis-req
   (cdr(packets-set '(#\<,#\A,#\R,#\>) 
       (str->chrs (car (file->string filename state)))
       )))))