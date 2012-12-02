;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(in-package "ACL2")

(interface Iinput
  (sig break-on-<sr> (filename state))
  (sig extract-fields (xs))
  (sig generate-tuples (xs))
  (sig file->tuples (filename state)))