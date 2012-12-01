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
       (cons (+ (* slope (cdar xs)) intercept) (regressionList (cdr xs) slope intercept))
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

; new format gives a date, value, null null, linear regression, null, null
;[new Date(2008, 1 ,1), 30000, null, null, 40645, null, null],

;Note: both datesPrices and regressionVals will be indexed the same ,
; so checking if we haved reachedthe end of regressionVals should be sufficient. 
;rat->str requires a number of sig figs, for now im using 4...
(defun data->str (datesPrices regressionVals)
  (if (endp regressionVals)
      nil
      (let* ((date-dgts (caar datesPrices))
             (mnth   (subseq date-dgts 4 6))
             (day    (subseq date-dgts 6 8))
             (year   (subseq date-dgts 0 4))
             (full_s (concatenate 'string "[new Date(" year "," mnth "," day ")," (rat->str (cdar datesPrices) 4) ", null, null, " (rat->str (car regressionVals) 4) ", null, null]")))
      (if (equal (cdr regressionVals) nil);if this is the last element, format without a comma.
          full_s
          (concatenate 'string full_s ", \n"
                         (data->str (cdr datesPrices)(cdr regressionVals)))                              
   ))))

;stringBuilder (valuesStr)
;This function builds an HTML string from a data string 
;that will generate a Google visualization line graph.
;valuesStr = input string with values to graph
(defun stringBuilder (valuesStr)
       (list 
        
        "<html>
  <head>
    <script type='text/javascript' src='http://www.google.com/jsapi'></script>
    <script type='text/javascript'>
      google.load('visualization', '1', {'packages':['annotatedtimeline']});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number', 'Total Values');
        data.addColumn('string', 'title1');
        data.addColumn('string', 'text1');
        data.addColumn('number', 'Linear Regression');
        data.addColumn('string', 'title2');
        data.addColumn('string', 'text2');
        data.addRows(["
        
        (concatenate 'string valuesStr)
        
        "]);

        var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('chart_div'));
        chart.draw(data, {displayAnnotations: true});
      }
    </script>
  </head>

  <body>
    <div id='chart_div' style='width: 1200px; height: 1050px;'></div>
  </body>
</html>"))
   

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
  (let* ((intercept (cadadr datesPricesReg))
         (slope (caadr datesPricesReg))
         (xs (car datesPricesReg))
         (regressionVals (regressionList xs slope intercept))
         (dataStrConversion (data->str (car datesPricesReg) regressionVals))
        (htmlResult (stringBuilder dataStrConversion)))
        (string-list->file fileName htmlResult state)
  ))

;new input file
; 20120102 is a date, 300 is a total closing price of all for that day, and 2, 3 is the slope and intercept.
;(writeHTML "dynamicTest5.html" 
;           (list (list (cons "20120102" 300) (cons "20130102"  500) (cons "20140102" 1200)) (list 2 3)))



 
 



