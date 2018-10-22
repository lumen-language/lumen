(target js: (define fs (require 'fs)))
(target js: (define child_process (require 'child_process)))

(target lua:
  (define call-with-file (f path mode)
    (let ((h e) (list ((get io 'open) path mode)))
      (unless h
        (error e))
      (with x (f h)
        ((get h 'close) h)))))

(define read-file (path)
  (target
    js: ((get fs 'readFileSync) path 'utf8)
    lua: (call-with-file
          (fn (f) ((get f 'read) f '*a))
          path)))

(define write-file (path data)
  (target
    js: ((get fs 'writeFileSync) path data 'utf8)
    lua: (call-with-file
          (fn (f) ((get f 'write) f data))
          path 'w)))

(define file-exists? (path)
  (target
    js: (and ((get fs 'existsSync) path 'utf8)
             ((get ((get fs 'statSync) path) 'isFile)))
    lua: (let f ((get io 'open) path)
           (and (is? f)
                (with r (or (is? ((get f 'read) f 0))
                            (= 0 ((get f 'seek) f 'end)))
                  ((get f 'close) f))))))

(define directory-exists? (path)
  (target
    js: (and ((get fs 'existsSync) path 'utf8)
             ((get ((get fs 'statSync) path) 'isDirectory)))
    lua: (let f ((get io 'open) path)
           (and (is? f)
                (with r (and (not ((get f 'read) f 0))
                             (not (= 0 ((get f 'seek) f 'end))))
                  ((get f 'close) f))))))

(define path-separator
  (target
    js: (get (require 'path) 'sep)
    lua: (char (get (get _G 'package) 'config) 0)))

(define path-join (a ...)
  (reduce (fn (x y) (cat x path-separator y)) (list ...) a))

(define get-environment-variable (name)
  (target
    js: (get (get process 'env) name)
    lua: ((get os 'getenv) name)))

(define stdout ()
  ((or process io) .stdout))

(define stderr ()
  ((or process io) .stderr))

(define write (x out)
  ((or out (stdout)) (.write x)))

(define exit (code)
  (target js: ((get process 'exit) code)
          lua: ((get os 'exit) code)))

(define argv nil)

(define-global set-argv (l)
  (set argv l))

(define-global get-argv ()
  (when (nil? argv)
    (set-argv (target js: (cut (get process 'argv) 2)
                      lua: (or (get _G 'arg) (get _G 'args) ()))))
  argv)

(define opt? (x)
  (and (string? x) (= (char x 0) "-") (not (= x "-"))))

(define-global parse-positional (args pos)
  (cut args (either pos 0) (first opt? args pos)))

(define-global parse-option (args)
  (when (opt? (hd args))
    `(,(hd args) ,(parse-positional args 1))))

(define-global parse-arguments (aliases argv)
  (let (l (or argv (get-argv))
        a (or aliases (obj)))
    (with r (parse-positional l)
      (set l (cut l (# r)))
      (while true
        (let p (parse-option l)
          (unless p (break))
          (let-when (o args) p
            (when (= o "--")
              (set l (cut l 1))
              (break))
            (set l (cut l (+ 1 (# args))))
            (let (k (if (= (clip o 0 2) "--") (clip o 2) (clip o 1))
                  k (or (get a k) k)
                  v (if (none? args) true args))
              (set (get r k) v)
              (add r (list k v))))))
      (set (get r 'rest) l)
      (set-argv (get r 'rest)))))

(define-global arguments (aliases argv)
  (let argv (or argv (get-argv))
    (let r (parse-arguments argv aliases)
      (set-argv (get r 'rest))
      (wipe (get r 'rest))
      (unless (empty? r) r))))

(define reload (module)
  (wipe (target
          lua: (get (get package 'loaded) module)
          js: (get (get require 'cache) ((get require 'resolve) module))))
  (require module))

(define-global shell (command)
  (with s (target
            js: ((get ((get child_process 'execSync) command) 'toString))
            lua: (let f ((get io 'popen) command)
                   (with x ((get f 'read) f '*all)
                     ((get f 'close) f))))
    (when (= (char s (edge s)) "\n")
      (set s (clip s 0 (edge s))))
    (when (= (char s (edge s)) "\r")
      (set s (clip s 0 (edge s))))))

(define-global rand-string (n)
  (let n (* 2 (or n 16))
    (let s ""
      (while (< (# s) n)
        (cat! s (shell "cat /dev/urandom | xxd -l 64 -c 64 -ps")))
      (clip s 0 n))))

(export read-file
        write-file
        file-exists?
        directory-exists?
        path-separator
        path-join
        get-environment-variable
        stdout
        stderr
        write
        exit
        get-argv
        set-argv
        arguments
        reload
        shell)
