;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;Team Van Rossum
;Software Engineering 1 
;defines interface for mavl-string-key module



(interface Iavl-string-keys
  ; function def's
  (sig empty-tree? (tr))
  (sig  height (tr))
  (sig key (tr))
  (sig data (tr))
  (sig left (tr))
  (sig right (tr))
  (sig keys (tr))
  (sig empty-tree ( ))
  (sig tree (k d lf rt))
  (sig  key? (k))
  (sig key< (j k))
  (sig key> (j k))
  (sig  key= (j k)) 
  (sig  key-member (k ks))
  (sig  data? (d))
  (sig  tree? (tr))
  (sig  occurs-in-tree? (k tr))
  (sig  alternate-occurs-in-tree? (k tr))
  (sig  all-keys< (k ks))
  (sig   all-keys> (k ks))
  (sig  ordered? (tr))
  (sig   balanced? (tr))
  (sig   avl-tree? (tr))
  (sig  easy-R (tr))
  (sig  easy-L (tr))
  (sig left-heavy? (tr))
  (sig outside-left-heavy? (tr))
  (sig  right-rotatable? (tr))
  (sig right-heavy? (tr))
  (sig outside-right-heavy? (tr))
  (sig left-rotatable? (tr))
  (sig hard-R (tr))
  (sig inside-left-heavy? (tr))
  (sig hard-R-rotatable? (tr))
  (sig inside-right-heavy? (tr))
  (sig hard-L-rotatable? (tr))
  (sig rot-R (tr))
  (sig rot-L (tr))
  (sig avl-insert (tr new-key new-datum))
  (sig  easy-delete (tr))
  (sig  shrink (tr))
  (sig raise-sacrum (tr))
  (sig delete-root (tr))
  (sig  avl-delete (tr k))
  (sig avl-retrieve (tr k))
  (sig avl-flatten (tr))
  (sig occurs-in-pairs? (k pairs))
  (sig increasing-pairs? (pairs))
  )
  