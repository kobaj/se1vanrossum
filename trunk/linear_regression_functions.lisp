;75 Chars *****************************************************************
;Jakob Griffith
;functions
(in-package "ACL2")

(include-book "io-utilities" :dir :teachpacks)
(include-book "list-utilities" :dir :teachpacks)
(set-state-ok t)

;helper function for different avg
(defun avg-helper (xs length-xs)
  (if (consp xs)
      (+ (/ (car xs) length-xs) (avg-helper (cdr xs) length-xs))
      0))

;function calculates avg in a different way
(defun avg(xs)
  (if (consp xs)
      (avg-helper xs (length xs))
  nil))

;helper function for adding scalar to a list
(defun vector_plus_scalar-helper (xs x)
  (if (consp xs)
      (cons (+ (car xs) x) (vector_plus_scalar-helper (cdr xs) x))
      nil))

;function adds a scalar to a list.
(defun vector_plus_scalar (xs x)
  (if (and (rationalp x) (consp xs))
      (vector_plus_scalar-helper xs x)
      nil))

;helper function for adding scalar to a list
(defun vector_mul_vector-helper (xs ys)
  (if (and (consp ys) (consp xs))
      (cons (* (car xs) (car ys)) 
            (vector_mul_vector-helper (cdr xs) (cdr ys)))
      nil))

;function adds a scalar to a list.
(defun vector_mul_vector (xs ys)
  (if (and (consp ys) (consp xs) (equal (length ys) (length xs)))
      (vector_mul_vector-helper xs ys)
      nil))

;function computers the r value
(defun compute_r_xvar (xs ys xavg yavg)
  (if (and (rationalp xavg) (rationalp yavg) (consp ys) 
           (consp xs) (equal (length ys) (length xs)))
      (let* ((x_m_a   (vector_plus_scalar xs (- 0 xavg)))
             (y_m_a   (vector_plus_scalar ys (- 0 yavg)))
             (x_mul_y (vector_mul_vector x_m_a y_m_a)))
      (avg x_mul_y))
      nil))

;quick wrapper for xvar
(defun compute_xvar (xs xavg)
  (if (and (rationalp xavg) (consp xs))
      (compute_r_xvar xs xs xavg xavg)
      nil))

;function computers slope and interectp and puts them into a list r.
;b is slope
;a is intercept
(defun compute_slope_intercept (xs ys)
  (if (and (consp xs) (consp ys))
      (let* ((yavg (avg ys))
             (xavg (avg xs))
             (r    (compute_r_xvar xs ys xavg yavg))
             (xvar (compute_xvar xs xavg))
             (b (/ r xvar))
             (a (- yavg (* b xavg))))
        (list b a))
      nil))


;*************************************
;everything below this line is IO
;*************************************


;convert a list of chars into a list of rational numbers
(defun chrs_list->ration_list (xs)
  (if (consp xs)
      (cons (str->rat (chrs->str (car xs))) (chrs_list->ration_list 
                                             (cdr xs)))
       nil))

;function splits a list of numbers into a list of xs and ys
(defun split_xs_ys (xs)
  (if (consp (cdddr xs))
      (let* ((tfirst  (car xs))
             (tsecon  (cadr xs))
             (remain  (cddr xs))
             (calced  (split_xs_ys remain))
             (calfir  (car calced))
             (calsec  (cadr calced)))
        (list (cons tfirst calfir) (cons tsecon calsec)))
      (list (list (car xs)) (list (cadr xs)))))
  
;function takes a list of chars and counts how many are after decimal
(defun count_after_decimal (xs)
  (if (consp xs)
      (length (drop-past #\. xs))
      0))
      
;function finds the maximum sig figs from a list of chars
(defun max_decimals (xs)
  (if (consp xs)
      (max (count_after_decimal (car xs)) (max_decimals (cdr xs)))
      0))

;helper function for read-transform-write
(defun your-transform (input-string)
  (let* ((LF             (code-char 10))
         (CR             (code-char 13))
         (whitespace     (list #\Space #\Newline #\Tab LF CR)) 
         (string_numbers (tokens whitespace (str->chrs input-string)))
         (ration_numbers (chrs_list->ration_list string_numbers))
         (max_decimals_c (max_decimals string_numbers))
         (split_xsys     (split_xs_ys ration_numbers))
         (xs             (car split_xsys))
         (ys             (cadr split_xsys))
         (ab             (compute_slope_intercept xs ys))
         (slope          (car ab))
         (intercept      (cadr ab)))
    (list "Linear Regression Coefficients (slope, intercept)"
          (concatenate 'string
           (rat->str slope max_decimals_c)
           " "
           (rat->str intercept max_decimals_c))
          "x-y Data"
          input-string)))

;predefined function from the slides
(defun read-transform-write (f-in f-out state)
  (mv-let (input-as-string error-open state)
          (file->string f-in state)
     (if error-open
         (mv error-open state)
         (mv-let (error-close state)
                 (string-list->file f-out
                                    (your-transform input-as-string)
                                    state)
            (if error-close
                (mv error-close state)
                (mv (string-append "input file: "
                     (string-append f-in
                      (string-append ", output file: " f-out)))
                    state))))))

;our wrapper for easily making input file and output file name match
(defun entry_point (f-in state)
  (read-transform-write f-in (concatenate 'string
      (chrs->str (car (packets #\. (str->chrs f-in))))
      "withLRcoeffs.txt") state))