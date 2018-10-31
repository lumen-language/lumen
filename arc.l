(when-compiling
  (set expand-atom-functions* (list expand-compose expand-ref expand-and expand-jsx))
  nil)

(target js:
  (set React (require 'react)
       ReactDOM (require 'react-dom/server)))

(target js:
  (define-global html (x)
    ((ReactDOM .renderToStaticMarkup) x)))
        
  
(during-compilation
(define-macro def args
  `(during-compilation
     (define-global ,@args)))

(define-macro mac args
  `(during-compilation
     (define-macro ,@args)))

(define-macro is args `(== ,@args))
; (define-macro table args `(obj ,@args))

(define-macro = args
  `(%do ,@(map (fn ((lh rh))
                 (let-place (getter setter) lh
                   (setter rh)))
               (pair args))))

(define-macro errsafe (x)
  `(let ((ok v) (guard ,x))
     (if ok v)))

(= is ==)

(define-macro + args
  (if (find string-literal? args)
      `(cat ,@args)
    `(%call + ,@args)))

; This strange-looking macro sets up a global variable to act
; similar to Arc's:
;
; (defvar foo* (obj))
; > (set (foo* 'bar) 42)
; 42
; > (foo* 'bar)
; 42
; > (foo*)
; (bar: 42)
;
(define-macro defvar (name value init: init?)
  (let (id (cat "*" name) value (either value '(%object)))
    `(do ,(if init? `(set ,id ,value) `(if (undefined? ,id) (set ,id ,value)))
           (define-global ,name (k)
             (if (nil? k) ,id (get ,id k)))
         (during-compilation
           (define-setter ,name (v k)
             (if (nil? k)
                 `(set ,',id ,v)
               `(set (get ,',id ,k) ,v))))
         ,name)))

(define-macro defconst args
  `(defvar ,@args init: true))


(define-setter profile (v l)
  `(set (prof* ,l) ,v))

(define-macro w/uniq (args rest: body)
  (let x (if (atom? args) (list args) args)
    `(let-unique ,x ,@body)))

(define-macro do1 (x rest: args)
  (let-unique (v)
    `(with ,v ,x ,@args)))

(define-macro t? ((o x true))
  `(not (== ,x nil)))

(define-macro forlen (var start: (o start 0) xs . body)
  (let-unique (n l)
    `(let (,l ,xs
           ,n (# ,l)
           ,var ,start)
       (while (< ,var ,n)
         ,@body
         (inc ,var)))))


)

(during-compilation

(define-macro rfn (name args . body)
  `(let ,name nil
     (%set ,name (fn ,args ,@body))))

(define-macro afn (args . body)
  `(rfn self ,args ,@body))

; Destructuring means ambiguity: are pat vars bound in else? (no)

(define-macro iflet (var expr then rest: rest)
  (let-unique (gv)
    `(let ,gv ,expr
       (if (t? ,gv) (let (,var ,gv) ,then) ,@rest))))

(define-macro whenlet (var expr rest: body)
  `(iflet ,var ,expr (do ,@body)))

(define-macro aif (expr rest: body)
  `(let it ,expr
     (if (t? it)
         ,@(if (some? (cut body 2))
               `(,(car body) (aif ,@(cdr body)))
               body))))

(define-macro awhen (expr rest: body)
  `(let it ,expr (if (t? it) (do ,@body))))

(define-macro aand args
  (if (none? args)
      true
      (none? (cdr args))
       (car args)
      `(let it ,(car args) (and it (aand ,@(cdr args))))))

(mac accum (f rest: body)
  (let-unique (r)
    `(with ,r ()
       (let ,f (fn (x) (add ,r x))
         ,@body))))

(define-macro until (test . body)
  `(while (no ,test) ,@body))

(define-global drain (f eof)
  (with r ()
    (while true
      (let x (f)
        (if (is x eof)
            (break)
            (add r x))))))

(define-macro drain (expr eof)
  `(%call drain (fn () ,expr) ,eof))


)


(during-compilation

(define-global shell (x)
  (with x (((require 'system) .run) x)
    (if (is (char x (edge x)) #\newline)
        (set x (clip x 0 (edge x))))
    (if (is (char x (edge x)) #\return)
        (set x (clip x 0 (edge x))))))

(define-global stream (x ...)
  (if (string? x)
      (((require 'reader) .stream) x ...)
    x))

(define-global read (x ...)
  (unless (no? x)
    (if (string? x)
        (readstring1 x ...)
        (((require 'reader) .read) x ...))))

(define-global readstring1 (s eof)
  (read (stream s) eof))

(define-global readfile (name)
  (let s (stream (read-file name))
    (drain (read s))))

(define-global readall (src (o eof (obj)))
  (if (string? src)
      (readall (stream src) eof)
    (accum a
      (while true
        (let x (read src eof)
          (if (is x eof) (break) (a x)))))))

(define-global saferead (arg)
  (errsafe:read arg))

(define-global safe-load-table (filename)
  (or (errsafe:load-table filename)
      (obj)))

(define-global ensure-dir (path)
  (shell (cat "mkdir -p " (escape path))))

(define-global dir (path)
  (keep some? (split (shell (cat "ls -1 " (escape path))) "\n")))

(define-global file-exists (path)
  (if (((require 'system) .file-exists?) path) path))

(define-global seconds ()
  (target js: (trunc (/ ((Date .now)) 1000))
          lua: ((os .time))))

(define-global msec ()
  (target ;lua: (+ (* (seconds) 1000) (% (/ ((uv .hrtime)) 1000000) 1000))
          lua: (* 1000 ((os .clock)))
          js: ((Date .now))))

(define-global downcase (s)
  (target lua: (tostring ((ustring .lower) ((ustring .new) s)))
          js: (s (.to-locale-lower-case))))

(define-global since (t1) (- (seconds) t1))

(define-global minutes-since (t1) (/ (since t1) 60))
(define-global hours-since (t1)   (/ (since t1) 3600))
(define-global days-since (t1)    (/ (since t1) 86400))


(define-global insortnew (test elt seq)
  (unless (is elt nil)
    (if (is seq nil) (= seq ()))
    (add seq elt)
    (sort seq test))
  seq)

; Could make this look at the sig of f and return a fn that took the 
; right no of args and didn't have to call apply (or list if 1 arg).

(define-global memo (f)
  (let (cache (obj) nilcache (obj))
    (fn (...)
      (let args (str (list ...))
        (or (get cache args)
            (and (no (get nilcache args))
                 (aif (f ...)
                      (= (get cache args) it)
                      (do (set (get nilcache args) true)
                          nil))))))))


(define-macro defmemo (name parms . body)
  `(define-global ,name (memo (fn ,parms ,@body))))


(define-global bound (x)
  (eval `(not (undefined? ,x))))
)

(during-compilation

(= t true
   #\space " "
   #\newline "\n"
   #\tab "\t"
   #\return "\r"
   #\a "a"
   #\z "z"
   #\A "A"
   #\Z "Z"
   #\0 "0"
   #\9 "9"
   #\" "\""
   #\' "'"
   #\* "*"
   #\. "."
   #\, ","
   #\; ";"
   #\: ":"
   #\! "!"
   #\? "?"
   #\< "<"
   #\( "("
   #\[ "["
   #\{ "{"
   #\> ">"
   #\) ")"
   #\] "]"
   #\} "}"
   #\/ "/"
   #\\ "\\"
   #\? "?"
   #\  " "
   )
)


(during-compilation

(define-global empty (x)
  (or (nil? x)
      (and (obj? x) (empty? x))
      (and (string? x) (none? x))))

(define-global no? (x) (or (== x false) (empty x)))
(define-global yes? (x) (not (no? x)))

(define-global alist (x)
  (obj? x))

(define-global acons (x) 
  (and (alist x) (not (empty? x))))

(define-global atom (x)
  (~acons x))

(define-global expt (n k) (pow n k))
(define-global rand (...) (random ...))
(define-global mod (n k) (% n k))
(define-global filechars (...) (read-file ...))

(define-global cons (a b) (if (nil? b) (list a) (obj? b) `(,a ,@b) `(,a rest: ,b)))
(define-global car (x) (if (nil? x) x (hd x)))
(define-global cdr (x) (if (nil? x) x (tl x)))
(define-global caar (x) (car (car x)))
(define-global cadr (x) (at x 1))
(define-global cdar (x) (cdr (car x)))
(define-global cddr (x) (cdr (cdr x)))

(define-global carif (x)
  (if (atom x) x (car x)))

(define-global assoc (key al)
  (if (atom al)
       nil
      (and (acons (car al)) (is (car (car al)) key))
       (car al)
      (assoc key (cdr al))))

(define-global alref (al key) (car (cdr (assoc key al))))

; (define-global in (x ...)
;   (in? x (list ...)))

(define-macro in (x . choices)
  (when (some? choices)
    (if (one? choices)
        `(is ,x ,@choices)
      (w/uniq g
        `(let ,g ,x
           (or ,@(map (fn (c) `(is ,g ,c)) choices)))))))

(define-global keys (h)
  (if (function? h)
      (keys (h))
    (with l ()
      (each (k v) h
        ; (unless (number? k)
          (add l k)))))

(define-global idfn (x) x)
)

(during-compilation
; (define-global pos (test seq (o start 0))
;   (let f (testify test)
;     (if (alist seq)
;         ((afn (seq n)
;            (if (no? seq)   
;                 nil
;                (f (car seq)) 
;                 n
;                (self (cdr seq) (+ n 1))))
;          (nthcdr start seq) 
;          start)
;         (recstring [if (f (seq _)) _] seq start))))

(define-global pos (test seq (o start 0))
  (mem test seq start))

(define-global even (n) (is (mod n 2) 0))

(define-global odd (n) (~even n))

(define-global avg (ns) (/ (apply + ns) (# ns)))

; ; The problem with returning a list instead of multiple values is that
; ; you can't act as if the fn didn't return multiple vals in cases where
; ; you only want the first.  Not a big problem.

(define-global round (n)
  (let (base (trunc n) rem (abs (- n base)))
    (if (> rem 0.5) (if (> n 0) (+ base 1) (- base 1))
        (< rem 0.5) base
        (odd base)  (if (> n 0) (+ base 1) (- base 1))
                    base)))

(define-global roundup (n)
  (let (base (trunc n) rem (abs (- n base)))
    (if (>= rem 0.5) 
        (if (> n 0) (+ base 1) (- base 1))
        base)))

; (def round (n)
;   (target js: ((get Math 'round) n)
;           lua: (error "todo")))


(define-global med (ns (o test >))
  (at (sort (cut ns) test)
      (round (/ (# ns) 2))))



; Could combine with firstn if put f arg last, default to (fn (x) t).

(define-global retrieve (n f xs)
  (if (no? n)                (keep f xs)
      (or (<= n 0) (no? xs)) nil
      (f (car xs))           (cons (car xs) (retrieve (- n 1) f (cdr xs)))
                             (retrieve n f (cdr xs))))
(define-global dedup (xs)
  (let (h (obj) acc nil)
    (each x xs
      (unless (get h x)
        (push x acc)
        (set (get h x) true)))
    (rev acc)))

(define-global single (x) (and (acons x) (no (cdr x))))

(define-global intersperse (x ys)
  (and ys (cons (car ys)
                (mappend [list x _] (cdr ys)))))

(define-global counts (seq (o c (obj)))
  (if (no? seq)
      c
      (let x (car seq)
        (unless (is x nil)
          (unless (has? c x) (set (get c x) 0))
          (inc (get c x)))
        (counts (cdr seq) c))))

(define-global commonest (seq)
  (let (winner nil n 0)
    (each (k v) (counts seq)
      (when (> v n) (= winner k n v)))
    (list winner n)))


(define-global iso (a b)
  (== (str a) (str b)))

(define-global reclist (f xs (o start 0))
  (unless (== xs nil)
    (forlen i xs start: start
      (let (x (at xs i)
            v (f x i xs))
        (if v (return v))))))
; (and (yes? xs) (let v (f xs) (if (t? v) v (reclist f (cdr xs))))))

(define-global recstring (test s (o start 0))
  (unless (nil? s)
    (forlen i s start: start
      (let v (test i)
        (if (yes v) (return v))))))
  ; ((afn (i)
  ;    (and (< i (# s))
  ;         (or (test i)
  ;             (self (+ i 1)))))
  ;  start))


; (define-global some (f x)
;   (unless (nil? x)
;     (find f x)))
)
(during-compilation

(define-global some (test seq)
  (let f (testify test)
    (if (alist seq)
        (reclist f seq)
        (recstring [f:char seq _] seq))))


(define-global all (test seq)
  (~some (complement (testify test)) seq))

; (define-global mem (f x (o test is))
;   (unless (nil? x)
;     (first [test f _] x)))

(define-global mem (test seq (o start 0))
  (let f (testify test)
    (if (alist seq)
        (reclist (fn (x i ...)
                   (let v (f x i ...)
                     (when (yes v)
                       i)))
                 seq
                 start)
      (recstring [if (f:char seq _) _] seq start))))

(define-global crawl (test seq)
  (let (f (testify test)
        f (fn (x ...) (if (yes (f x ...)) x)))
    (if (alist seq)
        (reclist f seq)
        (recstring f seq))))

(define-global chars (x)
  ((ustring .new) x))

(define-global concat (xs (o sep ""))
  (target lua: ((table .concat) xs sep)
          js: (xs (.join sep))))

(define-global rem (f x)
  (if (alist x)
      (unless (nil? x)
        (let i (first f x)
          (if (number? i)
              (join (cut x 0 i) (rem f (cut x (+ i 1))))
            x)))
      (concat (rem f (chars x)))))

(define-global keep (test seq)
  (rem (complement (testify test)) seq))

)

(during-compilation

(define-global adjoin (x xs (o test iso))
  (if (nil? xs) (list x)
      (is? (first [test x _] xs)) xs
    (do (add xs x) xs)))

(define-macro pushnew (x place rest: args)
  `(set ,place (adjoin ,x ,place ,@args)))

(define-global push! (x l)
  (if (nil? l) (list x) `(,x ,@l)))

(define-macro push (x place)
  `(set ,place (push! ,x ,place)))

(define-macro pull (x place rest: args)
  `(set ,place (rem ,x ,place ,@args)))

(define-macro togglemem (x place rest: args)
  (let-unique (v)
    `(let ,v ,x
       (set ,place (if (mem ,v ,place)
                       (rem ,v ,place)
                       (adjoin ,v ,place ,@args))))))

(define-global mappend (f l)
  (if (nil? l) l (apply join (map f l))))

(define-global rev (l)
  (if (nil? l) l (reverse l)))

(define-global firstn (n xs)
  (if (nil? xs) xs (string? xs) (clip xs 0 n) (cut xs 0 n)))

(define-global int (x)
  (let s (tostring x)
    (if (numeric? s) (number s))))

(define-global compare (comparer scorer)
  (fn (x y) (comparer (scorer x) (scorer y))))

(define-global merge (less? ...)
  (sort (join ...) less?))

(define-global bestn (n f (o seq ()))
  (firstn n (sort seq f)))

(define-macro down (v init min . body)
  (w/uniq (gi gm)
    `(let (,gi ,init ,v ,gi ,gm (- ,min 1))
       (while (> ,v ,gm)
         ,@body
         (dec ,v)))))

(define-macro repeat (n . body)
  `(for ,(unique 'i) ,n ,@body))

(define-macro n-of (n expr)
  (w/uniq ga
    `(accum ,ga
       (repeat ,n (,ga ,expr)))))

(define-global hook (name ...)
  (do))

)

(during-compilation

(define-global whitec (c)
  (in c #\space #\newline #\tab #\return))

(define-global nonwhite (c) (no (whitec c)))

(define-global letter (c) (or (<= #\a c #\z) (<= #\A c #\Z)))

(define-global digit (c) (<= #\0 c #\9))

(define-global alphadig (c) (or (letter c) (digit c)))

(define-global punc (c)
  (in c #\. #\, #\; #\: #\! #\?))

(define-global blank (s) (~first ~whitec ((ustring .new) s)))

(define-global nonblank (s) (unless (blank s) s))

(define-global trim (s (o where 'both) (o test whitec))
  (let (f  (testify test)
        p1 (pos ~f s))
    (if p1
        (clip s 
             (if (in where 'front 'both) p1 0)
             (when (in where 'end 'both)
               (let i (edge s)
                 (while (and (> i p1) (yes (f (char s i))))
                   (dec i))
                 (+ i 1))))
        "")))

(def newstring (n s)
  (with r ""
    (for i n
      (cat! r s))))

(def num (n (o digits 2) (o trail-zeros nil) (o init-zero nil))
  (let (comma
          (fn (i)
            (tostring
              (map [apply pr (rev _)]
                   (rev (intersperse (list #\,)
                                     (tuples (rev (chars (tostring i)))
                                             3))))))
          abrep
          (let a (abs n)
            (if (< digits 1)
                 (comma (roundup a))
                (exact a)
                 (tostr (comma a)
                         (when (and trail-zeros (> digits 0))
                           (tostr "." (newstring digits #\0))))
                 (let   (d (expt 10 digits)
                         m (/ (roundup (* a d)) d)
                         i (trunc m)
                         r (abs (trunc (- (* m d) (* i d)))))
                   (+ (if (is i 0) 
                          (if (or init-zero (is r 0)) "0" "") 
                          (comma i))
                      (let   (rest   (tostr r)
                              padded (+ (newstring (- digits (len rest)) #\0)
                                        rest)
                              final  (if trail-zeros
                                         padded
                                         (trim padded 'end [is _ #\0])))
                        (tostr (unless (empty final) ".")
                               final)))))))
    (if (and (< n 0) (mem [and (digit _) (isnt _ #\0)] abrep))
        (+ "-" abrep)
        abrep)))

; English

(def pluralize (n str)
  (if (or (is n 1) (single n))
      str
      (tostr str "s")))

(def plural (n x)
  (tostr n #\  (pluralize n x)))



(= white (gray 255)
   black (gray 0)
   linkblue (color 0 0 190)
   orange (color 255 102 0)
   darkred (color 180 0 0)
   darkblue (color 0 0 120))

(mac tag-if (test spec rest: body)
  `(if ,test
       (tag ,spec ,@body)
      (do ,@body)))

(def link (text (o dest text) (o color))
  (tag (a href dest) 
    (tag-if color (font color color)
      text)))

(def underlink (text (o dest text))
  (tag (a href dest) (tag u (pr text))))

(mac fontcolor (c . body)
  (w/uniq g
    `(let ,g ,c
       (if ,g
           (tag (font color ,g) ,@body)
           (do ,@body)))))

(mac spanclass (name . body)
  `(tag (span className ',name) ,@body))

(def pagemessage (text)
  (when text (prn text (br2))))

; Could be stricter.  Memoized because looking for chars in Unicode
; strings is terribly inefficient in Mzscheme.

(defmemo valid-url (url)
  (and (len> url 10)
       (or (begins url "http://")
           (begins url "https://"))
       (~mem [in _ #\< #\> #\" #\'] url)))


(define-global clean-url (u)
  (rem [in _ #\" #\' #\< #\>] u))

(def count (test x)
  (let (n 0 testf (testify test))
    (unless (nil? x)
      (step elt x
        (if (testf elt) (inc n))))
    n))

(define-global ellipsize (str (o limit 80))
  (if (<= (# str) limit)
      str
      (cat (clip str 0 limit) "...")))

(define-global litmatch (pat string (o start 0))
  (is (search string pat start) start))

(define-global elt (seq i)
  (if (string? seq)
      (char seq i)
      (at seq i)))

(define-global posmatch (pat seq (o start 0))
  (if (function? pat)
      (for i (- (len seq) 1)
        (when (>= i start)
          (when (pat (elt seq i)) (return i))))
      (for i (- (len seq) (len pat))
        (when (>= i start)
          (when (headmatch pat seq i) (return i)))))
  nil)

(define-global headmatch (pat seq (o start 0))
  (let p (len pat) 
    ((afn (i)      
       (or (is i p) 
           (and (is (elt pat i) (elt seq (+ i start)))
                (self (+ i 1)))))
     0)))

(= bar* " | ")

(mac w/bars body
  (w/uniq (out needbars)
    `(let ,needbars nil
       (do ,@(map (fn (e)
                    `(let ,out (tolist ,e)
                       (unless (no? ,out)
                         (print (str ,out))
                         (if ,needbars
                             (do (pr bar* ,out) (do))
                             (do (= ,needbars true)
                                 (do (pr ,out) (do)))))))
                  body)))))

(def len (x)
  (if (nil? x) 0
      (obj? x) (# x)
      ; (let n (# x)
      ;   (if (is n 0)
      ;       (apply max (keep number? (keys x)))
      ;     n))
      (# x)))

(def len< (x n) (< (len x) n))

(def len> (x n) (> (len x) n))

(define-global begins (seq pat (o start 0))
  (unless (len> pat (- (len seq) start))
    (headmatch pat seq start)))


(define-global subst (new old seq)
  (let boundary (+ (- (len seq) (len old)) 1)
    (tostring 
      (forlen i seq
        (if (and (< i boundary) (headmatch old seq i))
            (do (inc i (- (len old) 1))
                (pr new))
            (pr (elt seq i)))))))

(define-global multisubst (pairs seq)
  (tostring 
    (forlen i seq
      (iflet (old new) (find [begins seq (car _) i] pairs)
        (do (inc i (- (len old) 1))
            (pr new))
        (pr (elt seq i))))))

; not a good name

(define-global findsubseq (pat seq (o start 0))
  (if (< (- (len seq) start) (len pat))
       nil
      (if (headmatch pat seq start)
          start
          (findsubseq pat seq (+ start 1)))))


(= buffer-stack* ())

(define-global current-buffer ()
  (last buffer-stack*))

(define-global write (...)
  (((require 'system) .write) ...))

(define-global tos (...)
  (concat (map stringify (list ...))))

(define-global tostr (...)
  (concat (map string! (list ...))))

(define-global insert (x ...)
  (if (is (current-buffer) nil)
      (do (write (tos x ...)) x)
      (step v (list x ...)
        (unless (nil? v)
          (add (current-buffer) v)))))

(define-global writec (c)
  (insert c))

(define-global pr (x ...)
  (step v (list x ...)
    (insert v))
  (if (is (current-buffer) nil) x))

(define-global prn (x ...)
  (with v (pr x ...)
    (pr "\n")))

(define-global sp ((o n 1)) (tostring (for i n (pr " "))))

(define-global flushout ()
  (do))

(def hexc (n)
  (with x (target js: (n (.to-string 16))
                  lua: ((string .format) "%02x" n))
    (while (< (# x) 2)
      (set x (cat "0" x)))))

(def hexrep ((r: r g: g b: b))
  (cat "#" (hexc r) (hexc g) (hexc b)))


(def color (r g b)
  (hexrep (obj r: r g: g b: b)))

(def gray (n) (color n n n))



(= sand (color 246 246 239)
   textgray (color 130 130 130))
  

(def pratoms (body)
  (if (or (no? body) 
          (all [and (acons _) (~is (car _) 'quote)] body))
      body
      (map [do `(pr ,_)] (vals body))))
      ; `((pr ,@body))))

(mac tolist body
  `((fn ()
      (add buffer-stack* ())
      ; (pr ,@body)
      (pr ,@body)
      (drop buffer-stack*))))

(mac w/string body
  `(apply cat (map stringify (flat (tolist ,@body)))))

(def tagbody (body)
  ; (pratoms body))
  (if (none? body) body `((tolist ,@body))))

(mac tag (spec . body)
  (with form `((jsx ,(quoted (carif spec))) ,@(tagbody body) ,@(props body))
    (when (obj? spec) 
      (step (k v) (pair (tl spec))
        (set (get form k) v)))))

(mac gentag args `(tag ,args))

(def br ((o n 1)) 
  (tolist
    (for i n
      (pr (tag br)))))

(def br2 () (tolist (tag br) (tag br)))

(mac center    body         `(tag center ,@body))
(mac underline body         `(tag u ,@body))
(mac tab       body         `(tag (table border 0) ,@body))
(mac tr        body         `(tag tr ,@body))

(mac td       body         `(tag td ,@(do body)))
(mac trtd     body         `(tr (td ,@(do body))))
(mac tdr      body         `(tag (td align 'right) ,@(do body)))
(mac tdcolor  (col . body) `(tag (td bgcolor ,col) ,@(do body)))

(mac row args
  `(tr ,@(map [list 'td _] args)))

(mac prrow args
  (w/uniq g
    `(tr ,@(map (fn (a) 
                  `(let ,g ,a
                     (if (number? ,g)
                         (tdr (pr ,g))
                         (td (pr ,g)))))
                 args))))

(mac prbold body `(tag b (pr ,@body)))

(def para args 
  (gentag p)
  (when args (apply pr args)))

(def menu (name items (o sel nil))
  (tag (select name name)
    (each i items
      (pr:tag (option selected (is i sel))
        i))))

(mac whitepage body
  `(tag html 
     (tag (body bgcolor 'white alink 'blue) ,@body)))

; (mac whitepage body
;   `(tag html 
;      (tag (body bgcolor 'white alink 'blue) ,@body)))

(def errpage args (whitepage (apply prn args)))

(def blank-url () "static/s.gif")

; Could memoize these.

; If h = 0, doesn't affect table column widths in some Netscapes.

(def hspace (n)    (gentag img src (blank-url) height 1 width n))
(def vspace (n)    (gentag img src (blank-url) height n width 0))
(def vhspace (h w) (gentag img src (blank-url) height h width w))

; (mac new-hspace (n)    
;   (if (number? n)
;       `(pr ,(string "<span style=\"padding-left:" n "px\" />"))
;       `(pr "<span style=\"padding-left:" ,n "px\" />")))

;(def spacerow (h) (tr (td (vspace h))))

(def spacerow (h) (tag (tr style (obj height: (cat (tostring h) "px")))))

; For use as nested table.

(mac zerotable body
  `(tag (table border 0 cellPadding 0 cellSpacing 0)
     ,@body))

; was `(tag (table border 0 cellPadding 0 cellSpacing 7) ,@body)

(mac sptab body
  `(tag (table style (obj border-spacing: "7px 0px")) ,@body))

(mac widtable (w . body)
  `(tag (table width ,w) (tr (td ,@body))))

(def cellpr (x) (pr (either x " ")))

(def but ((o text "submit") (o name nil))
  (gentag input type 'submit name name value text))

(def submit ((o val "submit"))
  (gentag input type 'submit value val))

(def buts (name . texts)
  (if (no? texts)
      (but)
      (do (but (car texts) name)
          (each text (cdr texts)
            (pr " ")
            (but text name)))))

(mac spanrow (n . body)
  `(tr (tag (td colspan ,n) ,@body)))

(mac form (action . body)
  `(tag (form method "post" action ,action) ,@body))

(mac textarea (name rows cols . body)
  `(tag (textarea name ,name rows ,rows cols ,cols) ,@body))

(def input (name (o val "") (o size 10))
  (gentag input type 'text name name value val size size))

(mac inputs args
  `(tag (table border 0)
     ,@(map (fn ((name label len text))
              (w/uniq (gl gt)
                `(let ,gl ,len
                   (tr (td ,(unless (empty label) `(pr ',label ":")))
                       (if (isa ,gl 'cons)
                           (td (textarea ',name (car ,gl) (cadr ,gl)
                                 (let ,gt ,text (if ,gt (pr ,gt)))))
                           (td (gentag input type ',(if (is label 'password) 
                                                    'password 
                                                    'text)
                                         name ',name 
                                         size ,len 
                                         value ,text)))))))
            (tuples args 4))))

(def single-input (label name chars btext (o pwd))
  (pr label)
  (gentag input type (if pwd 'password 'text) name name size chars)
  (sp)
  (submit btext))



(mac italic body
  ; `(<span> style: (obj fontWeight: 'italic) ,@body))
  `(tag i ,@body))





;; ===================================
;; srv.arc

; HTTP Server.

; To improve performance with static files, set static-max-age*.

(= arcdir* "arc/" logdir* "arc/logs/" staticdir* "static/")

(= quitsrv* nil breaksrv* nil) 


(defconst fns* (obj))
(= fnids* nil timed-fnids* nil)

; count on huge (expt 64 10) size of fnid space to avoid clashes

(def rand-string (n)
  (shell "randint 10000000000000"))

(def new-fnid ()
  (check (rand-string 10) ~fns* (new-fnid)))

(def fnid (f)
  (let key (new-fnid)
    (= (fns* key) f)
    (push key fnids*)
    key))



(def url-for (fnid)
  (tostr fnurl* "?fnid=" fnid))

(def flink (f)
  (tostr fnurl* "?fnid=" (fnid (fn (req) (prn) (f req)))))

(def rflink (f)
  (tostr rfnurl* "?fnid=" (fnid f)))
  
; Since it's just an expr, gensym a parm for (ignored) args.

(mac w/link (expr . body)
  `(tag (a href (flink (fn (,(unique 'x)) ,expr)))
     ,@body))

(mac w/rlink (expr . body)
  `(tag (a href (rflink (fn (,(unique 'x)) ,expr)))
     ,@body))

(mac onlink (text . body)
  `(w/link (do ,@body) (pr ,text)))

(mac onrlink (text . body)
  `(w/rlink (do ,@body) (pr ,text)))

; bad to have both flink and linkf; rename flink something like fnid-link

(mac linkf (text parms . body)
  `(tag (a href (flink (fn ,parms ,@body))) (pr ,text)))

(mac rlinkf (text parms . body)
  `(tag (a href (rflink (fn ,parms ,@body))) (pr ,text)))


;(defop top req (linkf 'whoami? (req) (pr "I am " (get-user req))))

;(defop testf req (w/link (pr "ha ha ha") (pr "laugh")))

(mac w/link-if (test expr . body)
  `(tag-if ,test (a href (flink (fn (,(unique 'x)) ,expr)))
     ,@body))

(def fnid-field (id)
  (gentag input type 'hidden name 'fnid value id))

; f should be a fn of one arg, which will be http request args.

(def fnform (f bodyfn (o redir))
  (tag (form method 'post action (if redir rfnurl2* fnurl*))
    (fnid-field (fnid f))
    (bodyfn)))

; Could also make a version that uses just an expr, and var capture.
; Is there a way to ensure user doesn't use "fnid" as a key?

(mac aform (f . body)
  (w/uniq ga
    `(tag (form method 'post action fnurl*)
       (fnid-field (fnid (fn (,ga)
                           (prn)
                           (,f ,ga))))
       ,@body)))

;(defop test1 req
;  (fnform (fn (req) (prn) (pr req))
;          (fn () (single-input "" 'foo 20 "submit"))))
 
;(defop test2 req
;  (aform (fn (req) (pr req))
;    (single-input "" 'foo 20 "submit")))

; Like aform except creates a fnid that will last for lasts seconds
; (unless the server is restarted).

(mac taform (lasts f . body)
  (w/uniq (gl gf gi ga)
    `(let (,gl ,lasts
           ,gf (fn (,ga) (prn) (,f ,ga)))
       (tag (form method 'post action fnurl*)
         (fnid-field (if ,gl (timed-fnid ,gl ,gf) (fnid ,gf)))
         ,@body))))




(= formwid* 60 bigformwid* 80 numwid* 16 formatdoc-url* nil)

; Eventually figure out a way to separate type name from format of 
; input field, instead of having e.g. toks and bigtoks

(def varfield (typ id val)
  (if (in typ 'string 'string1 'url)
       (gentag input type 'text name id value val size formwid*)
      (in typ 'num 'int 'posint 'sym)
       (gentag input type 'text name id value val size numwid*)
      (in typ 'users 'toks)
       (gentag input type 'text name id value (w/string (apply prs val))
                     size formwid*)    
      (is typ 'sexpr)
       (gentag input type 'text name id 
                     value (w/string (map [do (pr _ " ")] (or val ())))
                     size formwid*)
      (in typ 'syms 'text 'doc 'mdtext 'mdtext2 'lines 'bigtoks)
       (let text (if (in typ 'syms 'bigtoks)
                      (w/string (apply prs val))
                     (is typ 'lines)
                      (w/string (apply pr (intersperse #\newline val)))
                     (in typ 'mdtext 'mdtext2)
                      (unmarkdown val)
                     (no val)
                      ""
                     val)
         (pr:tag (textarea cols (if (is typ 'doc) bigformwid* formwid*) 
                        rows (needrows text formwid* 4)
                        wrap 'virtual 
                        style (if (is typ 'doc) "font-size:8.5pt")
                        name id
                        value text))
           ; (prn) ; needed or 1 initial newline gets chopped off
           ; (pr text))
           ; text)
         (when (and formatdoc-url* (in typ 'mdtext 'mdtext2))
           (pr " ")
           (tag (font size -2)
             (link "help" formatdoc-url* (gray 175)))))
      (caris typ 'choice)
       (menu id (cddr typ) val)
      (is typ 'yesno)
       (menu id (list "yes" "no") (if val "yes" "no"))
      (is typ 'hexcol)
       (gentag input type 'text name id value val)
      (is typ 'time)
       (gentag input type 'text name id value (if val (english-time val) ""))
      (is typ 'date)
       (gentag input type 'text name id value (if val (english-date val) ""))
       (err "unknown varfield type" typ)))

(def text-rows (text wid (o pad 3))
  (+ (trunc (/ (len text) (* wid .8))) pad))

(def needrows (text cols (o pad 0))
  (+ pad (max (+ 1 (count #\newline text))
              (roundup (/ (len text) (- cols 5))))))

(def varline (typ id val (o liveurls))
  (if (in typ 'users 'syms 'toks 'bigtoks)  (apply prs val)
      (is typ 'lines)                       (map prn val)
      (is typ 'yesno)                       (pr (if val 'yes 'no))
      (caris typ 'choice)                   (varline (cadr typ) nil val)
      (is typ 'url)                         (if (and liveurls (valid-url val))
                                                (link val val)
                                                (pr val))
      (text-type typ)                       (pr (or val ""))
                                            (pr val)))

(def text-type (typ) (in typ 'string 'string1 'url 'text 'mdtext 'mdtext2))

; Newlines in forms come back as /r/n.  Only want the /ns. Currently
; remove the /rs in individual cases below.  Could do it in aform or
; even in the parsing of http requests, in the server.

; Need the calls to striptags so that news users can't get html
; into a title or comment by editing it.  If want a form that 
; can take html, just create another typ for it.

(def readvar (typ str (o fail nil))
  (case (carif typ)
    string  (striptags str)
    string1 (if (blank str) fail (striptags str))
    url     (if (blank str) "" (valid-url str) (clean-url str) fail)
    num     (let n (saferead str) (if (number? n) n fail))
    int     (let n (saferead str)
              (if (number? n) (round n) fail))
    posint  (let n (saferead str)
              (if (and (number? n) (> n 0)) (round n) fail))
    text    (striptags str)
    doc     (striptags str)
    mdtext  (md-from-form str)
    mdtext2 (md-from-form str t)                      ; for md with no links
    sym     (or (sym:car:tokens str) fail)
    syms    (map sym (tokens str))
    sexpr   (errsafe (readall str))
    users   (rem [no (goodname _)] (tokens str))
    toks    (tokens str)
    bigtoks (tokens str)
    lines   (lines str)
    choice  (readvar (cadr typ) str)
    yesno   (is str "yes")
    hexcol  (if (hex>color str) str fail)
    time    (or (errsafe (parse-time str)) fail)
    date    (or (errsafe (parse-date str)) fail)
            (err "unknown readvar type" typ)))

; dates should be tagged date, and just redefine <

(def varcompare (typ)
  (if (in typ 'syms 'sexpr 'users 'toks 'bigtoks 'lines 'hexcol)
       (fn (x y) (> (len x) (len y)))
      (is typ 'date)
       (fn (x y)
         (or (no y) (and x (date< x y))))
       (fn (x y)
         (or (empty y) (and (~empty x) (< x y))))))


; (= fail* (uniq))

(= fail* ()) ; coudn't possibly come back from a form
  
; Takes a list of fields of the form (type label value view modify) and 
; a fn f and generates a form such that when submitted (f label newval) 
; will be called for each valid value.  Finally done is called.

(def vars-form (user fields f done (o button "update") (o lasts))
  (taform lasts
          (if (all [no? (at _ 4)] fields)
              (fn (req))
              (fn (req)
                (when-umatch user req
                  (each (k v) req!args
                    (let name (sym k)
                      (awhen (find [is (cadr _) name] fields)
                        ; added sho to fix bug
                        (let (typ id val sho mod) it
                          (when (and mod v)
                            (let newval (readvar typ v fail*)
                              (unless (is newval fail*)
                                (f name newval))))))))
                  (done))))
     (pr:tab
       (showvars fields))
     (unless (all [no? (at _ 4)] fields)  ; no modifiable fields
       (br)
       (submit button))))
                
(def showvars (fields (o liveurls))
  (step (typ id val view mod question) fields
    (when view
      (when question
        (pr:tr (td (prn question))))
      (pr:tr (unless question (tag (td valign 'top) 
                                   (unless (empty id)
                                     (pr id ":"))))
          (td (if mod 
                  (varfield typ id val)
                  (varline  typ id val liveurls))))
      (prn))))

; http://daringfireball.net/projects/markdown/syntax

(def md-from-form (str (o nolinks))
  (markdown (trim (rem #\return (esc-tags str)) 'end) 60 nolinks))


(define-global markdown (s (o maxurl) (o nolinks))
  (let ital nil
    (tolist
      (forlen i s
        (iflet (newi spaces) (indented-code s i (if (is i 0) 2 0))
               (do ;(pr  "<p><pre><code>")
                 (let cb (code-block s (- newi spaces 1))
                   (pr (<p> (<pre> (<code> cb))))
                   (= i (+ (- newi spaces 1) (len cb))))
                 ;(pr "</code></pre>")
                 )
               (iflet newi (parabreak s i (if (is i 0) 1 0))
                      (do (unless (is i 0) (pr (<p>))) ;(pr "<p>"))
                          (= i (- newi 1)))
                      (and (is (char s i) #\*)
                           (or ital 
                               (atend i s) 
                               (and (~whitec (char s (+ i 1)))
                                    (pos #\* s (+ i 1)))))
                       (do (if ital (pr (italic (drop buffer-stack*))) (add buffer-stack* ()))
                           (= ital (no ital)))
                      (and (no nolinks)
                           (or (litmatch "http://" s i) 
                               (litmatch "https://" s i)))
                       (let (n   (urlend s i)
                             url (clean-url (clip s i n)))
                         (pr (tag (a href url rel "nofollow")
                                  (if (no maxurl) url (ellipsize url maxurl))))
                         (= i (- n 1)))
                       (writec (char s i))))))))

(define-global indented-code (s i (o newlines 0) (o spaces 0))
  (let c (char s i)
    (if (nonwhite c)
         (if (and (> newlines 1) (> spaces 1))
             (list i spaces)
             nil)
        (atend i s)
         nil
        (is c #\newline)
         (indented-code s (+ i 1) (+ newlines 1) 0)
         (indented-code s (+ i 1) newlines       (+ spaces 1)))))


; If i is start a paragraph break, returns index of start of next para.

(define-global parabreak (s i (o newlines 0))
  (let c (char s i)
    (if (or (nonwhite c) (atend i s))
        (if (> newlines 1) i nil)
        (parabreak s (+ i 1) (+ newlines (if (is c #\newline) 1 0))))))

; Returns the indices of the next paragraph break in s, if any.

(define-global next-parabreak (s i)
  (unless (atend i s)
    (aif (parabreak s i) 
         (list i it)
         (next-parabreak s (+ i 1)))))

(define-global paras (s (o i 0))
  (if (atend i s)
      nil
      (iflet (endthis startnext) (next-parabreak s i)
             (cons (clip s i endthis)
                   (paras s startnext))
             (list (trim (clip s i) 'end)))))


; Returns the index of the first char not part of the url beginning
; at i, or len of string if url goes all the way to the end.

; Note that > immediately after a url (http://foo.com>) will cause
; an odd result, because the > gets escaped to something beginning
; with &, which is treated as part of the url.  Perhaps the answer
; is just to esc-tags after markdown instead of before.

; Treats a delimiter as part of a url if it is (a) an open delimiter
; not followed by whitespace or eos, or (b) a close delimiter 
; balancing a previous open delimiter.

(define-global urlend (s i (o indelim))
  (let c (char s i)
    (if (atend i s)
         (if ((orf punc whitec opendelim) c) 
              i 
             (closedelim c)
              (if indelim (+ i 1) i)
             (+ i 1))
        (if (or (whitec c)
                (and (punc c) (whitec (char s (+ i 1))))
                (and ((orf whitec punc) (char s (+ i 1)))
                     (or (opendelim c)
                         (and (closedelim c) (no indelim)))))
            i
            (urlend s (+ i 1) (or (opendelim c)
                                  (and indelim (no (closedelim c)))))))))


(define-global opendelim (c)  (in c #\< #\( #\[ #\{))
 
(define-global closedelim (c) (in c #\> #\) #\] #\}))

(define-global code-block (s i)
  (w/string
    (until (let left (- (len s) i 1)
             (or (is left 0)
                 (and (> left 2)
                      (is (char s (+ i 1)) #\newline)
                      (nonwhite (char s (+ i 2))))))
      (writec (char s (inc i))))))

(define-global unmarkdown (s)
  (unless (nil? s)
    (w/string
      (forlen i s
        (if (litmatch "<p>" s i)
             (do (inc i 2) 
                 (unless (is i 2) (pr "\n\n")))
            (litmatch "<i>" s i)
             (do (inc i 2) (pr #\*))
            (litmatch "</i>" s i)
             (do (inc i 3) (pr #\*))
            (litmatch "<a href=" s i)
             (let endurl (posmatch [in _ #\> #\space] s (+ i 9))
               (if endurl
                   (do (pr (clip s (+ i 9) (- endurl 1)))
                       (= i (aif (posmatch "</a>" s endurl)
                                 (+ it 3)
                                 endurl)))
                   (writec (char s i))))
            (litmatch "<pre><code>" s i)
             (awhen (findsubseq "</code></pre>" s (+ i 12))
               (pr (clip s (+ i 11) it))
               (= i (+ it 12)))
            (writec (char s i)))))))

(define-global atend (i s)
  (>= i (edge s)))

(define-global only (f)
  (fn (x ...) (unless (== x nil) (f x ...))))

(define-macro conswhen (f x y)
  (w/uniq (gf gx)
   `(let (,gf ,f ,gx ,x)
      (if (,gf ,gx) (cons ,gx ,y) ,y))))

(define-global consif (x y) (if (yes? x) (cons x y) y))

(define-global flat (x)
  (if (atom x) (list x)
  (with r ()
    (step v x
      (unless (is v nil)
        (unless (no? v)
          (if (atom v) (add r v) (join! r (flat v))))))
    (each (k v) x
      (unless (number? k)
        (add r " ")
        (add r k)
        (add r "=")
        (add r (escape (inner (pp-to-string (flat v))))))))))

(define-macro check (x test (o alt))
  (w/uniq gx
    `(let ,gx ,x
       (if (,test ,gx) ,gx ,alt))))

(define-global nthcdr (n seq)
  (if (is seq nil) seq (cut seq n)))

(def tuples (xs (o n 2))
  (if (no? xs)
      nil
      (cons (firstn n xs)
            (tuples (nthcdr n xs) n))))

(def caris (x val) 
  (and (acons x) (is (car x) val)))


)

(during-compilation

; (def keys (h) 
;   (accum a (each (k v) h (a k))))

; (def vals (h) 
;   (accum a (each (k v) h (a v))))

; These two should really be done by coerce.  Wrap coerce?

(def tablist (h)
  (accum a (maptable (fn args (a args)) h)))

(def listtab (al)
  (let h ()
    (map (fn ((k v)) (= (get h k) v))
         al)
    h))

  

(define-global readfile1 (name)
  ((JSON .parse) (read-file name)))

(define-global writefile (val file)
  (write-file file ((JSON .stringify) val)))

(define-global load-table (file)
  ((JSON .parse) (read-file file)))

(define-global save-table (h file)
  (write-file file ((JSON .stringify) h)))

(defvar savers* (obj))

(define-macro fromdisk (var file init load save)
  (w/uniq (gf gv)
    `(unless (bound ',var)
       (do (defvar ,var (iflet ,gf (file-exists ,file)
                               (,load ,gf)
                               (either ,init (list))))
           (= (savers* ',var) (fn (,gv) (,save ,gv ,file)))
           (,var)))))

(define-macro diskvar (var file)
  `(fromdisk ,var ,file (list) readfile1 writefile))

(define-macro disktable (var file)
  `(fromdisk ,var ,file (obj) load-table save-table))

(define-macro todisk (var (o expr var))
  `((savers* ',var) 
    ,(if (is var expr) `(,var) `(= (,var) ,expr))))

(define-macro evtil (expr test)
  (w/uniq gv
    `(let ,gv ,expr
       (while (no (,test ,gv))
         (= ,gv ,expr))
       ,gv)))

;; ===================================
;; strings.arc

; Matching.  Spun off 29 Jul 06.

; arc> (w/string (writec (coerce 133 'char)))
;
;> (define ss (open-output-string))
;> (write-char (integer->char 133) ss)
;> (get-output-string ss)
;"\u0085"

(def tokens (s (o sep whitec) (o start 0))
  (let (test (testify sep)
        ntest (fn (x) (not (test x))))
    (accum a
      (dec start)
      (while (let-when i (mem test s (+ start 1))
               (let x (clip s start i)
                 (unless (none? x)
                   (a x)))
               (= start (either (mem ntest s i) i))
               true))
      (unless (is? (mem test s start))
        (a (clip s start))))))
    ; (let rec (afn (cs toks tok)
               ; (if (no? cs)         (consif tok toks)
                   ; (test (car cs)) (self (cdr cs) (consif tok toks) nil)
                    ;                (self (cdr cs) toks (cons (car cs) tok))))
      ; (map concat (rev (map rev (rec (chars s) nil nil)))))))

; names of cut, split, halve not optimal

(def halve (s (o sep whitec) (o start 0))
  (let test (testify sep)
    (let i (mem test s start)
      (if (is? i)
          (list (clip s 0 i) (clip s i))
        (list s)))))
    ; (let rec (afn (cs tok)
    ;            (if (no? cs)         (list (rev tok))
    ;                (test (car cs)) (list cs (rev tok))
    ;                                (self (cdr cs) (cons (car cs) tok))))
    ;   (rev (map string!
    ;             (rec (chars s) nil))))))

; maybe promote to arc.arc, but if so include a list clause

(def positions (test seq (o start 0))
  (accum a
    (let f (testify test)
      (forlen i seq start: start
        (if (f (elt seq i)) (a i))))))

(def lines (s)
  (map [if (is (char _ (edge _)) #\return)
           (clip _ 0 (edge _))
          _]
       (split s #\newline)))
  ; (accum a
  ;   ((afn ((p . ps))
  ;      (if ps
  ;          (do (a (rem #\return (cut s (+ p 1) (car ps))))
  ;              (self ps))
  ;          (a (cut s (+ p 1)))))
  ;    (cons -1 (positions #\newline s)))))

(def slices (s test)
  (accum a
    ((afn ((p . ps))
       (if (yes? ps)
           (do (a (clip s (+ p 1) (car ps)))
               (self ps))
           (a (clip s (+ p 1)))))
     (cons -1 (positions test s)))))


(define-macro time (expr)
  (w/uniq (t1 t2)
    `(let ,t1 (msec)
       (do1 ,expr
            (let ,t2 (msec)
              (prn "time: " (- ,t2 ,t1) " msec."))))))

(define-macro jtime (expr)
  `(do1 'ok (time ,expr)))

(define-macro time10 (expr)
  `(time (for i 10 ,expr)))


(define-global union (f xs ys)
  (join xs (rem (fn (y) (some (if f [f _ y] [is _ y]) xs))
                ys)))
)

(during-compilation

(defvar templates* (obj))

(define-macro deftem (tem rest: fields)
  (let (name (carif tem) includes (if (acons tem) (cdr tem)))
    `(= (templates* ',name)
        (join (mappend (templates*) ',(rev includes))
              (list ,@(map (fn ((k v)) `(list ',k (fn () ,v)))
                           (pair fields)))))))

(define-macro addtem (name rest: fields)
  `(= (templates* ',name)
      (union (fn (x y) (is (car x) (car y)))
             (list ,@(map (fn ((k v)) `(list ',k (fn () ,v)))
                          (pair fields)))
             (templates* ',name))))

(define-global inst (tem rest: args)
  (let x (obj)
    (step (k v) (if (acons tem) tem (templates* tem))
      (unless (no v) (= (get x k) (v))))
    (step (k v) (pair args)
      (= (get x k) v))
    x))

; Converts alist to inst; ugly; maybe should make this part of coerce.
; Note: discards fields not defined by the template.

(define-global templatize (tem raw)
  (let (x (inst tem) fields (if (acons tem) tem (templates* tem)))
    (each (k v) (or raw ())
      (when (assoc k fields)
        (= (get x k) v)))
    x))

(define-global temload (tem file)
  (templatize tem ((JSON .parse) (read-file file))))

)

(define-global stringify (x)
  (if (string? x) x (pp-to-string x)))

(define-global string! (x)
  (if (string? x) x (nil? x) "" (str x)))

(define-global maptable ((o f idfn) (o l (obj)))
  (each (k v) l
    (f k v))
  l)


; Application Server.  Layer inserted 2 Sep 06.

; ideas: 
; def a general notion of apps of which prompt is one, news another
; give each user a place to store data?  A home dir?

; A user is simply a string: "pg". Use /whoami to test user cookie.

(= hpwfile*   "arc/hpw"
   oidfile*   "arc/openids"
   adminfile* "arc/admins"
   cookfile*  "arc/cooks")

(def serve ((o port 8080))
  port)

(def asv ((o port 8080))
  (load-userinfo)
  (serve port))

(def load-userinfo ()
  (= hpasswords*   (safe-load-table hpwfile*)
     openids*      (safe-load-table oidfile*)
     admins*       (map stringify (errsafe (readfile adminfile*)))
     cookie->user* (safe-load-table cookfile*))
  (maptable (fn (k v) (= (get user->cookie* v) k))
            cookie->user*))

; idea: a bidirectional table, so don't need two vars (and sets)

(= cookie->user* (obj) user->cookie* (obj) logins* (obj))


(def admin (u) (and u (is? (mem u admins*)) u))

(def user-exists (u) (and u (has? hpasswords* u) u))





; News.  2 Sep 06.

; to run news: (nsv), then go to http://localhost:8080
; put usernames of admins, separated by whitespace, in arc/admins

; bug: somehow (+ votedir* nil) is getting evaluated.

; (declare 'atstrings t)

(= this-site*    "Lambda News"
   site-url*     "http://news.ycombinator.lol"
   parent-url*   "http://docs.ycombinator.lol"
   favicon-url*  ""
   site-desc*    ""               ; for rss feed
   site-color*   (color 153 187 170)
   border-color* (color 180 180 180)
   prefer-url*   t)

; Structures

; Could add (html) types like choice, yesno to profile fields.  But not 
; as part of deftem, which is defstruct.  Need another mac on top of 
; deftem.  Should not need the type specs in user-fields.

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


; Load and Save

(= arcdir*   "arc/"
   newsdir*  "arc/news/"
   storydir* "arc/news/story/"
   profdir*  "arc/news/profile/"
   votedir*  "arc/news/vote/")

(defvar vote* (obj))
(defvar prof* (obj))
(defconst initload-users* true)

(def nsv ((o port 8080))
  (map ensure-dir (list arcdir* newsdir* storydir* votedir* profdir*))
  (when (no? (stories*)) (load-items))
  (if (and initload-users* (no? (prof*))) (load-users))
  (asv port))

(def load-users ()
  (print "load users: ")
  (step id (dir profdir*)
    (print id)
    (load-user id)))

(def load-user (u)
  (= ;(vote* u) (load-table (cat votedir* u))
     (prof* u) (temload 'profile (cat profdir* u)))
  (set (vote* u) nil)
  (votes u)
  u)

(def goodname (u) true)

; Have to check goodname because some user ids come from http requests.
; So this is like safe-item.  Don't need a sep fn there though.

(def profile (u)
  (or (prof* u)
      (aand (goodname u)
            (file-exists (cat profdir* u))
            (= (prof* u) (temload 'profile it)))))

(def votes (u)
  (or (vote* u)
      (aand (file-exists (cat votedir* u))
            (load-table it)
            (listtab (map [list (cadr _) _] it))
            (= (vote* u) it))))
            ; (let (h (load-table it)
            ;       r ())
            ;   (step x h
            ;     (let id (at x 1)
            ;       (add r (list id x))))
            ;   (= (vote* u) (listtab r))))))
            ; ; (= (vote* u) (load-table it)))))

; (def votes (u)
;   (let-when h (votes-1 u)
;     (unless (keys? h)
;       (with r (obj)
;         (step x h
;           (let id (at x 1)
;             (= (get r id) x)))
;         (= (vote* u) r)))))
               


          
(def init-user (u)
  (= (vote* u) (obj) 
     (prof* u) (inst 'profile 'id u))
  (save-votes u)
  (save-prof u)
  u)

; Need this because can create users on the server (for other apps)
; without setting up places to store their state as news users.
; See the admin op in app.arc.  So all calls to login-page from the 
; news app need to call this in the after-login fn.

(def ensure-news-user (u)
  (if (profile u) u (init-user u)))

(def save-votes (u) (save-table (vote* u) (cat votedir* u)))

(def save-prof  (u) (save-table (prof* u) (cat profdir* u)))

(mac uvar (u k) `(get (profile ,u) ',k))

(mac karma   (u) `(uvar ,u karma))
(mac ignored (u) `(uvar ,u ignore))

; Note that users will now only consider currently loaded users.

(def users ((o f idfn)) 
  (keep f (keys prof*)))

(def check-key (u k)
  (and u (mem k (uvar u keys))))

(def author (u i) (is u i!by))


(defvar stories* ())
(defvar comments* ())
(defvar items* (obj))
(defvar url->story* (obj))
(= maxid* 0)
(defvar initload* 15000)

(define-global load-items ()
  ; (system (cat "rm " storydir* "*.tmp"))
  (print "load items: ") 
  (let (items (obj)
        ids   (sort (map int (dir storydir*)) >))
    (if ids (= maxid* (car ids)))
    (step id (firstn (initload*) ids)
      (print id)
      (let i (load-item id)
        (push i (get items i!type))))
    (defconst stories*  (rev (merge (compare < !id) items!story items!poll)))
    (defconst comments* (rev items!comment))
    (hook 'initload items))
  (ensure-topstories))

(define-global ensure-topstories ()
  (aif (errsafe (readfile1 (+ newsdir* "topstories")))
       (= ranked-stories* (map item it))
       (do (prn "ranking stories.") 
           (flushout)
           (gen-topstories))))


(define-global save-votes (u) (save-table (vote* u) (cat votedir* u)))
(define-global save-prof (u) (save-table (prof* u) (cat profdir* u)))
(define-global save-item (i) (save-table i (cat storydir* (tostring i!id))))



(define-global astory   (i) (is i!type 'story))
(define-global acomment (i) (is i!type 'comment))
(define-global apoll    (i) (is i!type 'poll))

(define-global load-item (id)
  (let i (temload 'item (cat storydir* id))
    (= (items* id) i)
    (awhen (and (astory&live i) (check i!url ~blank))
      (register-url i it))
    i))

; Note that duplicates are only prevented of items that have at some 
; point been loaded. 

(define-global register-url (i url)
  (= (url->story* (canonical-url url)) i!id))

; redefined later

(defvar stemmable-sites* (obj))

(define-global canonical-url (url)
  (if (stemmable-sites* (sitename url))
      (clip url 0 (mem #\? url))
      url))

(define-global new-item-id ()
  (evtil (inc maxid*) [~file-exists (cat storydir* _)]))

(define-global item (id)
  (or (items* id) (errsafe:load-item id)))

(define-global kids (i) (map item i!kids))

; For use on external item references (from urls).  Checks id is int 
; because people try e.g. item?id=363/blank.php

(define-global safe-item (id)
  (ok-id&item (if (string? id) (saferead id) id)))

(define-global exact (x)
  (and (number? x) (is (% x 1) 0)))

(define-global ok-id (id) 
  (and (exact id) (<= 1 id maxid*)))

(define-global arg->item (req key)
  (safe-item:saferead (arg req key)))

(mac nor args `(not (or ,@args)))

(define-global live (i) (nor i!dead i!deleted))

(define-global save-item (i) (save-table i (cat storydir* i!id)))

(defvar comment-cache* (obj))

(define-global kill (i how)
  (unless i!dead
    (log-kill i how)
    (wipe (comment-cache* i!id))
    (set i!dead true)
    (save-item i)))

(defvar kill-log* ())

(define-global log-kill (i how)
  (push (list i!id how) kill-log*))

(mac each-loaded-item (var . body)
  (w/uniq g
    `(let ,g maxid*
       (while (> ,g 0)
         (whenlet ,var (items* ,g)
           ,@body)
         (dec ,g)))))

(define-global loaded-items (test)
  (accum a (each-loaded-item i (test&a i))))


; Ranking

; Votes divided by the age in hours to the gravityth power.
; Would be interesting to scale gravity in a slider.

(= gravity* 1.8 timebase* 120 front-threshold* 1 
   nourl-factor* .4 lightweight-factor* .3 )

(def frontpage-rank (s (o scorefn realscore) (o gravity gravity*))
  (* (/ (let base (- (scorefn s) 1)
          (if (> base 0) (expt base .8) base))
        (expt (/ (+ (item-age s) timebase*) 60) gravity))
     (if (no (in s!type 'story 'poll))  .5
         (blank s!url)                  nourl-factor*
         (lightweight s)                (min lightweight-factor* 
                                             (contro-factor s))
                                        (contro-factor s))))

(def contro-factor (s)
  (aif (check (visible-family nil s) [> _ 20])
       (min 1 (expt (/ (realscore s) it) 2))
       1))

(def realscore (i) (- i!score i!sockvotes))

(disktable lightweights* (cat newsdir* "lightweights"))

(def lightweight (s)
  (or s!dead
      (mem 'rally s!keys)  ; title is a rallying cry
      (mem 'image s!keys)  ; post is mainly image(s)
      (lightweights* (sitename s!url))
      (lightweight-url s!url)))

(def lightweight-url (url)
  (in (downcase (last (split url #\.))) "png" "jpg" "jpeg"))

(def item-age (i) (minutes-since i!time))

(def user-age (u) (minutes-since (uvar u created)))

; Only looks at the 1000 most recent stories, which might one day be a 
; problem if there is massive spam. 

(def gen-topstories ()
  (= ranked-stories* (rank-stories 180 1000 (memo frontpage-rank))))

(def save-topstories ()
  (writefile (map !id (firstn 180 ranked-stories*))
             (cat newsdir* "topstories")))
 
(def rank-stories (n consider scorefn)
  (bestn n (compare > scorefn) (latest-items metastory nil consider)))

; With virtual lists the above call to latest-items could be simply:
; (map item (retrieve consider metastory:item (gen maxid* [- _ 1])))

(def latest-items (test (o stop) (o n))
  (accum a
    (down id maxid* 1
      (let i (item id)
        (if (or (and stop (stop i)) (and n (<= n 0))) 
            (break))
        (when (test i) 
          (a i) 
          (if n (dec n)))))))
             
; redefined later

(def metastory (i) (and i (in i!type 'story 'poll)))

(def adjust-rank (s (o scorefn frontpage-rank))
  (insortnew (compare > (memo scorefn)) s ranked-stories*)
  (save-topstories))


; If something rose high then stopped getting votes, its score would
; decline but it would stay near the top.  Newly inserted stories would
; thus get stuck in front of it. I avoid this by regularly adjusting 
; the rank of a random top story.

; (defbg rerank-random 30 (rerank-random))

; (def rerank-random ()
;   (when ranked-stories*
;     (adjust-rank (ranked-stories* (rand (min 50 (len ranked-stories*)))))))

(def topstories (user n (o threshold front-threshold*))
  (retrieve n 
            [and (>= (realscore _) threshold) (cansee user _)]
            ranked-stories*))

(= max-delay* 10)

(def cansee (user i)
  (if i!deleted   (admin user)
      i!dead      (or (author user i) (seesdead user))
      (delayed i) (author user i)
      t))

(let mature (obj)
  (define-global delayed (i)
    (and (no (get mature i!id))
         (acomment i)
         (or (< (item-age i) (min max-delay* (uvar i!by delay)))
             (do (set (get mature i!id) true)
                 nil)))))

(def seesdead (user)
  (or (and user (uvar user showdead) (no (ignored user)))
      (editor user)))

(def visible (user is)
  (keep [cansee user _] is))

(def cansee-descendant (user c)
  (or (cansee user c)
      (some [cansee-descendant user (item _)] 
            c!kids)))
  
(def editor (u) 
  (and u (or (admin u) (> (uvar u auth) 0))))

(def member (u) 
  (and u (or (admin u) (uvar u member))))

; Page Layout

(= up-url* "grayarrow.gif" down-url* "graydown.gif" logo-url* "arc.png")

; (defopr favicon.ico req favicon-url*)

; redefined later

(def gen-css-url ()
  (tag (link rel "stylesheet" type "text/css" href "news.css")))

(= votejs* "
function byId(id) {
  return document.getElementById(id);
}

function vote(node) {
  var v = node.id.split(/_/);   // {'up', '123'}
  var item = v[1]; 

  // adjust score
  var score = byId('score_' + item);
  var newscore = parseInt(score.innerHTML) + (v[0] == 'up' ? 1 : -1);
  score.innerHTML = newscore + (newscore == 1 ? ' point' : ' points');

  // hide arrows
  byId('up_'   + item).style.visibility = 'hidden';
  byId('down_' + item).style.visibility = 'hidden';

  // ping server
  var ping = new Image();
  ping.src = node.href;

  return false; // cancel browser nav
} ")
(write-file "hn.js" votejs*)


(mac npage (title . body)
  `(tag html 
     (tag head 
       (gen-css-url)
       (tag (link rel "shortcut icon" href favicon-url*))
       (tag (script src "hn.js"))
       (tag title ,title))
     (tag body 
       (center
         (tag (table border 0 cellPadding 0 cellSpacing 0 width "85%"
                     bgcolor sand)
           ,@body)))))

(= pagefns* (obj))

(mac fulltop (user lid label title whence . body)
  (w/uniq (gu gi gl gt gw)
    `(let (,gu ,user ,gi ,lid ,gl ,label ,gt ,title ,gw ,whence)
       (npage (+ "" this-site* (if (yes? ,gt) (+ "" bar* ,gt) ""))
         (if (check-procrast ,gu)
             (pr (pagetop 'full ,gi ,gl ,gt ,gu ,gw)
                 (hook 'page ,gu ,gl)
                 ,@body)
             (row (procrast-msg ,gu ,gw)))))))

(mac longpage (user t1 lid label title whence . body)
  (w/uniq (gu gt gi)
    `(let (,gu ,user ,gt ,t1 ,gi ,lid)
       (fulltop ,gu ,gi ,label ,title ,whence
         (trtd ,@body)
         (trtd (vspace 10)
               (color-stripe (main-color ,gu))
               (br)
               (center
                 (hook 'longfoot)
                 (admin-bar ,gu (- (msec) ,gt) ,whence)))))))

(def admin-bar (user elapsed whence)
  (when (admin user)
    (br2)
    (w/bars
      (pr (len items*) "/" maxid* " loaded")
      (pr (round (/ (memory) 1000000)) " mb")
      (pr elapsed " msec")
      (link "settings" "newsadmin")
      (hook 'admin-bar user whence))))

(def color-stripe (c)
  (tag (table width "100%" cellSpacing 0 cellPadding 1)
    (tr (tdcolor c))))

(mac shortpage (user lid label title whence . body)
  `(fulltop ,user ,lid ,label ,title ,whence 
     (trtd ,@body)))

(mac minipage (label . body)
  `(npage (cat this-site* bar* ,label)
     (pagetop nil nil ,label)
     (trtd ,@body)))

(def msgpage (user msg (o title))
  (minipage (either title "Message")
    (spanclass admin
      (center (if (len> msg 80) 
                  (widtable 500 msg)
                  (pr msg))))
    (br2)))


(def sum (f (o xs ()))
  (with n 0
    (step x xs (inc n (f x)))))

(def visible-family (user i)
  (+ (if (cansee user i) 1 0)
     (sum [visible-family user (item _)] i!kids)))


(define-global family (i)
  `(,i ,@(mappend family:items* i!kids)))


; Story Submission

; (newsop submit ()
;   (if user 
;       (submit-page user "" "" t) 
;       (submit-login-warning "" "" t)))

(def submit-login-warning ((o url) (o title) (o showtext) (o text))
  (login-page 'both "You have to be logged in to submit."
              (fn (user ip) 
                (ensure-news-user user)
                (newslog ip user 'submit-login)
                (submit-page user url title showtext text))))

(def submit-page (user (o url) (o title) (o showtext) (o text "") (o msg))
  (minipage "Submit"
    (pagemessage msg)
    (urform user req
            (process-story (get-user req)
                           (clean-url (arg req "u"))
                           (striptags (arg req "t"))
                           showtext
                           (and showtext (md-from-form (arg req "x") t))
                           req!ip)
      (tab
        (row "title"  (input "t" title 50))
        (if prefer-url*
            (do (row "url" (input "u" url 50))
                (when showtext
                  (row "" "<b>or</b>")
                  (row "text" (textarea "x" 4 50 (only.pr text)))))
            (do (row "text" (textarea "x" 4 50 (only.pr text)))
                (row "" "<b>or</b>")
                (row "url" (input "u" url 50))))
        (row "" (submit))
        (spacerow 20)
        (row "" submit-instructions*)))))

(= submit-instructions*
   "Leave url blank to submit a question for discussion. If there is 
    no url, the text (if any) will appear at the top of the comments 
    page. If there is a url, the text will be ignored.")

; For use by outside code like bookmarklet.
; http://news.domain.com/submitlink?u=http://foo.com&t=Foo
; Added a confirm step to avoid xss hacks.

; (newsop submitlink (u t)
;   (if user 
;       (submit-page user u t)
;       (submit-login-warning u t)))

(= title-limit* 80
   retry*       "Please try again."
   toolong*     "Please make title < @title-limit* characters."
   bothblank*   "The url and text fields can't both be blank.  Please
                 either supply a url, or if you're asking a question,
                 put it in the text field."
   toofast*     "You're submitting too fast.  Please slow down.  Thanks."
   spammage*    "Stop spamming us.  You're wasting your time.")

; Only for annoyingly high-volume spammers. For ordinary spammers it's
; enough to ban their sites and ip addresses.

(disktable big-spamsites* (+ newsdir* "big-spamsites"))

(def process-story (user url title showtext text ip)
  (aif (and (~blank url) (live-story-w/url url))
       (do (vote-for user it)
           (item-url it!id))
       (if (no user)
            (flink [submit-login-warning url title showtext text])
           (no (and (or (blank url) (valid-url url)) 
                    (~blank title)))
            (flink [submit-page user url title showtext text retry*])
           (len> title title-limit*)
            (flink [submit-page user url title showtext text toolong*])
           (and (blank url) (blank text))
            (flink [submit-page user url title showtext text bothblank*])
           (let site (sitename url)
             (or (big-spamsites* site) (recent-spam site)))
            (flink [msgpage user spammage*])
           (oversubmitting user ip 'story url)
            (flink [msgpage user toofast*])
           (let s (create-story url (process-title title) text user ip)
             (story-ban-test user s ip url)
             (when (ignored user) (kill s 'ignored))
             (submit-item user s)
             (maybe-ban-ip s)
             "newest"))))

(def submit-item (user i)
  (push i!id (uvar user submitted))
  (save-prof user)
  (vote-for user i))

(def recent-spam (site)
  (and (caris (banned-sites* site) 'ignore)
       (recent-items [is (sitename _!url) site] 720)))

(def recent-items (test minutes)
  (let cutoff (- (seconds) (* 60 minutes))
    (latest-items test [< _!time cutoff])))

; Turn this on when spam becomes a problem.

(= enforce-oversubmit* nil)

; New user can't submit more than 2 stories in a 2 hour period.
; Give overeager users the key toofast to make limit permanent.

(def oversubmitting (user ip kind (o url))
  (and enforce-oversubmit*
       (or (check-key user 'toofast)
           (ignored user)
           (< (user-age user) new-age-threshold*)
           (< (karma user) new-karma-threshold*))
       (len> (keep [is _!type kind]
                   (recent-items [or (author user _) (is _!ip ip)] 180))
             (if (is kind 'story)
                 (if (bad-user user) 0 1)
                 (if (bad-user user) 1 10)))))

; Note that by deliberate tricks, someone could submit a story with a 
; blank title.

(diskvar scrubrules* (+ newsdir* "scrubrules"))

(def process-title (s)
  (let s2 (multisubst scrubrules* s)
    (zap upcase (s2 0))
    s2))

(def live-story-w/url (url) 
  (aand (url->story* (canonical-url url)) (check (item it) live)))

(def parse-site (url)
  (rev (tokens (cadr (tokens url [in _ #\/ #\?])) #\.)))

(defmemo sitename (url)
  (and (valid-url url)
       (let toks (parse-site (rem #\space url))
         (if (number? (saferead (car toks)))
             (w/string (prall toks "" "."))
             (let ((t1 t2 t3 . rest) toks  )
               (if (and (~in t3 nil "www")
                        (or (mem t1 multi-tld-countries*) 
                            (mem t2 long-domains*)))
                   (+ t3 "." t2 "." t1)
                   (and t2 (+ t2 "." t1))))))))

(= multi-tld-countries* '("uk" "jp" "au" "in" "ph" "tr" "za" "my" "nz" "br" 
                          "mx" "th" "sg" "id" "pk" "eg" "il" "at" "pl"))

(= long-domains* '("blogspot" "wordpress" "livejournal" "blogs" "typepad" 
                   "weebly" "posterous" "blog-city" "supersized" "dreamhosters"
                   ; "sampasite"  "multiply" "wetpaint" ; all spam, just ban
                   "eurekster" "blogsome" "edogo" "blog" "com"))

(def create-story (url title text user ip)
  (newslog ip user 'create url (list title))
  (let s (inst 'item 'type 'story 'id (new-item-id) 
                     'url url 'title title 'text text 'by user 'ip ip)
    (save-item s)
    (= (items* s!id) s)
    (unless (blank url) (register-url s url))
    (push s stories*)
    s))



; Bans

; (define-global ignore (user subject cause)
;   (set (ignored subject) true)
;   (save-prof subject)
;   (log-ignore user subject cause))

(diskvar ignore-log* (+ newsdir* "ignore-log"))

(define-global log-ignore (user subject cause)
  (todisk ignore-log* (cons (list subject user cause) (ignore-log*))))

; Kill means stuff with this substring gets killed. Ignore is stronger,
; means that user will be auto-ignored.  Eventually this info should
; be stored on disk and not in the source code.

(disktable banned-ips*     (+ newsdir* "banned-ips"))   ; was ips
(disktable banned-sites*   (+ newsdir* "banned-sites")) ; was sites

(diskvar  comment-kill*    (+ newsdir* "comment-kill"))
(diskvar  comment-ignore*  (+ newsdir* "comment-ignore"))

(= comment-kill* nil ip-ban-threshold* 3)

(define-global set-ip-ban (user ip yesno (o info))
  (= (banned-ips* ip) (and yesno (list user (seconds) info)))
  (todisk banned-ips*))

(define-global set-site-ban (user site ban (o info))
  (= (banned-sites* site) (and ban (list ban user (seconds) info)))
  (todisk banned-sites*))


; Comment caching doesn't make generation of comments significantly
; faster, but may speed up everything else by generating less garbage.

; It might solve the same problem more generally to make html code
; more efficient.

(defconst comment-cache* (obj))
(defconst comment-cache-timeout* (obj))
(defvar cc-window* 10000)

(defvar comments-printed* 0)
(defvar cc-hits* 0)

(defvar comment-caching* true)


; Page top

(= sand (color 246 246 239) textgray (gray 130))

(def main-color (user) 
  (aif (and user (uvar user topcolor))
       (hex>color it)
       site-color*))

(def pagetop (switch lid label (o title) (o user) (o whence))
; (tr (tdcolor black (vspace 5)))
; (tolist
  (pr:tr (tdcolor (main-color user)
        (tag (table border 0 cellPadding 0 cellSpacing 0 width "100%"
                    style (obj padding: "2px"))
          (tr (gen-logo)
              (when (is switch 'full)
                (tag (td style (obj lineHeight: "12pt" height: "10px"))
                  (spanclass pagetop
                    (pr:tag b (link this-site* "news"))
                    (pr:hspace 10)
                    (pr:toprow user label))))
             (if (is switch 'full)
                 (tag (td style (obj textAlign: "right" paddingRight: "4px"))
                   (spanclass pagetop (topright user whence)))
                 (tag (td style (obj lineHeight: "12pt" height: "10px"))
                   (spanclass pagetop (prbold label))))))))
  (map [_ user] pagefns*)
  (pr:spacerow 10))

(def gen-logo ()
  (tag (td style (obj width: "18px" paddingRight: "4px"))
    (tag (a href parent-url*)
      (tag (img src logo-url* width 18 height 18 
                style (obj border: (cat "1px " border-color* " solid")))))))

(= toplabels* (list "welcome" "new" "threads" "comments" "leaders"))

; redefined later

(= welcome-url* "welcome")

(def toprow (user label)
  (print (str (list 'toprow user: user label: label)))
  (w/bars 
    (when (noob user)
      (toplink "welcome" welcome-url* label)) 
    (toplink "new" "newest" label)
    (when user
      (toplink "threads" (threads-url user) label))
    (toplink "comments" "newcomments" label)
    (toplink "leaders"  "leaders"     label)
    (hook 'toprow user label)
    (link "submit")
    (unless (or (nil? label) (mem label toplabels*))
      (fontcolor white label))))

(def toplink (name dest label)
  (tag-if (is name label) (span class 'topsel)
    (link name dest)))

(def topright (user whence (o showkarma t))
  (when user 
    (userlink user user nil)
    (when showkarma (pr (tostr " (" (karma user) ")")))
    (pr " | "))
  (if user
      (rlinkf 'logout (req)
        (when-umatch/r user req
          (logout-user user)
          whence))
      (onlink "login"
        (login-page 'both nil 
                    (list (fn (u ip) 
                            (ensure-news-user u)
                            (newslog ip u 'top-login))
                          whence)))))

(def noob (user)
  (and user (< (days-since (uvar user created)) 1)))


; Doc

; (defop formatdoc req
;   (msgpage (get-user req) formatdoc* "Formatting Options"))

(= formatdoc-url* "formatdoc")

(= formatdoc* 
"Blank lines separate paragraphs.
<p> Text after a blank line that is indented by two or more spaces is 
reproduced verbatim.  (This is intended for code.)
<p> Text surrounded by asterisks is italicized, if the character after the 
first asterisk isn't whitespace.
<p> Urls become links, except in the text field of a submission.<br><br>")


; Noprocrast

(def check-procrast (user)
  (or (no user)
      (no (uvar user noprocrast))
      (let now (seconds)
        (unless (uvar user firstview)
          (reset-procrast user))
        (or (when (< (/ (- now (uvar user firstview)) 60)
                     (uvar user maxvisit))
              (= (uvar user lastview) now)
              (save-prof user)
              t)
            (when (> (/ (- now (uvar user lastview)) 60)
                     (uvar user minaway))
              (reset-procrast user)
              t)))))
                
(def reset-procrast (user)
  (= (uvar user lastview) (= (uvar user firstview) (seconds)))
  (save-prof user))

(def procrast-msg (user whence)
  (let m (+ 1 (trunc (- (uvar user minaway)
                        (minutes-since (uvar user lastview)))))
    (pr "<b>Get back to work!</b>")
    (para "Sorry, you can't see this page.  Based on the anti-procrastination
           parameters you set in your profile, you'll be able to use the site 
           again in " (plural m "minute") ".")
    (para "(If you got this message after submitting something, don't worry,
           the submission was processed.)")
    (para "To change your anti-procrastination settings, go to your profile 
           by clicking on your username.  If <tt>noprocrast</tt> is set to 
           <tt>yes</tt>, you'll be limited to sessions of <tt>maxvisit</tt>
           minutes, with <tt>minaway</tt> minutes between them.")
    (para)
    (w/rlink whence (underline (pr "retry")))
    ; (hspace 20)
    ; (w/rlink (do (reset-procrast user) whence) (underline (pr "override")))
    (br2)))




; Users

(def user-url (user) (+ "user?id=" user))

(= show-avg* nil)

(def userlink (user subject (o show-avg t))
  (pr (link (user-name user subject) (user-url subject)))
  (awhen (and show-avg* (admin user) show-avg (uvar subject avg))
    (pr " (" (num it 1 t t) ")")))

(= noob-color* (color 60 150 60))

(def user-name (user subject)
  (if (and (editor user) (ignored subject))
       (fontcolor darkred (pr subject))
      (and (editor user) (< (user-age subject) 1440))
       (fontcolor noob-color* (pr subject))
      subject))


; (newsop user (id)
;   (if (only.profile id)
;       (user-page user id)
;       (pr "No such user.")))

(def user-page (user subject)
  (let here (user-url subject)
    (shortpage user nil nil (+ "Profile: " subject) here
      (pr:profile-form user subject)
      (hook 'user user subject))))


(def profile-form (user subject)
  (let prof (profile subject) 
    (vars-form user
               (user-fields user subject)
               (fn (name val) 
                 (when (and (is name 'ignore) val (no? prof!ignore))
                   (log-ignore user subject 'profile))
                 (= (get prof name) val))
               (fn () (save-prof subject)
                      (user-page user subject)))))

(= topcolor-threshold* 250)

(def user-fields (user subject)
  (let (e (editor user) 
        a (admin user) 
        w (is user subject)
        k (and w (> (karma user) topcolor-threshold*))
        u (or a w)
        m (or a (and (member user) w))
        h (profile subject)
        p [get h _])
    `((string  user       ,subject                                 ,t  ,nil)
      (string  name       ,(p 'name)                               ,m  ,m)
      (string  created    ,(text-age:user-age subject)             ,t  ,nil)
      (int     auth       ,(p 'auth)                               ,e  ,a)
      (yesno   member     ,(p 'member)                             ,a  ,a)
      (posint  karma      ,(p 'karma)                              ,t  ,a)
      (num     avg        ,(p 'avg)                                ,a  ,nil)
      (yesno   ignore     ,(p 'ignore)                             ,e  ,e)
      (num     weight     ,(p 'weight)                             ,a  ,a)
      (mdtext2 about      ,(p 'about)                              ,t  ,u)
      (string  email      ,(p 'email)                              ,u  ,u)
      (yesno   showdead   ,(p 'showdead)                           ,u  ,u)
      (yesno   noprocrast ,(p 'noprocrast)                         ,u  ,u)
      (string  firstview  ,(p 'firstview)                          ,a  ,nil)
      (string  lastview   ,(p 'lastview)                           ,a  ,nil)
      (posint  maxvisit   ,(p 'maxvisit)                           ,u  ,u)
      (posint  minaway    ,(p 'minaway)                            ,u  ,u)
      (sexpr   keys       ,(p 'keys)                               ,a  ,a)
      (hexcol  topcolor   ,(or (p 'topcolor) site-color*)          ,k  ,k)
      (int     delay      ,(p 'delay)                              ,u  ,u)
      (string  ,"" ,(resetpw-link)                                 ,w  ,nil)
      (string  ,"" ,(underlink "submissions" (submitted-url subject)) ,w  ,nil)
      (string  ,"" ,(underlink "comments"    (threads-url subject))   ,w  ,nil)
      (string  saved      ,(saved-link user subject)               ,u  ,nil)
      
      )))

(def saved-link (user subject)
  (when (or (admin user) (is user subject))
    (let n (if (len> (votes subject) 500)
               "many" 
               (len (voted-stories user subject)))
      (if (is n 0)
          ""
          (underlink n (saved-url subject))))))

(def resetpw-link ()
  (underlink "change password" "resetpw"))



(def text-age (a)
  (w/string
    (if (>= a 1440) (pr (plural (trunc (/ a 1440)) "day")    " ago")
        (>= a   60) (pr (plural (trunc (/ a 60))   "hour")   " ago")
                    (pr (plural (trunc a)          "minute") " ago"))))



(def voted-stories (user subject)
  (keep [and (astory _) (cansee user _)]
        (map item (keys (or (votes subject) ())))))



(def saved-url (user) (+ "saved?id=" user))

; Submitted

(def submitted-url (user) (+ "submitted?id=" user))

; Threads

(def threads-url (user) (+ "threads?id=" user))

(do)
