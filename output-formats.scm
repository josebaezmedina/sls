(define (get-terminator-print format) (if (string=? format "l") nl "  "))

(define (print-contents contents format)
  (apply print
         (map (lambda (x)
                (cond ((string=? (->string (file-sls-type x)) "directory")
                       (fmt #f
                            (fmt-blue
                              (file-sls-name x)
                              (get-terminator-print format))))
                      ((equal? (file-sls-is-executable? x) #t)
                       (fmt #f
                            (fmt-green
                              (file-sls-name x)
                              (get-terminator-print format))))
                      (else
                       (fmt #f
                            (file-sls-name x)
                            (get-terminator-print format)))))
              contents)))

(define (print-default contents) (print-contents contents ""))

(define (print-as-list contents) (print-contents contents "l"))

(define (print-tabular contents)
  (fmt #t
       (tabular
         ""
         (dsp (string-append
                "name\n"
                (string-join (map file-sls-name contents) "\n")))
         " "
         (dsp (string-append
                "is-executable?\n"
                (string-join
                  (map (lambda (x)
                         (if (equal? #t (file-sls-is-executable? x))
                           "true"
                           "false"))
                       contents)
                  "\n")))
         " "
         (dsp (string-append
                "is-read-only?\n"
                (string-join
                  (map (lambda (x)
                         (if (equal? #t (file-sls-is-readonly? x))
                           "true"
                           "false"))
                       contents)
                  "\n")))
         " "
         (dsp (string-append
                "type\n"
                (string-join
                  (map (compose ->string file-sls-type) contents)
                  "\n")))
         " "
         (dsp (string-append
                "size\n"
                (string-join (map file-sls-size contents) "\n")))
         ""))
  (print (string-append "total " ((compose ->string length) contents))))

(define (print-csv contents)
  (let ((header "name,is-executable,is-read-only,type,size\n"))
    (apply print
           (cons header
                 (map (lambda (x)
                        (string-append
                          (string-join
                            (list (file-sls-name x)
                                  (if (equal? #t (file-sls-is-executable? x))
                                    "true"
                                    "false")
                                  (if (equal? #t (file-sls-is-readonly? x))
                                    "true"
                                    "false")
                                  (->string (file-sls-type x))
                                  (file-sls-size x))
                            ",")
                          "\n"))
                      contents)))))

(define (print-json contents)
  (json-write
    (list (map (lambda (x)
                 (vector
                   (cons (string->symbol "name") (file-sls-name x))
                   (cons (string->symbol "is-executable")
                         (file-sls-is-executable? x))
                   (cons (string->symbol "is-read-only")
                         (file-sls-is-readonly? x))
                   (cons (string->symbol "type") (->string (file-sls-type x)))
                   (cons (string->symbol "size")
                         (->string (file-sls-size x)))))
               contents)))
  (newline))

(define (print-html contents)
  (let ((top (list "<!doctype html>\n<html>\n<body>\n"))
        (end (list "</body>\n</html>\n"))
        (body (append
                (list "<table>\n")
                (list "<tr>\n")
                (list "<th>name</th><th>is-executable?</th><th>is-read-only?</th><th>type</th><th>size</th>")
                (list "</tr>\n")
                (map (lambda (x)
                       (string-append
                         "<tr>\n"
                         "<td>"
                         (file-sls-name x)
                         "</td>"
                         "<td>"
                         (if (equal? #t (file-sls-is-executable? x))
                           "true"
                           "false")
                         "</td>"
                         "<td>"
                         (if (equal? #t (file-sls-is-readonly? x))
                           "true"
                           "false")
                         "</td>"
                         "<td>"
                         (->string (file-sls-type x))
                         "</td>"
                         "<td>"
                         (file-sls-size x)
                         "</td>"
                         "</tr>\n"))
                     contents)
                (list "</table>\n"))))
    (apply print (append top body end))
    (newline)))

(define (print-xml contents)
  (let ((top (list "<contents>\n"))
        (end (list "</contents>\n"))
        (body (append
                (map (lambda (x)
                       (string-append
                         "<content>\n"
                         "<name>"
                         (file-sls-name x)
                         "</name>"
                         "<is-executable>"
                         (if (equal? #t (file-sls-is-executable? x))
                           "true"
                           "false")
                         "</is-executable>"
                         "<is-read-only>"
                         (if (equal? #t (file-sls-is-readonly? x))
                           "true"
                           "false")
                         "</is-read-only>"
                         "<type>"
                         (->string (file-sls-type x))
                         "</type>"
                         "<size>"
                         (file-sls-size x)
                         "</size>\n"
                         "</content>\n"))
                     contents))))
    (apply print (append top body end))
    (newline)))
