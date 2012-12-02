;Team Van Rossum
;Software Engineering 1 
;defines interface for mread-sort module

(interface Iread-sort
  ;function definitions
  (sig check-date (date))
  (sig fmt-date-helper (year mnth day))
  (sig fmt-date (date))
  (sig plus_one_date (date))
  (sig get_nearest_date (date rev_flat_tree))
  (sig get_nearest_date_> (date flat_tree))
  (sig date_difference_helper (date_1 date_2 count))
  (sig date_difference (date_1 date_2))
  (sig get_nearest_date (date sub_tree))
  (sig  get-by-dates (start end tree ret-tree))
  (sig prune-clean (reqs tree ret-tree))
  (sig  prune (reqs tree))
  (sig parse-analysis-req (reqs))
  (sig to-search-structure (xs))
  (sig  split-csv-style (data))
  (sig read-req-file (filename))
  
  )