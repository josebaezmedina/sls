(module
  sls
  ()
  (import scheme)
  (import (chicken base))
  (import (chicken syntax))
  (import (chicken string))
  (import (chicken file))
  (import (chicken file posix))
  (import (chicken pathname))
  (import (chicken sort))
  (import (chicken process-context))
  (import args)
  (import srfi-1)
  (import (chicken format))
  (import list-utils)
  (import fmt)
  (import fmt-color)
  (import (chicken pretty-print))
  (import json)
  (import srfi-13)
  
  (include "data.scm")
  (include "output-formats.scm")

  (define (get-items folder-path show-hidden?)
    (map (lambda (x) (string-append folder-path "/" x))
         (sort (directory folder-path show-hidden?) string<?)))
  
  (define (get-filename folder)
    (receive
      (directory filename ext)
      (decompose-pathname folder)
      (string-append
        filename
        (if (not (equal? #f ext)) (string-append "." ext) ""))))
  
  (define (populate-file full-path folder-path)
    (make-file-sls
      (get-filename full-path)
      (string-append folder-path "")
      (file-executable? full-path)
      (file-writable? full-path)
      (file-type full-path)
      (let ((fsx (file-size full-path)))
        (if (> fsx 0) (fmt #f (num/si fsx 1000 "B")) "0"))))
  
  (define (should-show-all? options-list)
    (any (lambda (x) (equal? (->string (car x)) "a")) options-list))
  
  (define (get-option-and-value options-list option)
    (find (lambda (xs) (equal? (->string (car xs)) option)) options-list))
  
  (define options
    (list (args:make-option (l list) #:optional "list")
          (args:make-option (t tabular) #:optional "tabular")
          (args:make-option (c csv) #:optional "csv")
          (args:make-option (j json) #:optional "json")
          (args:make-option (w html) #:optional "html")
          (args:make-option (x xml) #:optional "xml")
          (args:make-option (a all) #:optional "show hidden files")
          (args:make-option (h help) #:optional "help")))
  
  (define (main)
    (receive
      (optionsx operands)
      (args:parse (command-line-arguments) options)
      (let ((path-param (if (length=0? operands) "." (car operands))))
        (let ((contents
                (map (lambda (item) (populate-file item path-param))
                     (get-items path-param (should-show-all? optionsx)))))
          (cond ((pair? (get-option-and-value optionsx "l"))
                 (print-as-list contents))
                ((pair? (get-option-and-value optionsx "t"))
                 (print-tabular contents))
                ((pair? (get-option-and-value optionsx "c"))
                 (print-csv contents))
                ((pair? (get-option-and-value optionsx "j"))
                 (print-json contents))
                ((pair? (get-option-and-value optionsx "w"))
                 (print-html contents))
                ((pair? (get-option-and-value optionsx "x"))
                 (print-xml contents))
                ((pair? (get-option-and-value optionsx "h"))
                 (print (args:usage options)))
                (else (print-default contents)))))))

  (main))
