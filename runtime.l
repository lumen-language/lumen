(define-global environment* (list (obj)))
(define-global target* (language))

(let v nil
  (define-global values (...)
    (target lua: ...
            js: (at (set v (list ...)) 0)))

  (define-global results (x ...)
    (target lua: (list x ...)
            js: (do (define r (or v (list x ...)))
                    (set v nil)
                    r))))

(target js:
  (define-global select (n ...)
    (if (= n "#")
        (values (get (results ...) 'length))
      (values (unpack (cut (results ...) (- n 1)))))))

(target js:
  (define-global pairs (l)
    ((get ((get Object 'keys) l) 'map)
     (fn (k) (if (numeric? k)
                 (parseInt k)
               k)))))

(target js:
  (define-global ipairs (l)
    ((get (pairs l) 'filter) number?)))

(target js:
  (define-global pcall (f ...)
    (let ((ok v) (guard (results (f ...))))
      (values ok (unpack v)))))

(define-global nil? (x)
  (target
    js: (or (= x nil) (= x null))
    lua: (= x nil)))

(define-global is? (x) (not (nil? x)))

(define-global no (x) (or (nil? x) (= x false)))
(define-global yes (x) (not (no x)))
(define-global either (x y) (if (is? x) x y))

(define-global has? (l k)
  (target js: ((get l 'hasOwnProperty) k)
          lua: (is? (get l k))))

(define-global # (x)
  (target js: (or (get x 'length) 0) lua: (%literal "#" x)))

(define-global none? (x) (= (# x) 0))
(define-global some? (x) (> (# x) 0))
(define-global one? (x) (= (# x) 1))
(define-global two? (x) (= (# x) 2))

(define-global hd (l) (at l 0))

(target js: (define-global type (x) (typeof x)))

(define-global string? (x) (= (type x) 'string))
(define-global number? (x) (= (type x) 'number))
(define-global boolean? (x) (= (type x) 'boolean))
(define-global function? (x) (= (type x) 'function))

(define-global obj? (x)
  (and (is? x)
       (= (type x) (target lua: 'table js: 'object))))

(define-global atom? (x)
  (or (nil? x) (string? x) (number? x) (boolean? x)))

(define-global hd? (l x)
  (and (obj? l)
       (if (function? x)
           (x (hd l))
           (nil? x) (hd l)
         (= (hd l) x))))

(define-global nan (/ 0 0))
(define-global inf (/ 1 0))
(define-global -inf (- inf))

(define-global nan? (n)
  (not (= n n)))

(define-global inf? (n)
  (or (= n inf) (= n -inf)))

(define-global clip (s from upto)
  (target js: ((get s 'substring) from upto)
          lua: ((get string 'sub) s (+ from 1) upto)))

(define-global natural? (i)
  (and (number? i) (> i 0) (= (% i 1) 0)))

(define-global index? (i)
  (target js: (number? i)
          lua: (natural? i)))

(define-global iterate (o f l r)
  (let (from inf upto -inf)
    (each (k v) l
      (if (index? k)
          (do (if (< k from) (set from k))
              (if (> k upto) (set upto k)))
        (set r (f r v k nil))))
    (target js: (inc upto)
            lua: (dec from))
    (let i from
      (while (< i upto)
        (let v (at l i)
          (set r (f r v nil i)))
        (inc i)))
    (with o (or o (obj))
      (set (get o 'result) r
           (get o 'from) from
           (get o 'upto) upto))))

(let o (obj)
  (define-global reduce (f l r)
    (get (iterate o f l r) 'result)))

(define-global cut (x from upto)
  (with l ()
    (let (j 0
          i (if (or (nil? from) (< from 0)) 0 from)
          n (# x)
          upto (if (or (nil? upto) (> upto n)) n upto))
      (while (< i upto)
        (set (at l j) (at x i))
        (inc i)
        (inc j))
      (each (k v) x
        (unless (number? k)
          (set (get l k) v))))))

(define-global props (x)
  (with t ()
    (each (k v) x
      (unless (number? k)
        (set (get t k) v)))))

(define-global edge (x)
  (- (# x) 1))

(define-global inner (x)
  (clip x 1 (edge x)))

(define-global tl (l) (cut l 1))

(define-global char (s n)
  (target js: ((get s 'charAt) n) lua: (clip s n (+ n 1))))

(define-global code (s n)
  (target
    js: ((get s 'charCodeAt) n)
    lua: ((get string 'byte) s (if n (+ n 1)))))

(define-global from-code (n)
  (target
    js: ((get String 'fromCharCode) n)
    lua: ((get string 'char) n)))

(define-global string-literal? (x)
  (and (string? x) (= (char x 0) "\"")))

(define-global id-literal? (x)
  (and (string? x) (= (char x 0) "|")))

(define-global add (l x)
  (target js: (do ((get l 'push) x) nil)
          lua: ((get table 'insert) l x)))

(define-global drop (l)
  (target js: ((get l 'pop))
          lua: ((get table 'remove) l)))

(define-global last (l)
  (at l (edge l)))

(define-global almost (l)
  (cut l 0 (edge l)))

(define-global reverse (l)
  (with l1 (props l)
    (let i (edge l)
      (while (>= i 0)
        (add l1 (at l i))
        (dec i)))))

(define-global join ls
  (with r ()
    (step l ls
      (when l
        (let n (# r)
          (each (k v) l
            (if (number? k) (inc k n))
            (set (get r k) v)))))))

(define-global testify (x test)
  (if (function? x) x
      test
      (fn (y) (test y x))
    (fn (y) (= x y))))

(define-global find (x t)
  (let f (testify x)
    (each x t
      (let y (f x)
        (if y (return y))))))

(define-global first (x l pos)
  (let (f (testify x)
        i (either pos 0)
        n -1)
    (each (k v) l
      (when (number? k)
        (target lua: (dec k))
        (set n (max n k))))
    (inc n)
    (while (< i n)
      (let v (at l i)
        (let-when y (f v)
          (return i)))
      (inc i))))

(define-global in? (x t)
  (find (testify x) t))

(define-global pair (l)
  (with l1 ()
    (for i (# l)
      (add l1 (list (at l i) (at l (+ i 1))))
      (inc i))))

(define-global sort (l f)
  (target
    lua: (do ((get table 'sort) l f) l)
    js: ((get l 'sort) (when f (fn (a b) (if (f a b) -1 1))))))

(define-global map (f x)
  (with t ()
    (step v x
      (let y (f v)
        (if (is? y)
          (add t y))))
    (each (k v) x
      (unless (number? k)
        (let y (f v)
          (when (is? y)
            (set (get t k) y)))))))

(define-global keep (v x)
  (let f (testify v)
    (map (fn (v) (when (yes (f v)) v)) x)))

(define-global keys? (t)
  (each (k v) t
    (unless (number? k)
      (return true)))
  false)

(define-global empty? (t)
  (each x t
    (return false))
  true)

(define-global stash (args)
  (when (keys? args)
    (let p ()
      (each (k v) args
        (unless (number? k)
          (set (get p k) v)))
      (set (get p '_stash) true)
      (add args p)))
  args)

(define-global unstash (args)
  (if (none? args) ()
    (let l (last args)
      (if (and (obj? l) (get l '_stash))
          (with args1 (almost args)
            (each (k v) l
              (unless (= k '_stash)
                (set (get args1 k) v))))
        args))))

(define-global destash! (l args1)
  (if (and (obj? l) (get l '_stash))
      (each (k v) l
        (unless (= k '_stash)
          (set (get args1 k) v)))
    l))

(define-global search (s pattern start)
  (target
    js: (let i ((get s 'indexOf) pattern start)
          (if (>= i 0) i))
    lua: (let (start (if start (+ start 1))
               i ((get string 'find) s pattern start true))
           (and i (- i 1)))))

(define-global split (s sep)
  (if (or (= s "") (= sep "")) ()
    (with l ()
      (let n (# sep)
        (while true
          (let i (search s sep)
            (if (nil? i) (break)
              (do (add l (clip s 0 i))
                  (set s (clip s (+ i n)))))))
        (add l s)))))

(define-global cat (s ...)
  (reduce (fn (a b) (cat a b)) (list ...) (or s "")))

(define-global + (n ...)
  (reduce (fn (a b) (+ a b)) (list ...) (or n 0)))

(define-global - (n ...)
  (reduce (fn (a b) (- a b)) (list ...) (or n 0)))

(define-global * (n ...)
  (reduce (fn (a b) (* a b)) (list ...) (either n 1)))

(define-global / (n ...)
  (reduce (fn (a b) (/ a b)) (list ...) (either n 1)))

(define-global % (n ...)
  (reduce (fn (a b) (% a b)) (list ...) (either n 1)))

(define pairwise (f xs)
  (for i (edge xs)
    (let (a (at xs i)
          b (at xs (+ i 1)))
      (unless (f a b)
        (return false))))
  (return true))

(define-global < xs (pairwise (fn (a b) (< a b)) xs))
(define-global > xs (pairwise (fn (a b) (> a b)) xs))
(define-global = xs (pairwise (fn (a b) (= a b)) xs))
(define-global <= xs (pairwise (fn (a b) (<= a b)) xs))
(define-global >= xs (pairwise (fn (a b) (>= a b)) xs))

(define-global number (s)
  (target
    js: (let n (parseFloat s)
          (unless (isNaN n) n))
    lua: (tonumber s)))

(define-global number-code? (n)
  (and (> n 47) (< n 58)))

(define-global numeric? (s)
  (let n (# s)
    (for i n
      (unless (number-code? (code s i))
        (return false))))
  (some? s))

(define-global lowercase-code? (n)
  (and (> n 96) (< n 123))) ; a-z

(define-global camel-case (str)
  (with s ""
    (let n (# str)
      (for i n
        (let c (code str i)
          (when (and (= c 45) ; "-"
                     (lowercase-code? (or (code str (- i 1)) 0))
                     (lowercase-code? (or (code str (+ i 1)) 0)))
            (set c (- (code str (inc i)) 32)))
          (cat! s (from-code c)))))))

(target js:
  (define-global tostring (x)
    (if (string? x) x
        (nil? x) "nil"
        (nan? x) "nan"
        (= x inf) "inf"
        (= x -inf) "-inf"
        (boolean? x) (if x "true" "false")
      ((get x 'toString)))))

(define-global escape (s)
  (let s1 "\""
    (for i (# s)
      (let (c (char s i)
            c1 (if (= c "\n") "\\n"
                   (= c "\r") "\\r"
                   (= c "\"") "\\\""
                   (= c "\\") "\\\\"
                 c))
        (cat! s1 c1)))
    (cat s1 "\"")))

(define-global str (x stack)
  (if (string? x) (escape x)
      (atom? x) (tostring x)
      (function? x) "function"
      (and stack (in? x stack)) "circular"
      (target js: false lua: (not (= (type x) 'table)))
      (escape (tostring x))
    (let (s "(" sp ""
          xs () ks ()
          l (or stack ()))
      (add l x)
      (each (k v) x
        (if (number? k)
            (set (get xs k) (str v l))
          (do (target lua:
                (unless (string? k)
                  (set k (str k l))))
              (add ks (cat k ":"))
              (add ks (str v l)))))
      (drop l)
      (each v (join xs ks)
        (cat! s sp v)
        (set sp " "))
      (cat s  ")"))))

(define-global apply (f args)
  (f (unpack (stash args))))

(define-global call (f ...)
  (f ...))

(define-global setenv (k rest: keys)
  (when (string? k)
    (let (frame (if (get keys 'toplevel)
                    (hd environment*)
                  (last environment*))
          entry (or (get frame k) (obj)))
      (each (k v) keys
        (set (get entry k) v))
      (set (get frame k) entry))))

(target js:
  (define-global print (x)
    ((get console 'log) x)))

(target js:
  (define-global error (x)
    (throw (new (Error x)))))

(define math (target js: Math lua: math))

(define-global abs (get math 'abs))
(define-global acos (get math 'acos))
(define-global asin (get math 'asin))
(define-global atan (get math 'atan))
(define-global atan2 (get math 'atan2))
(define-global ceil (get math 'ceil))
(define-global cos (get math 'cos))
(define-global floor (get math 'floor))
(define-global log (get math 'log))
(define-global log10 (get math 'log10))
(define-global max (get math 'max))
(define-global min (get math 'min))
(define-global pow (get math 'pow))
(define-global random (get math 'random))
(define-global sin (get math 'sin))
(define-global sinh (get math 'sinh))
(define-global sqrt (get math 'sqrt))
(define-global tan (get math 'tan))
(define-global tanh (get math 'tanh))
(define-global trunc (get math 'floor))
