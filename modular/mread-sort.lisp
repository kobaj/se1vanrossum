;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
; @Author Team Van Rossum
; modules reads in an analysis file which
; will be used to prune the tree and get the data

(require "Iavl-string-keys.lisp")

(module Mread-sort
  (import Iavl-string-keys)
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  (set-state-ok t)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;Date Formatting;;;;;;;;
  ;Checks the day on whether 
  ; it is a 31 will be used to see if needed next month
  (defun check-day (date)
    (if (equal 31 (str->int (subseq date 6 8)))
        t
        nil))
  ;Formats the date appropriately
  ;called from fmt-date ahead a month or year if needed
  (defun fmt-date-helper (year mnth day)
    (if (equal 12 mnth)
        (append (int->dgts (1+ year)) '(0 1 0 1))
        (if (< mnth 9)
            (append (int->dgts year) (cons 0 (int->dgts (1+ mnth)))  '(0 1))    
            (append (int->dgts year) (int->dgts (1+ mnth))  '(0 1)))))
  
  ;Formats the date to a format that we can work with
  (defun fmt-date (date)
    (let* ((date-dgts  (int->dgts (str->int date)))
           (mnth (dgts->int (subseq date-dgts 4 6)))
           (day (dgts->int (subseq date-dgts 6 8)))
           (year (dgts->int (subseq date-dgts 0 4))))
      (int->str (dgts->int (fmt-date-helper year mnth day)))))
  
  
  
 ;;;;;;;;;;;;; Add these nodes to the tree if not in;;;;;;;;;; 
  ;Increase the date by one
  (defun plus_one_date (date)
    (int->str (1+ (str->int date))))

  (defun get_nearest_date_< (date rev_flat_tree)
    (let* ((top_element (car rev_flat_tree))
           (top_date    (car top_element)))
      (if (consp rev_flat_tree)
          (if (string< top_date date)
              top_element
              (get_nearest_date_< date (cdr rev_flat_tree)))
          nil)))

  (defun get_nearest_date_> (date flat_tree)
    (let* ((top_element (car flat_tree))
           (top_date    (car top_element)))
      (if (consp flat_tree)
          (if (string> top_date date)
              top_element
              (get_nearest_date_> date (cdr flat_tree)))
          nil)))
  
  (defun date_difference_helper (date_1 date_2 count)
    (if (>= (str->int date_1) (str->int date_2))
        count
        (let* ((start-date (if (check-day date_1) 
                               (fmt-date date_1)
                               date_1)))
          (date_difference_helper (plus_one_date start-date) date_2 (1+ count)))))
  
  ; Difference between dates
  (defun date_difference (date_1 date_2)
    (if (> (str->int date_1) (str->int date_2))
        nil
        (date_difference_helper date_1 date_2 0)))
  
  (defun get_nearest_date (date sub_tree)
    (let* ((flat_tree (avl-flatten sub_tree))
           (nearest<  (get_nearest_date_< date (reverse flat_tree)))
           (nearest>  (get_nearest_date_> date flat_tree))
           (date<     (car nearest<))
           (date>     (car nearest>))
           (amount<   
            (if (equal date< nil)
                9999999999999999
                (date_difference date< date)))
           (amount>   
            (if (equal date> nil)
                9999999999999999
                (date_difference date date>))))
      (if (< amount< amount>) ;because fuck you
          nearest<
          nearest>)))
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;Now to get the stuff outta tree
  
  ; Searching subtree for the corret dates
  ; First check if we have matched the start 
  ; make sure date format is correct
  (defun get-by-dates (start end tree ret-tree)
    (if (equal start end)
        ret-tree
        (let* ((start-date (if (check-day start) 
                               (fmt-date start)
                               start))
               (old-ret-tree (avl-retrieve tree start-date))
               (start_value (cdr old-ret-tree))
               (new-ret-tree (if (equal old-ret-tree nil)
                                 (let* ((nearest_element (get_nearest_date start-date tree))
                                        (nearest_value   (cdr nearest_element)))
                                   (avl-insert ret-tree start-date nearest_value))
                                 (avl-insert ret-tree start-date start_value))))
          (get-by-dates (plus_one_date start-date) end tree 
                        new-ret-tree))))
  
  ; After the retrieval file is parsed
  ; Prepare the data to search the tree
  ; Once the correct ticker name is found
  (defun prune-clean (reqs tree ret-tree)
    (if (consp reqs)
        (let* ((req (car reqs))
               (ticker (car req))
               (start (cadr req))
               (end (caddr req))
               (start-tree (avl-retrieve tree ticker))
               (sub-tree (cdr start-tree))
               (new-ret-tree 
                (if (equal start-tree nil)
                    ret-tree
                    (avl-insert ret-tree ticker (get-by-dates start end sub-tree (empty-tree))))))
          (prune-clean (cdr reqs) tree new-ret-tree)) 
        ret-tree))
  
  ;Call this function to start the whole prune process
  (defun prune (reqs tree)
    (prune-clean reqs tree (empty-tree)))
  
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
    (if (stringp filename)
        (split-csv-style
         (parse-analysis-req
          (cdr(packets-set '(#\<,#\A,#\R,#\>) 
            (str->chrs (car (file->string filename state)))
                       ))))
    nil))
  )