(in-package "ACL2")
(include-book "arithmetic-3/top" :dir :system)
(include-book "io-utilities" :dir :teachpacks)
(include-book "list-utilities" :dir :teachpacks)
(include-book "doublecheck" :dir :teachpacks)
(set-state-ok t)


;regressionList (xs)
;This function takes in a list of numbers and
;generates a list of regression values based on
;a slope and intercept (mx+b)
;xs = the list of values
;slope = the calculated slope (m) from the regression module (s)
;intercept = the calculated intercept (b) from the regression module (s)
(defun regressionList (xs slope intercept)
  (if (endp xs)
       nil
       (cons (+ (* slope (cadar xs)) intercept) (regressionList (cdr xs) slope intercept))
       ))
    
 ;data->str (dates totalPrices reg) 
;This function takes in the data and converts it to
;a string representation of a matrix to be used for
;the Google visualization API.
;dates = the analysis request dates (x-axis)
;totalPrices = the total closing prices of the stocks
;within the analysis file for a specific closing date (y-axis 1)
;reg = the linear regression data set (y -axis 2)

;The output format will be as follows:

;        " ['2004',  1000,      400],
;          ['2005',  1170,      460],
;          ['2006',  660,       1120],
;          ['2007',  665,       1123],
;          ['2008',  685,       1163],
;          ['2009',  625,       5123],
;          ['2010',  665,       1123],
;          ['2011',  685,       1113],
;          ['2012',  700,       1823],
;          ['2013',  954,       3456],
;          ['2014',  655,       1183],
;          ['2015',  789,       1133],
;          ['2016',  480,       1223],
;          ['2017',  435,       1178],
;          ['2018',  685,       1923],
;          ['2019',  854,       1143],
;          ['2020',  751,       1423] " 

;Note: both datesPrices and regressionVals will be indexed the same ,
; so checking if we haved reachedthe end of regressionVals should be sufficient. 
;rat->str requires a number of sig figs, for now im using 4...
(defun data->str (datesPrices regressionVals)
  (if (endp regressionVals)
      nil
      (if (equal (cdr regressionVals) nil);if this is the last element, format without a comma.
          (concatenate 'string "['" (rat->str (caar datesPrices) 0) "'," (rat->str (cadar datesPrices) 4) "," (rat->str (car regressionVals) 4) "]")
          (concatenate 'string "['" (rat->str (caar datesPrices) 0) "'," (rat->str (cadar datesPrices) 4) "," (rat->str (car regressionVals) 4) "],"
                         (data->str (cdr datesPrices)(cdr regressionVals)))                              
   )))

;stringBuilder (valuesStr)
;This function builds an HTML string from a data string 
;that will generate a Google visualization line graph.
;valuesStr = input string with values to graph
(defun stringBuilder (valuesStr)
       (list "<html><head> <script type=" " \"text/javascript\" " "src=" "\"https://www.google.com/jsapi\"" 
                                                                   "></script>"  "<script type=" "\"text/javascript\"" ">"
                                                                  "google.load(" "\"visualization\"" "," "\"1\"" "," "{packages:[" "\"corechart\"" "]});"
                                                                  "google.setOnLoadCallback(drawChart);"
                                                                   "function drawChart() {"
                                                                  "var data = google.visualization.arrayToDataTable(["
                                                                  
                                                                 (string-append "[ 'Year', 'Total Closing Price', 'Least-Squares Regression'],"
                                                                  
                                                                (concatenate 'string valuesStr))
                            
                                                               "]);"
                                                              "var options = {"
                                                              "title:" "'Stock Analysis'"
                                                             " };"
                                                             "var chart = new google.visualization.LineChart(document.getElementById(" "'chart_div')); "
                                                             "chart.draw(data, options);"
                                                             "}"
                                                             " </script>"
                                                             " </head>"
                                                            "<body>"
                                                           "<div id=" "\"chart_div\"" "style=" "width: 500px; height: 500px;" "></div>"
                                                          "</body> "
                                                          "</html>" )
  )
   

;writeFile (fileName dataStrList)
;This function writes day-by-day total closing price of the stocks 
;within an analysis request along with a linear least-squares regression line
;to an HTML file. This content is then transformed by the Google visualization
;API into a line graph representation.
;fileName = the output file to write to.
;datesPricesReg = (((td, sumcp)(td2, sumcp2) ...) slope intercept)
;
;Note: This is the entry point for this module. This function should be the only one called externally. 
(defun writeHTML (fileName datesPricesReg) 
  (let* ((regressionVals (regressionList (car datesPricesReg) (cadr datesPricesReg) (caddr datesPricesReg)))
         (dataStrConversion (data->str (car datesPricesReg) regressionVals))
        (htmlResult (stringBuilder dataStrConversion)))
        (string-list->file fileName htmlResult state)
  ))


;example caller (slope and intercept not accurate!! For Testing only)
;(writeHTML "dynamicTest5.html" (list (list '(2012 300)'(2013 500)'(2014 600)'(2015 700)'(2016 800)'(2017 900)'(2018 1000)'(2019 1100)'(2020 1200)) 2 3))


  


 
 



