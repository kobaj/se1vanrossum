;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(in-package "ACL2")

(interface Icalc_slope_intercept
  (sig avl_flatten-both (tr))
  (sig build-total-child-helper (flat-sub-tree return-tree))
  (sig build-total-helper (flat-tree return-tree))
  (sig build-total-date-tree (flat-tree))
  (sig get_xs (flat_dates_values number))
  (sig get_ys (flat_dates_values))
  (sig get_list_and_slope_intercept (pruned_tree)))