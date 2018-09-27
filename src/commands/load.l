#!/usr/bin/env lumen

(define-global lumen-load "
Load a Lisp file.

Usage:
  lumen load <filename>
")

(define-global lumen-load (filename)
  (if filename
      (do (print (cat "loading " filename))
          (load-file filename))
    (print lumen-load-usage)))

(let x (arguments)
  (print (str `(arguments ,x)))
  (apply lumen-load x))

