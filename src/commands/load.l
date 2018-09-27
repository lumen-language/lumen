#!/usr/bin/env bin/lumen

(define-global lumen-load-usage "
Load a Lisp file.

Usage:
  lumen load <filename>
")

(define-global lumen-load (argv)
  (set argv (or argv (arguments) ()))
  (if (hd argv)
      (let filename (hd argv)
        (set-argv (tl argv))
        (load-file filename))
    (print lumen-load-usage)))

(lumen-load)

