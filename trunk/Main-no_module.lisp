;75 Chars *****************************************************************

(in-package "ACL2")

(include-book "minput") ;clay 2
(include-book "testgroupproject") ;femi 2
(include-book "read-sort") ;shane 3
;(include-book "htmlgenerator") ;cezar 5

(set-state-ok t)

(defun do ()
(prune (read-req-file "in_file.txt")
(delegate-into-tree
 (parse-input (file->tuples "../hist_short.txt" state))
 (empty-tree))))

(defun make-subtree()
  (let* ((start-tree (empty-tree))
         (start-tree2 (avl-insert start-tree "20120101" "2.0"))
         (start-tree3 (avl-insert start-tree2 "20120202" "3.0"))
         (start-tree4 (avl-insert start-tree3 "20130101" "4.0")))
    start-tree4))

(defun make-tree ()
  (avl-insert (empty-tree) "GOOG"
              (make-subtree)))

(defun make-complex-tree ()
  (avl-insert (make-tree) "AA" (make-subtree)))