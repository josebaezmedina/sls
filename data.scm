 (define-record-type
    file-sls
    (make-file-sls name path is-executable? is-readonly? type size)
    file-sls?
    (name file-sls-name file-sls-name-set!)
    (path file-sls-path file-sls-path-set!)
    (is-executable? file-sls-is-executable? file-sls-is-executable-set!)
    (is-readonly? file-sls-is-readonly? file-sls-is-readonly-set!)
    (type file-sls-type file-sls-type-set!)
    (size file-sls-size file-sls-size-set!))
  
  (define-record-printer
    (file-sls fs out)
    (fprintf
      out
      "(file-sls name:~s, path:~s, is-executable?:~s, is-read-only?:~s, type:~s, size:~s)~%"
      (file-sls-name fs)
      (file-sls-path fs)
      (file-sls-is-executable? fs)
      (file-sls-is-readonly? fs)
      (file-sls-type fs)
      (file-sls-size fs)))