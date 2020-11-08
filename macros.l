(define-macro %brackets body
  `(%array ,@body))

(define-macro %braces body
  `(%object ,@body))

(define-macro do body
  `(%do ,@body))

(define-macro quote (form)
  (quoted form))

(define-macro quasiquote (form)
  (quasiexpand form 1))

(define-macro while (test rest: body)
  `(%while ,test (%do ,@body) ,@(props body)))

(define-global get-place (place setfn)
  (let place (macroexpand place)
    (if (or (atom? place)
            (and (= (hd place) 'get)
                 (nil? (getenv 'get 'place-expander)))
            (accessor-literal? (hd (tl place))))
        (setfn place (fn (v) `(%set ,place ,v)))
      (let (head (hd place)
            gf (getenv head 'place-expander))
        (if gf (apply gf setfn (tl place))
          (error (cat (str place) " is not a valid place expression")))))))

(define-macro let-place (vars place rest: body)
  `(get-place ,place (fn ,vars ,@body)))

(define-macro define-expander (name handler)
  (with form `(setenv ',name place-expander: ,handler)
    (eval form)))

(define-global define-setter (name setter setfn args vars)
  (if (none? args)
      (let vars (reverse (or vars ()))
        (setfn `(,name ,@vars) (fn (v) (apply setter v vars))))
    (let v (hd args)
      (%call define-setter name setter setfn (tl args) `(,v ,@vars)))))

(define-macro define-setter (name arglist rest: body)
  `(define-expander ,name
     (fn (setfn rest: args)
       (%call define-setter ',name (fn ,arglist ,@body) setfn args))))

(define-macro set args
  `(%do ,@(map (fn ((lh rh))
                 (let-place (getter setter) lh
                   (setter rh)))
               (pair args))))

(define-macro at (l i)
  (if (and (= target* 'lua) (number? i))
      (inc i)
      (= target* 'lua)
      (set i `(+ ,i 1)))
  `(get ,l ,i))

(define-macro wipe (place)
  (if (= target* 'lua)
      `(set ,place nil)
    `(%delete ,place)))

(define-macro list body
  (let-unique (x)
    (let (l () forms ())
      (each (k v) body
        (if (number? k)
            (set (get l k) v)
          (add forms `(set (get ,x ',k) ,v))))
      (if (some? forms)
          `(let ,x (%array ,@l) ,@forms ,x)
        `(%array ,@l)))))

(define-macro if branches
  (hd (expand-if branches)))

(define-macro case (expr rest: clauses)
  (let-unique (x)
    (let (eq (fn (_) `(= ',_ ,x))
          cl (fn ((a b))
               (if (nil? b) (list a)
                   (or (string? a) (number? a)) (list (eq a) b)
                   (one? a) (list (eq (hd a)) b)
                   (> (# a) 1) (list `(or ,@(map eq a)) b))))
      `(let ,x ,expr
         (if ,@(apply join (map cl (pair clauses))))))))

(define-macro when (cond rest: body)
  `(if ,cond (%do ,@body)))

(define-macro unless (cond rest: body)
  `(if (not ,cond) (%do ,@body)))

(define-macro obj body
  `(%object ,@(mapo (fn (x) x) body)))

(define-macro let (bs rest: body)
  (if (atom? bs) `(let (,bs ,(hd body)) ,@(tl body))
      (none? bs) `(%do ,@body)
      (brackets? bs) `(let (,bs ,(hd body)) ,@(tl body))
    (let ((lh rh rest: bs2) bs
          (id val rest: bs1) (bind lh rh)
          id1 (unique id))
      `(%do (%local ,id1 ,val)
            (let-symbol (,id ,id1)
              (let ,(join bs1 bs2) ,@body))))))

(define-macro with (x v rest: body)
  `(let (,x ,v) ,@body ,x))

(define-macro let-when (x v rest: body)
  (let-unique (y)
    `(let ,y ,v
       (when (yes ,y)
         (let (,x ,y)
           ,@body)))))

(define-macro define-transformer (name form rest: body)
  `(setenv ',name transformer: (fn (,form) ,@body) ,@(props body)))

(define-macro define-macro (name args rest: body)
  `(setenv ',name macro: (fn ,args ,@body) ,@(props body)))

(define-macro define-special (name args rest: body)
  `(setenv ',name special: (fn ,args ,@body) ,@(props body)))

(define-macro define-symbol (name expansion)
  `(setenv ',name symbol: ',expansion))

(define-macro define-reader ((char s) rest: body)
  `(set (get read-table ,char) (fn (,s) ,@body)))

(define-macro define (name x rest: body)
  (if (some? body)
      `(%local-function ,name ,@(bind-function x body) ,@(props body))
    `(%local ,name ,x)))

(define-macro define-global (name x rest: body)
  (if (some? body)
      `(%global-function ,name ,@(bind-function x body) ,@(props body))
      (global-id? name)
      `(set ,name ,x)
    `(set (get _G ',(compile name)) ,x)))

(define-macro with-frame body
  (let-unique (x)
    `(%do (add environment* (obj))
          (with ,x (%do ,@body)
            (drop environment*)))))

(define-macro with-bindings ((names) rest: body)
  (let-unique (x)
   `(with-frame
      (each ,x ,names
        (setenv ,x variable: true))
      ,@body)))

(define-macro let-macro (definitions rest: body)
  (with-frame
    (step m definitions
      (eval `(define-macro ,@m)))
    `(%do ,@(macroexpand body))))

(define-macro let-symbol (expansions rest: body)
  (with-frame
    (step (name exp) (pair expansions)
      (eval `(define-symbol ,name ,exp)))
    `(%do ,@(macroexpand body))))

(define-macro let-unique (names rest: body)
  (let bs (map (fn (n)
                 (list n `(unique ',n)))
               names)
    `(let ,(apply join bs)
       ,@body)))

(define-macro fn (args rest: body)
  `(%function ,@(bind-function args body) ,@(props body)))

(define-macro apply (f rest: args)
  (if (> (# args) 1)
      `(%call apply ,f (join (list ,@(almost args)) ,(last args)))
      `(%call apply ,f ,@args)))

(define-macro guard (expr)
  (if (= target* 'js)
      `((fn () (%try (list true ,expr))))
    `(list (xpcall
             (fn () ,expr)
             (fn (m)
               (if (obj? m) m
                 (obj stack: ((get debug 'traceback))
                      message: (if (string? m) (clip m (+ (or (search m ": ") -2) 2))
                                   (nil? m) ""
                                 (str m)))))))))

(define-macro each (x t rest: body)
  (let-unique (o n i)
    (let ((k v) (if (atom? x) (list i x)
                  (if (> (# x) 1) x
                      (list i (hd x)))))
      `(let (,o ,t)
         (for (,k) (pairs ,o)
           (let (,v (get ,o ,k))
             ,@body))))))

(define-macro for (i to rest: body)
  (if (obj? i)
      `(let ,(apply join (map (fn (x) `(,x nil)) i))
         (%for ,to (%names ,@i) (%do ,@body) ,@(props body)))
    `(let ,i 0
       (while (< ,i ,to)
         ,@body
         (inc ,i)))))

(define-macro step (v t rest: body)
  (let-unique (x i)
    `(let (,x ,t)
       (for ,i (# ,x)
         (let (,v (at ,x ,i))
           ,@body)))))

(define-macro set-of xs
  (let l ()
    (each x xs
      (set (get l x) true))
    `(obj ,@l)))

(define-macro language () `',target*)

(define-macro target clauses
  (get clauses target*))

(define-macro join! (a rest: bs)
  `(set ,a (join ,a ,@bs)))

(define-macro cat! (a rest: bs)
  `(set ,a (cat ,a ,@bs)))

(define-macro inc (n by)
  `(set ,n (+ ,n ,(if (nil? by) 1 by))))

(define-macro dec (n by)
  `(set ,n (- ,n ,(if (nil? by) 1 by))))

(define-macro with-indent (form)
  (let-unique (x)
    `(%do (inc indent-level*)
          (with ,x ,form
            (dec indent-level*)))))

(define-macro undefined? (x)
  `(target lua: (= ,x nil)
           js: (= (typeof ,x) "undefined")))

(define-macro export names
  `(with exports (if (undefined? exports) (obj) exports)
     ,@(map (fn (k)
              `(set (exports ,(cat "." k)) ,k))
            names)
     (target lua: (return exports))))

(define-macro when-compiling body
  (eval `(%do ,@body)))

(define-macro during-compilation body
  (with form `(%do ,@body (%do))
    (eval form)))

(define-transformer compose ((compose rest: fns) rest: body)
  (if (none? fns) (macroexpand `(do ,@body))
      (one? fns) (macroexpand `(,@fns ,@body))
    (macroexpand `((,compose ,@(almost fns)) (,(last fns) ,@body)))))

(define-transformer complement ((complement form) rest: body)
  (if (hd? form 'complement)
      (macroexpand `(,(at form 1) ,@body))
    (macroexpand `(no (,form ,@body)))))

(define-transformer expansion ((expansion) form)
  form)

(define-setter hd (v l)
  `(set (at ,l 0) ,v))
