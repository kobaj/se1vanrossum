;75 Chars *****************************************************************

(in-package "ACL2")

(include-book "minput") ;clay 2
(include-book "testgroupproject") ;femi 2
;(include-book "read-sort") ;shane 3
;(include-book "htmlgenerator") ;cezar 5

(set-state-ok t)

(delegate-into-tree
 (parse-input (file->tuples "../hist_short.txt" state))
 (empty-tree))