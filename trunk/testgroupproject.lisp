(in-package "ACL2")

(include-book "list-utilities" :dir :teachpacks)
(include-book "io-utilities" :dir :teachpacks)
(include-book "avl-rational-keys" :dir :teachpacks)
(set-state-ok t)


; this fuction takes a list of lists where each list of strings where each
;list contains the ticker, the closing price and the trade date. Then it builds an AVL
;tree using the tk as the key, and the closing price and trade date as the data
(defun build-tree (xs)
  (if (consp xs)
      (let* ((tk (caar xs))
             (cp (cadr(car xs)))
             (td (caddr(car xs)))
             (key (chrs->str (car(tokens '(#\< #\t #\k #\>)(str->chrs tk)))))
             (data (list cp td)))
        (tree key data (build-tree (cdr xs)) (build-tree (cddr xs))))
      (empty-tree)))
