#!/usr/bin/env bin/lumen

(define usage () "
Load a Lisp file.

Usage:
  lumen load <filename>
")

(define main (argv)
  (set argv (or argv (get-argv) ()))
  (if (hd argv)
      (let filename (hd argv)
        (set-argv (tl argv))
        (run-script filename))
    (print (usage))))

(export usage main)

