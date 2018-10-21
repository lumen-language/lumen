(define reader (require "./reader"))
(define compiler (require "./compiler"))
(define system (require "./system"))

(define eval-print (form)
  (let ((ok v) (guard ((compiler .eval) `(results ,form))))
    (if (not ok)
        (target
          js: (print (get v 'stack))
          lua: (print (cat "error: " (get v 'message) "\n" (get v 'stack))))
      (step x v
        (when (or (is? x) (> (# v) 1))
          (print (str x)))))))

(define rep (s)
  (eval-print ((reader .read-string) s)))

(define repl ()
  (let buf ""
    (define rep1 (s)
      (cat! buf s)
      (let (more ()
            form ((reader .read-string) buf more))
          (unless (= form more)
            (eval-print form)
            (set buf "")
            ((system .write) "> ")))))
  ((system .write) "> ")
  (if process
      (do (process .stdin (.remove-all-listeners))
          (target js: (process .stdin (.set-encoding "utf8")))
          (process .stdin (.on "data" rep1)))
    (target lua:
      (while true
        (let s ((io .read))
          (if s (rep1 (cat s "\n")) (break)))))))

(define-global read-file (path)
  ((system .read-file) path))

(define-global write-file (path data)
  ((system .write-file) path data))

(define-global read-from-file (path)
  (let (s ((reader .stream) ((system .read-file) path))
        body ((reader .read-all) s))
    `(do ,@body)))

(define-global expand-file (path)
  ((compiler .expand) (read-from-file path)))

(define-global compile-file (path)
  (let form (expand-file path)
    ((compiler .compile) form stmt: true)))

(define-global load (path)
  (let previous target*
    (set target* (language))
    (let code (compile-file path)
      (set target* previous)
      ((compiler .run) code))))

(define-global script-file? (path)
  (and (string? path)
       (not (or (= "-" (char path 0))
                (= ".js" (clip path (- (# path) 3)))
                (= ".lua" (clip path (- (# path) 4)))))))

(define-global run-file (path)
  (if (script-file? path)
      (load path)
    ((compiler .run) (read-file path))))

(define-global run-script (file argv)
  (set-argv argv)
  (let ((main: main) (run-file file))
    (if (nil? main)
        (error (cat "main not exported for script file " (str file)))
      (main argv))))

(define-global read-from-string (str start end)
  (let s ((reader .stream) str)
    (set (get s 'pos) (either start (get s 'pos))
         (get s 'len) (either end (get s 'len)))
    (let form ((reader .read) s)
      (if (nil? form)
          (error "End of string during parsing")
        `(,form rest: ,(get s 'pos))))))

(define-global readable-string? (str)
  (and (string? str)
       (let ((ok v) (guard (read-from-string str)))
         (and ok (= (hd v) str)))))

(define-global pp-to-string (x stack)
  (if (= x nil) "nil"
      (= x null) "null"
      (nan? x) "nan"
      (= x inf) "inf"
      (= x -inf) "-inf"
      (boolean? x) (if x "true" "false")
      (string? x) (if (readable-string? x) x (escape x))
      (function? x) "function"
      (atom? x) (tostring x)
      (and stack (in? x stack)) "circular"
      (target js: false lua: (not (= (type x) 'table)))
      (escape (tostring x))
    (let (s "(" sp ""
          xs () ks ()
          l (or stack ()))
      (add l x)
      (each (k v) x
        (if (number? k)
            (set (get xs k) (pp-to-string v l))
          (do (target lua:
                (unless (string? k)
                  (set k (pp-to-string k l))))
              (add ks (cat k ":"))
              (add ks (pp-to-string v l)))))
      (drop l)
      (each v (join xs ks)
        (cat! s sp v)
        (set sp " "))
      (cat s  ")"))))

(define usage () "
Usage:
  lumen <file> [<args>...]
  lumen [options] [<object-files>...]

  <file>          Program read from script file
  <object-files>  Loaded before compiling <input>

Options:
  -c <input>...   Compile input files
  -o <output>     Write compiler output to <output>
  -t <target>     Set target language (default: lua)
  -e <expr>...    Expressions to evaluate
")

(define main (argv)
  (if (script-file? (hd argv))
      (run-script (hd argv) (tl argv))
    (let args (parse-arguments
                (obj c: 'compile
                     o: 'output
                     t: 'target
                     e: 'eval
                     h: 'help
                     r: 'repl)
                argv)
      (if (script-file? (hd args))
          (run-script (hd args) (tl args))
          (get args 'help)
          (print (usage))
        (let (pre (keep string? args)
              cmds (keep obj? args)
              input ""
              enter-repl true)
          (step file pre
            (run-file file))
          (step (a val) cmds
            (when (= a 'target)
              (set target* (hd val))
              (break)))
          (step (a val) cmds
            (if (= a 'help) (print (usage))
                (= a 'repl) (set enter-repl true)
                (or (boolean? val) (none? val))
                (print (cat "missing argument for " a))
                (= a 'compile) (do (step x val (cat! input (compile-file x))) (set enter-repl false))
                (= a 'output) (do (write-file (hd val) input) (set input ""))
                (= a 'target) (set target* (hd val))
                (= a 'eval) (do (step x val (rep x)) (set enter-repl false))))
          (if (some? input) (print input))
          (if (or enter-repl (get args 'repl)) (repl)))))))

(export reader compiler system usage main)
