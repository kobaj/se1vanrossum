(in-package "ACL2")
(include-book "arithmetic-3/top" :dir :system)
(include-book "io-utilities" :dir :teachpacks)
(include-book "list-utilities" :dir :teachpacks)
(include-book "doublecheck" :dir :teachpacks)
(set-state-ok t)

  
;This function takes in the data and converts it to
;a string representation of a matrix to be used for
;the Google visualization API.
;dates = the analysis request dates (x-axis)
;totalPrices = the total closing prices of the stocks
;within the analysis file for a specific closing date (y-axis 1)
;reg = the linear regression data set (y -axis 2)
(defun data->str (dates totalPrices reg)

  ;TODO needs to create strings from actual data
  
          " ['2004',  1000,      400],
          ['2005',  1170,      460],
          ['2006',  660,       1120],
          ['2007',  665,       1123],
          ['2008',  685,       1163],
          ['2009',  625,       5123],
          ['2010',  665,       1123],
          ['2011',  685,       1113],
          ['2012',  700,       1823],
          ['2013',  954,       3456],
          ['2014',  655,       1183],
          ['2015',  789,       1133],
          ['2016',  480,       1223],
          ['2017',  435,       1178],
          ['2018',  685,       1923],
          ['2019',  854,       1143],
          ['2020',  751,       1423] "                                    
   )

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
                                                                  
                                                                valuesStr)
                            
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
;fileName = the name of the file to write to.
;data = the list of data values to graph
(defun writeHTML (fileName dates totalPrices reg)
 (string-list->file fileName dataStrList state) 
  (let* ((dataStrConversion (data->str dates totalPrices reg))
         (htmlResult (stringBuilder dataStrConversion)))
        (string-list->file fileName htmlResult state)
  ))



;(writeHTML "testLongerDataSet2.html" '(1 2 3 4) '(1 2 3 4) '(1 2 3 4))


  

 
 
 



