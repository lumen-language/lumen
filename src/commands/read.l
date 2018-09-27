#!/usr/bin/env lumen

(define-global lumen-read-usage "
Read a Lisp file.

Usage:
  lumen-read <filename>...
")

(define-global lumen-read (argv)
  (let (args (parse-arguments
               (obj h: 'help)
               argv)
        files (keep string? args))
    (if (none? files)
        (print lumen-read-usage)
      (step x files
        (print (pp-to-string (read-from-file x)))))))

(lumen-read)
