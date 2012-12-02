(include-book "testing" :dir :teachpacks)
(include-book "read-sort")
(include-book "doublecheck" :dir :teachpacks)



(check-expect (check-day "20121131") t)
(check-expect (check-day "20120101") nil)
(check-expect (check-day "20120214") nil)


(check-expect (fmt-date "20121131") "20121201")
(check-expect (fmt-date "20121231") "20130101")
(check-expect (fmt-date "20120931") "20121001")
(check-expect (fmt-date "20120831") "20120901")
(check-expect (fmt-date "19991231") "20000101")


(check-expect (split-csv-style nil) nil)
(check-expect (split-csv-style '((#\G #\O #\O #\G #\, 
                              #\2 #\0 #\1 #\2 #\1 #\1 #\1 #\3 #\, 
                              #\2 #\0 #\1 #\2 #\0 #\3 #\0 #\5)))
              '(("GOOG" "20121113" "20120305")))
(check-expect (split-csv-style '(
      (#\G  #\O  #\O  #\G  #\,
      #\2  #\0  #\1  #\2  #\0  #\1  #\0  #\5  #\,
      #\2  #\0  #\1  #\2  #\0  #\3  #\0  #\5)
      (#\A  #\M  #\Z  #\N  #\, 
       #\2  #\0  #\1  #\2  #\0  #\1  #\0  #\5  #\,
       #\2  #\0  #\1  #\2  #\0  #\3  #\0  #\5)
      (#\Y  #\H  #\O  #\O  #\,
       #\2  #\0  #\1  #\2  #\0  #\1  #\0  #\5  #\,
       #\2  #\0  #\1  #\2  #\0  #\3  #\0  #\5)
      (#\A  #\P  #\P  #\L  #\,
       #\2  #\0  #\1  #\2  #\0  #\1  #\0  #\5  #\,
       #\2  #\0  #\1  #\2  #\0  #\3  #\0  #\5)
      (#\V  #\Z  #\W  #\,
       #\2  #\0  #\1  #\2  #\0  #\1  #\0  #\5  #\,
       #\2  #\0  #\1  #\2  #\0  #\3  #\0  #\5)
      (#\G  #\O  #\O  #\G  #\,
       #\2  #\0  #\1  #\2  #\0  #\1  #\0  #\5  #\,
       #\2  #\0  #\1  #\2  #\0  #\3 #\0 #\5)))
              '(("GOOG" "20120105" "20120305")
 ("AMZN" "20120105" "20120305")
 ("YHOO" "20120105" "20120305")
 ("APPL" "20120105" "20120305")
 ("VZW" "20120105" "20120305")
 ("GOOG" "20120105" "20120305")))

              
(check-expect (to-search-structure nil) nil)



(defrandom random-date ()
  (random-between 19000101 20130101))

(defrandom random-cp ()
  (random-between 50 700))
(defrandom random-tick ()
  (random-string))

(defrandom random-tree-input ()
  (list (random-tick) (random-date) (random-tick)))

(defrandom random-tree-input-list ()
  (random-list-of (random-tree-input)))