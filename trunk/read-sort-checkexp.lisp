(include-book "testing" :dir :teachpacks)
(include-book "read-sort")


(check-expect (check-day 20121131) t)
(check-expect (check-day 20120101) nil)
(check-expect (check-day 20120214) nil)


(check-expect (fmt-date 20121131) 20121201)
(check-expect (fmt-date 20121231) 20130101)
(check-expect (fmt-date 20120931) 20121001)
(check-expect (fmt-date 20120831) 20120901)
(check-expect (fmt-date 19991231) 20000101)