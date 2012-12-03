(in-package "ACL2")

(include-book "list-utilities" :dir :teachpacks)
(include-book "io-utilities" :dir :teachpacks)
(include-book "avl-string-keys")
(set-state-ok t)

(defun insert-into-tree (xs tree)
   (let* ((tk (car xs))
             (td (cadr xs))
             (cp  (caddr xs))
             (old-tree (avl-retrieve tree tk))
             (new-tree 
        (if (equal old-tree nil)
            (avl-insert tree tk (avl-insert (empty-tree) td cp))
            (avl-insert tree tk (avl-insert (cdr old-tree) td cp)))))
        new-tree))

; this fuction takes a list of lists where each list of strings where each
;list contains the ticker, the closing price and the trade date. Then it builds an AVL
;tree using the tk as the key, and the closing price and trade date as the data
(defun delegate-into-tree (xs tree)
  (if (consp (cdr xs))
      (delegate-into-tree (cdr xs) (insert-into-tree (car xs) tree))
      (insert-into-tree (car xs) tree)))

(defun parse-input (xs)
  (if (consp xs)
       (let* ((cp (chrs->str (car(tokens '(#\< #\c #\p #\>)(str->chrs (cadr(car xs)))))))
             (td (chrs->str (car(tokens '(#\< #\t #\d #\>)(str->chrs (caddr(car xs)))))))
             (key (chrs->str (car(tokens '(#\< #\t #\k #\>)(str->chrs (caar xs)))))))
         (cons (list key td cp) (parse-input (cdr xs))))
       nil))
