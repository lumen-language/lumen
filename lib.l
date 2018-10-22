(set t true)

(def str! (...)
  (with s ""
    (step x (list ...)
      (cat! s (pp-to-string x)))))

(def queue ()
  (list))

(def hook () nil)

(mac aif (x then rest: else)
  `(let it ,x
     (if (not (= it nil))
         ,then
       ,(if (none? else) '(do)
            (one? else) (hd else)
          `(aif ,@else)))))

(mac awhen (expr rest: body)
  `(aif ,expr (do ,@body)))

(mac aand args
  (if (none? args) true
      (none? (tl args))
      (hd args)
    `(awhen ,(hd args)
       (aand ,@(tl args)))))

(def some (test seq)
  (let f (testify test)
    (let-when i (first f seq)
      (return true))))

(def all (test seq)
  (no (some (complement (testify test)) seq)))

(def mem (test seq)
  (let f (testify test)
    (let-when i (first f seq)
      (cut seq i))))

(def chars (s)
  (let n (# s)
    (accum a
      (for i n
        (let c (char s i)
          (a c))))))

(def concat (l)
  (apply cat l))

(def rem (test seq)
  (let f (testify test)
    (if (string? seq)
        (concat (rem test (chars seq)))
      (keep (complement f) seq))))

; (def keep (test seq)
;   (rem (complement (testify test)) seq))

(def count (test l)
  (with n 0
    (let f (testify test)
      (step x l
        (let-when y (f x)
          (inc n))))))

(mac accum (f rest: body)
  (let-unique (r)
    `(with r ()
       (let ,f (fn (x) (add r x))
         ,@body))))

(def drain (f eof)
  (with r ()
    (while true
      (let x (f)
        (if (= x eof)
            (break)
            (add r x))))))

(mac drain (expr eof)
  `(%call drain (fn () ,expr) ,eof))

(mac check (x test alt)
  (let-unique (v)
    `(let ,v ,x
       (if (,test ,v) ,v ,alt))))

(mac init args
  `(do ,@(map (fn ((lh rh))
                `(if (undefined? ,lh) (set ,lh ,rh)))
              (pair args))))

(def only (f)
  (fn (x ...) (if (not (= x nil)) (f x ...))))

(def avg (ns) (/ (apply + ns) (# ns)))

(def even (n) (= (% n 2) 0))
(def odd (n) (= (% n 2) 1))

; ; The problem with returning a list instead of multiple values is that
; ; you can't act as if the fn didn't return multiple vals in cases where
; ; you only want the first.  Not a big problem.

(def round (n)
  (let (base (trunc n) rem (abs (- n base)))
    (if (> rem 0.5) (if (> n 0) (+ base 1) (- base 1))
        (< rem 0.5) base
        (odd base)  (if (> n 0) (+ base 1) (- base 1))
                    base)))

(def roundup (n)
  (let (base (trunc n) rem (abs (- n base)))
    (if (>= rem 0.5) 
        (if (> n 0) (+ base 1) (- base 1))
        base)))

; (def round (n)
;   (target js: ((get Math 'round) n)
;           lua: (error "todo")))


(def med (ns test)
  (init test >)
  (at (sort (cut ns) test)
      (round (/ (# ns) 2))))

(def stream (...)
  (((require 'reader) .stream) ...))

(def read (x ...)
  (if (string? x)
      (read (stream x) ...)
    (((require 'reader) .read) x ...)))

(def readfile (name)
  (readall (stream (read-file name))))

(def readall (s)
  (let e (obj)
    (drain (read s e) e)))

(def mvfile (src dst)
  (shell (cat "mv " (escape src) " " (escape dst))))

(def table->json (v)
  ((JSON .stringify) (tablist v)))

(def json->table (v)
  (listtab ((JSON .parse) v)))

(def writefile (val file)
  (let tmpfile (cat file ".tmp")
    (write-file tmpfile val)
    (mvfile tmpfile file))
  val)

(def load-table (file)
  ; (read-table (stream (read-file file))))
  (json->table (read-file file)))

(def save-table (h file)
  (writefile (table->json h) file))

; (def read-table (i eof)
;   (let e (read i eof)
;     (unless (= e eof) e)))

; (def load-tables (file)
;   (let (i (stream (read-file file))
;         eof (obj))
;     (with r ()
;       (while true
;         (let h (read i eof)
;           (if (= h eof) (break) (add r h)))))))

(def load-tables (file)
  (map json->table (keep some? (split (read-file file) "\n"))))

(def save-tables (l file)
  (let s ""
    (step h l
      (cat! s (table->json h) "\n"))
    (writefile s file)))

(def listtab (l)
  (with r (obj)
    (step (k v) l
      (if (number? k)
          (set (at r k) v)
        (set (get r k) v)))))

(def tablist (h)
  (with r ()
    (each (k v) h
      (add r (list k v)))))

(def assoc (key al)
  (let-when i (first (fn (x) (hd? x key)) al)
    (at al i)))

(def alref (al key)
  (let-when l (assoc key al)
    (at l 1)))

(def union (f xs ys)
  (join xs (rem (fn (y) (some (fn (_) (f _ y)) xs))
                ys)))

(init templates* (obj))

(mac deftem (tem rest: fields)
  (let (name (if (obj? tem) (hd tem) tem)
        includes (if (obj? tem) (tl tem) ()))
    `(set (get templates* ',name)
          (join (apply join (map (fn (x)
                                   (get templates* x))
                                 ',(reverse includes)))
                (list ,@(map (fn ((k v)) `(list ',k (fn () ,v)))
                             (pair fields)))))))

(mac addtem (name rest: fields)
  `(set (get templates* ',name)
        (union (fn (x y) (and (obj? x) (obj? y) (= (hd x) (hd y))))
               (list ,@(map (fn ((k v)) `(list ',k (fn () ,v)))
                            (join (pair fields) (tablist (props fields)))))
               (get templates* ',name))))

(def inst (tem rest: args)
  (with x (obj)
    (step (k v) (if (obj? tem) tem (get templates* tem))
      (unless (no v) (set (get x k) (v))))
    (step (k v) (pair args)
      (set (get x k) v))
    (each (k v) (props args)
      (set (get x k) v))))

(def temread (tem str)
  (templatize tem (read str)))

(def templatize (tem raw)
  (with x (inst tem)
    (let fields (if (obj? tem) tem (get templates* tem))
      (each (k v) raw
        (when (assoc k fields)
          (set (get x k) v))))))

(def temload (tem file)
  ; (temread tem (stream (read-file file))))
  (templatize tem (load-table file)))

(def temloadall (tem file)
  ; (map (fn (pairs) (templatize tem pairs))
  ;      (readfile file)))
  (map (fn (x) (templatize tem x)) (load-tables file)))

(def seconds ()
  (target js: (trunc (/ ((Date .now)) 1000))
          lua: ((os .time))))

(def msec ()
  (target lua: (+ (* (seconds) 1000)
                  (% (/ ((uv .hrtime)) 1000000) 1000))
          js: ((Date .now))))

(deftem profile
  id         nil
  name       nil
  created    (seconds)
  auth       0
  member     nil
  submitted  nil
  votes      nil   ; for now just recent, elts each (time id by sitename dir)
  karma      1
  avg        nil
  weight     .5
  ignore     nil
  email      nil
  about      nil
  showdead   nil
  noprocrast nil
  firstview  nil
  lastview   nil
  maxvisit   20 
  minaway    180
  topcolor   nil
  keys       nil
  delay      0)

(deftem item
  id         nil
  type       nil
  by         nil
  ip         nil
  time       (seconds)
  url        nil
  title      nil
  text       nil
  votes      nil   ; elts each (time ip user type score)
  score      0
  sockvotes  0
  flags      nil
  dead       nil
  deleted    nil
  parts      nil
  parent     nil
  kids       nil
  keys       nil)

(deftem post  id nil  title nil  text nil)

(def on-err (handler thunk)
  (let ((ok v) (guard (thunk)))
    (if ok v (handler v))))

(mac errsafe (expr)
  `(on-err (fn (c) nil)
           (fn () ,expr)))

(def saferead (arg ...) (errsafe (read arg ...)))

(def safe-load-table (filename)
  (or ((compose errsafe load-table) filename)
      (obj)))

(def dir-exists (path)
  (((require 'system) .directory-exists?) path))

(def ensure-dir (path)
  (unless (dir-exists path)
    (shell (cat "mkdir -p " (escape path)))))

(def date (secs)
  (init secs (seconds))
  (shell (cat "date -ur " (escape (str! secs)) " +%Y%m%d-%H%M%S")))

(def datestring (secs)
  (hd (split (date secs) "-")))
