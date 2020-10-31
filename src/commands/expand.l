#!/usr/bin/env bin/lumen

(define usage () "
Read a Lisp file.

Usage:
  lumen-read <filename>...
")

(define main (argv)
  (let (args (parse-arguments
               (obj h: 'help)
               argv)
        files (keep string? args))
    (if (none? files)
        (print (usage))
      (step x files
        (print (pp-to-string (expand-file x)))))))

(export usage main)
