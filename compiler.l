(define-global getenv (k p)
  (when (string? k)
    (let i (edge environment*)
      (while (>= i 0)
        (let b (get (at environment* i) k)
          (if (is? b)
              (return (if p (get b p) b))
            (dec i)))))))

(define transformer-function (k)
  (getenv k 'transformer))

(define transformer? (k)
  (is? (transformer-function k)))

(define macro-function (k)
  (getenv k 'macro))

(define macro? (k)
  (is? (macro-function k)))

(define special? (k)
  (is? (getenv k 'special)))

(define special-form? (form)
  (and (not (atom? form)) (special? (hd form))))

(define statement? (k)
  (and (special? k) (getenv k 'stmt)))

(define symbol-expansion (k)
  (getenv k 'symbol))

(define symbol? (k)
  (is? (symbol-expansion k)))

(define variable? (k)
  (is? (getenv k 'variable)))

(define-global bound? (x)
  (or (macro? x)
      (special? x)
      (symbol? x)
      (variable? x)))

(define-global quoted (form)
  (if (string? form) (escape form)
      (atom? form) form
    `(list ,@(map quoted form))))

(define-global unquoted (form)
  (if (string-literal? form)
      (if (= (read-string form) form)
          (eval form)
        (error "unquoted: bad string-literal"))
      (hd? form 'quote)
      (at form 1)
    (compile form)))

(define literal (s)
  (if (string-literal? s) s (quoted s)))

(define stash-function (args)
  (if (keys? args)
      (let l '(%object "_stash" true)
        (each (k v) args
          (unless (number? k)
            (add l (literal k))
            (add l v)))
        (join args (list l)))
    args))

(define bias (k)
  (when (and (number? k)
             (not (= target* (language))))
    (if (= target* 'js)
        (dec k)
      (inc k)))
  k)

(define-global bind-optional (lh rh)
  (when (or (hd? lh 'o)
            (hd? lh 'or)
            (hd? lh '&optional))
    (let ((_ var val) lh)
      (bind var `(%if (= ,rh nil) ,(or val 'nil) ,rh)))))

(define-global bind-destructuring (lh rh)
  (let-unique (id)
    (with bs (list id rh)
      (each (k v) lh
        (let x (if (= k 'rest)
                   `(cut ,id ,(# lh))
                 `(get ,id ',(bias k)))
          (join! bs (bind v x)))))))

(define-global bind (lh rh)
  (if (atom? lh) `(,lh ,rh)
    (or (bind-optional lh rh)
        (bind-destructuring lh rh))))

(define-global bind-function (args body)
  (let args1 ()
    (define rest ()
      (set (get args1 'rest) true)
      `(unstash (list ,"...")))
    (if (atom? args)
        (list args1 `(let ,(list args (rest)) ,@body))
      (let (bs () ks (obj))
        (let-unique (r)
          (each (k v) args
            (if (number? k)
                (if (atom? v) (add args1 v)
                  (let-unique (x)
                    (add args1 x)
                    (join! bs (list v x))))
              (set (get ks k) v)))
          (when (keys? args)
            (join! bs (list r (rest)))
            (let n (# args1)
              (for i n
                (let v (at args1 i)
                  (join! bs (list v `(destash! ,v ,r))))))
            (join! bs (list ks r))))
        (list args1 `(let ,bs ,@body))))))

(define quoting? (depth)
  (number? depth))

(define quasiquoting? (depth)
  (and (quoting? depth) (> depth 0)))

(define can-unquote? (depth)
  (and (quoting? depth) (= depth 1)))

(define quasisplice? (x depth)
  (and (can-unquote? depth)
       (not (atom? x))
       (= (hd x) 'unquote-splicing)))

(define expand-local ((x name value))
  (setenv name variable: true)
  `(%local ,(macroexpand name) ,(macroexpand value)))

(define expand-function ((x args rest: body))
  (with-bindings (args)
    `(%function ,args ,@(map macroexpand body))))

(define expand-definition ((x name args rest: body))
  (with-bindings (args)
    `(,x ,(macroexpand name) ,args ,@(map macroexpand body))))

(define expand-macro (form)
  (macroexpand (expand1 form)))

(define-global expand1 ((name rest: body))
  (apply (macro-function name) body))

(define expand-transformer (form)
  ((transformer-function (hd (hd form))) form))

(define-global expand-compose (form)
  (when (string? form)
    (when (>= (# form) 3)
      (let-when i (search form ":")
        (let parts (split form ":")
          (unless (find none? parts)
            `(compose ,@parts)))))))

(define-global expand-atom-functions* ())

(define-global expand-atom (form)
  (step f expand-atom-functions*
    (let x (f form)
      (unless (= x nil)
        (return x))))
  form)

(define-global macroexpand (form)
  (if (symbol? form)
      (macroexpand (symbol-expansion form))
      (atom? form) (expand-atom form)
      (none? form) (map macroexpand form)
    (let (x (macroexpand (hd form))
          args (tl form)
          form `(,x ,@args))
      (if (= x nil) (macroexpand args)
          (= x '%local) (expand-local form)
          (= x '%function) (expand-function form)
          (= x '%global-function) (expand-definition form)
          (= x '%local-function) (expand-definition form)
          (macro? x) (expand-macro form)
          (hd? x transformer?) (expand-transformer form)
        `(,x ,@(map macroexpand args))))))

(define quasiquote-list (form depth)
  (let xs (list '(list))
    (each (k v) form
      (unless (number? k)
        (let v (if (quasisplice? v depth)
                   ;; don't splice, just expand
                   (quasiexpand (at v 1))
                 (quasiexpand v depth))
          (set (get (last xs) k) v))))
    ;; collect sibling lists
    (step x form
      (if (quasisplice? x depth)
          (let x (quasiexpand (at x 1))
            (add xs x)
            (add xs '(list)))
        (add (last xs) (quasiexpand x depth))))
    (let pruned
        (keep (fn (x)
                (or (> (# x) 1)
                    (not (= (hd x) 'list))
                    (keys? x)))
              xs)
      (if (one? pruned)
          (hd pruned)
        `(join ,@pruned)))))

(define-global quasiexpand (form depth)
  (if (quasiquoting? depth)
      (if (atom? form) (list 'quote form)
          ;; unquote
          (and (can-unquote? depth)
               (= (hd form) 'unquote))
          (quasiexpand (at form 1))
          ;; decrease quasiquoting depth
          (or (= (hd form) 'unquote)
              (= (hd form) 'unquote-splicing))
          (quasiquote-list form (- depth 1))
          ;; increase quasiquoting depth
          (= (hd form) 'quasiquote)
          (quasiquote-list form (+ depth 1))
        (quasiquote-list form depth))
      (atom? form) form
      (= (hd form) 'quote) form
      (= (hd form) 'quasiquote)
      ;; start quasiquoting
      (quasiexpand (at form 1) 1)
    (map (fn (x) (quasiexpand x depth)) form)))

(define-global expand-if ((a b rest: c))
  (if (is? b) `((%if ,a ,b ,@(expand-if c)))
      (is? a) (list a)))

(define-global indent-level* 0)

(define-global indentation ()
  (with s ""
    (for i indent-level*
      (cat! s "  "))))

(define reserved
  (obj js: (set-of "=" "==" "+" "-" "%" "*" "/" "<" ">" "<=" ">="
                   "break" "case" "catch" "class" "const" "continue"
                   "debugger" "default" "delete" "do" "else" "eval"
                   "finally" "for" "function" "if" "import" "in"
                   "instanceof" "let" "new" "return" "switch" "throw"
                   "try" "typeof" "var" "void" "with")
       lua: (set-of "=" "==" "+" "-" "%" "*" "/" "<" ">" "<=" ">="
                    "and" "end" "in" "load" "repeat" "while" "break"
                    "false" "local" "return" "do" "for" "nil" "then"
                    "else" "function" "not" "true" "elseif" "if" "or"
                    "until")))

(define-global reserved? (x)
  (has? (get reserved target*) x))

(define valid-code? (n)
  (or (number-code? n)         ; 0-9
      (and (> n 64) (< n 91))  ; A-Z
      (and (> n 96) (< n 123)) ; a-z
      (= n 95)))               ; _

(define-global global-id? (id)
  (let n (# id)
    (and (> n 1)
         (= (char id (- n 1)) "*")
         (valid-code? (code id (- n 2))))))

(define-global compile-id (id escape-reserved?)
  (if (global-id? id)
      (cat "_G." (compile-id (clip id 0 (edge id)) escape-reserved?))
    (let id1 (if (number-code? (code id 0)) "_" "")
      (for i (# id)
        (let (c (char id i)
              n (code c)
              c1 (if (and (= c "-")
                          (not (= id "-")))
                     "_"
                     (valid-code? n) c
                     (= i 0) (cat "_" n)
                   n))
          (cat! id1 c1)))
      (if (and (either escape-reserved? true)
               (reserved? id1))
          (cat "_" id1)
        id1))))

(define-global valid-id? (x escape-reserved?)
  (and (some? x) (= x (compile-id x escape-reserved?))))

(let (names (obj))
  (define-global unique (x)
    (let x (compile-id x true)
      (if (has? names x)
          (let i (get names x)
            (inc (get names x))
            (unique (cat x i)))
        (do (set (get names x) 1)
            (cat "__" x))))))

(define-global key (k)
  (if (string-literal? k)
      (let i (inner k)
        (if (valid-id? i) i (cat "[" k "]")))
    (cat "[" (tostring k) "]")))

(define-global mapo (f t)
  (with o ()
    (each (k v) t
      (let x (f v)
        (when (is? x)
          (add o (literal k))
          (add o x))))))

(define infix
  `((not: (js: ! lua: not))
    (*: * /: / %: %)
    (cat: (js: + lua: ..))
    (+: + -: -)
    (<: < >: > <=: <= >=: >=)
    (=: (js: === lua: ==))
    (and: (js: && lua: and))
    (or: (js: || lua: or))))

(define unary? (form)
  (and (two? form) (in? (hd form) '(not -))))

(define index (k)
  (target js: k lua: (when (number? k) (- k 1))))

(define precedence (form)
  (unless (or (atom? form) (unary? form))
    (each (k v) infix
      (if (get v (hd form)) (return (index k)))))
  0)

(define getop (op)
  (find (fn (level)
          (let x (get level op)
            (if (obj? x) (get x target*)
                (string? x) x)))
        infix))

(define infix? (x)
  (is? (getop x)))

(define-global infix-operator? (x)
  (and (obj? x) (infix? (hd x))))

(define compile-args (args)
  (let (s "(" c "")
    (step x args
      (cat! s c (compile x))
      (set c ", "))
    (cat s ")")))

(define escape-newlines (s)
  (with s1 ""
    (for i (# s)
      (let c (char s i)
        (cat! s1 (if (= c "\n") "\\n"
                     (= c "\r") ""
                   c))))))

(define-global compile-atom (x escape-reserved?)
  (if (and (= x "nil") (= target* 'lua)) x
      (= x "nil") "undefined"
      (= x "...") (cat "..." (if (= target* 'js) (compile "*args") ""))
      (id-literal? x) (inner x)
      (string-literal? x) (escape-newlines x)
      (string? x) (compile-id x (either escape-reserved? true))
      (boolean? x) (if x "true" "false")
      (nan? x) "nan"
      (= x inf) "inf"
      (= x -inf) "-inf"
      (number? x) (cat x "")
    (error (cat "Cannot compile atom: " (str x)))))

(define terminator (stmt?)
  (if (not stmt?) ""
      (= target* 'js) ";\n"
    "\n"))

(define compile-special (form stmt?)
  (let ((x rest: args) form
        (special: special stmt: stmt tr: self-tr?) (getenv x)
        tr (terminator (and stmt? (not self-tr?))))
    (cat (apply special args) tr)))

(define-global accessor-literal? (x)
  (and (string? x)
       (= (char x 0) ".")
       (not (= (char x 1) "."))
       (some? (char x 1))))

(define-global accessor-form? (x)
  (and (obj? x) (accessor-literal? (last x))))

(define-global accessor-literal (x)
  (compile (camel-case (clip x 1)) escape-reserved: false))

(define-global compile-method (f args chain?)
  (if (and chain? (none? args)) f
    (let x (hd args)
      (if (accessor-literal? x)
          (compile-method (cat f "." (accessor-literal x)) (tl args) true)
          (hd? x accessor-literal?)
          (compile-method (cat f
                               (if (= target* 'lua) ":" ".")
                               (accessor-literal (hd x)) (compile-args (tl x)))
                          (tl args)
                          true)
        (cat f (compile-args args))))))

(define parenthesize-call? (x)
  (or (and (not (atom? x))
           (= (hd x) '%function))
      (> (precedence x) 0)))

(define compile-call (form)
  (let (f (hd form)
        f1 (compile f)
        args (compile-method "" (stash-function (tl form))))
    (if (parenthesize-call? f)
        (cat "(" f1 ")" args)
      (cat f1 args))))

(define op-delims (parent child right?)
  (if ((if right? >= >)
       (precedence child)
       (precedence parent))
      (list "(" ")")
    (list "" "")))

(define compile-infix (form)
  (let ((op rest: (a b)) form
        (ao ac) (op-delims form a false)
        (bo bc) (op-delims form b true)
        a (compile a)
        b (compile b)
        op (getop op))
    (if (unary? form)
        (cat op ao " " a ac)
      (cat ao a ac " " op " " bo b bc))))

(define-global compile-function (args body
                                      name: name
                                      prefix: prefix
                                      global: global?
                                      async: async?
                                      generator: generator?)
  (let (id (if name (compile name) "")
        id (if global? (cat "_G." id) id)
        args1 (if (get args 'rest)
                  `(,@args ,"...")
                args)
        args (compile-args args1)
        body (with-indent (compile body stmt: true))
        ind (indentation)
        p (if prefix (cat prefix " ") "")
        tr (if (= target* 'js) "" "end")
        async1 (if async? "async " "")
        func (if generator? "function* " "function "))
    (if name (cat! tr "\n"))
    (if (= target* 'js)
        (cat async1 func id args " {\n" body ind "}" tr)
      (cat p "function " id args "\n" body ind tr))))

(define can-return? (form)
  (and (is? form)
       (or (atom? form)
           (and (not (= (hd form) 'return))
                (not (statement? (hd form)))))))

(define-global compile (form stmt: stmt escape-reserved: esc?)
  (if (nil? form) ""
      (special-form? form)
      (compile-special form stmt)
    (let (tr (terminator stmt)
          ind (if stmt (indentation) "")
          form (if (atom? form) (compile-atom form (either esc? true))
                   (infix? (hd form)) (compile-infix form)
                 (compile-call form)))
      (cat ind form tr))))

(define lower-statement (form tail?)
  (either
    (let (hoist () e (lower form hoist true tail?))
      (if (and (some? hoist) (is? e))
          `(%do ,@hoist ,e)
          (is? e) e
          (> (# hoist) 1) `(%do ,@hoist)
        (hd hoist)))
    '(%do)))

(define lower-body (body tail?)
  (lower-statement `(%do ,@body) tail?))

(define literal? (form)
  (or (atom? form)
      (= (hd form) '%array)
      (= (hd form) '%object)))

(define standalone? (form)
  (or (and (not (atom? form))
           (not (infix? (hd form)))
           (not (literal? form))
           (not (= 'get (hd form)))
           (not (accessor-form? form)))
      (id-literal? form)))

(define lower-do (args hoist stmt? tail?)
  (step x (almost args)
    (let-when e (lower x hoist stmt?)
      (when (standalone? e)
        (add hoist e))))
  (let e (lower (last args) hoist stmt? tail?)
    (if (and tail? (can-return? e))
        `(return ,e)
      e)))

(define lower-set (args hoist stmt? tail?)
  (let ((lh rh) args
        lh1 (lower lh hoist)
        rh1 (lower rh hoist))
    (add hoist `(%set ,lh1 ,rh1))
    (unless (and stmt? (not tail?))
      lh1)))

(define lower-if (args hoist stmt? tail?)
  (let ((cond then else) args)
    (if stmt?
        (add hoist
             `(%if ,(lower cond hoist)
                   ,(lower-body (list then) tail?)
                   ,@(if (is? else) (list (lower-body (list else) tail?)))))
      (let-unique (e)
        (add hoist `(%local ,e nil))
        (add hoist
             `(%if ,(lower cond hoist)
                   ,(lower `(%set ,e ,then))
                   ,@(if (is? else)
                         (list (lower `(%set ,e ,else))))))
        e))))

(define lower-short (x args hoist)
  (let ((a b) args
        hoist1 ()
        b1 (lower b hoist1))
    (if (some? hoist1)
        (let-unique (id)
          (lower `(%do (%local ,id ,a)
                       ,(if (= x 'and)
                            `(%if ,id ,b ,id)
                          `(%if ,id ,id ,b)))
                 hoist))
      `(,x ,(lower a hoist) ,b1))))

(define lower-try (args hoist tail?)
  (add hoist `(%try ,(lower-body args tail?))))

(define lower-while (args hoist)
  (let ((c rest: body) args
        pre ()
        c (lower c pre))
    (add hoist
      (if (none? pre)
          `(%while ,c
             ,(lower-body body))
        `(%while true
            (%do ,@pre
                 (%if (not ,c) (break))
                 ,(lower-body body)))))))

(define lower-for (args hoist)
  (let ((t k rest: body) args)
    (add hoist
         `(%for ,(lower t hoist) ,k
            ,(lower-body body)
            ,@(props body)))))

(define lower-function (args)
  (let ((a rest: body) args)
    `(%function ,a ,(lower-body body true) ,@(props body))))

(define lower-definition (kind args hoist stmt? tail?)
  (let ((name args rest: body) args
        name1 (lower name hoist))
    (add hoist `(,kind ,name1 ,args ,(lower-body body true) ,@(props body)))
    (unless (and stmt? (not tail?))
      name1)))

(define lower-call (form hoist)
  (let form (map (fn (x) (lower x hoist)) form)
    (if (some? form) form)))

(define lower-infix? (form)
  (and (> (# form) 3) (infix? (hd form))))

(define infix-form ((x a rest: bs))
  (step b bs
    (set a (list x a b)))
  a)

(define lower-pairwise? (form)
  (and (> (# form) 3) (in? (hd form) '(< <= = >= >))))

(define pairwise-form ((x a rest: bs))
  (with e '(and)
    (step b bs
      (add e (list x a b))
      (set a b))))

(define lower-special (form hoist)
  (let e (lower-call form hoist)
    (if e (add hoist e))))

(define-global lower (form hoist stmt? tail?)
  (if (atom? form) form
      (empty? form) '(%array)
      (nil? hoist) (lower-statement form)
      (lower-pairwise? form) (lower (pairwise-form form) hoist stmt? tail?)
      (lower-infix? form) (lower (infix-form form) hoist stmt? tail?)
    (let ((x rest: args) form)
      (if (= x '%do) (lower-do args hoist stmt? tail?)
          (= x '%call) (lower args hoist stmt? tail?)
          (= x '%set) (lower-set args hoist stmt? tail?)
          (= x '%if) (lower-if args hoist stmt? tail?)
          (= x '%try) (lower-try args hoist tail?)
          (= x '%while) (lower-while args hoist)
          (= x '%for) (lower-for args hoist)
          (= x '%function) (lower-function args)
          (or (= x '%local-function)
              (= x '%global-function))
          (lower-definition x args hoist stmt? tail?)
          (in? x '(and or))
          (lower-short x args hoist)
          (statement? x) (lower-special form hoist)
        (lower-call form hoist)))))

(define-global expand (form)
  (lower (macroexpand form)))

(target js: (define run (%literal "eval")))

(target lua: (define load1 (or (get _G 'loadstring) (get _G 'load))))
(target lua:
  (define run (code)
    (let ((f e) (list (load1 code)))
      (if f (f) (error (cat e " in " code))))))

(define-global %result)

(define-global eval (form)
  (let previous target*
    (set target* (language))
    (let code (compile (expand `(set %result ,form)))
      (set target* previous)
      (run code)
      %result)))

(define-global immediate-call? (x)
  (and (obj? x) (obj? (hd x)) (= (hd (hd x)) '%function)))

(define-special %do forms stmt: true tr: true
  (with s ""
    (step x forms
      (when (and (= target* 'lua)
                 (immediate-call? x)
                 (= "\n" (char s (edge s))))
        (set s (cat (clip s 0 (edge s)) ";\n")))
      (cat! s (compile x stmt: true))
      (unless (atom? x)
        (if (or (= (hd x) 'return)
                (= (hd x) 'break))
            (break))))))

(define-special %if (cond cons alt) stmt: true tr: true
  (let (cond (compile cond)
        cons (with-indent (compile cons stmt: true))
        alt (if alt (with-indent (compile alt stmt: true)))
        ind (indentation)
        s "")
    (if (= target* 'js)
        (cat! s ind "if (" cond ") {\n" cons ind "}")
      (cat! s ind "if " cond " then\n" cons))
    (if (and alt (= target* 'js))
        (cat! s " else {\n" alt ind "}")
        alt (cat! s ind "else\n" alt))
    (if (= target* 'lua)
        (cat s ind "end\n")
      (cat s "\n"))))

(define-special %while (cond form) stmt: true tr: true
  (let (cond (compile cond)
        body (with-indent (compile form stmt: true))
        ind (indentation))
    (if (= target* 'js)
        (cat ind "while (" cond ") {\n" body ind "}\n")
      (cat ind "while " cond " do\n" body ind "end\n"))))

(define-special %names args
  (if (one? args) (compile (hd args))
    (let (s (if (= target* 'js) "[" "") c "")
      (step x args
        (cat! s c (compile x))
        (set c ", "))
      (cat s (if (= target* 'js) "]" "")))))

(define-special %for (t k form await: await?) stmt: true tr: true
  (let (t (compile t)
        k (compile k)
        ind (indentation)
        body (with-indent (compile form stmt: true))
        a (if await? "await " ""))
    (if (= target* 'lua)
        (cat ind "for " k " in " t " do\n" body ind "end\n")
      (cat ind "for " a "(" k " of " t ") {\n" body ind "}\n"))))

(define-special %try (form) stmt: true tr: true
  (let-unique (e)
    (let (ind (indentation)
          body (with-indent (compile form stmt: true))
          hf `(return (%array false ,e))
          h (with-indent (compile hf stmt: true)))
      (cat ind "try {\n" body ind "}\n"
           ind "catch (" e ") {\n" h ind "}\n"))))

(define-special %delete (place) stmt: true
  (cat (indentation) "delete " (compile place)))

(define-special break () stmt: true
  (cat (indentation) "break"))

(define-special %function (args rest: body)
  (apply compile-function args body))

(define-special %global-function (name args rest: body) stmt: true tr: true
  (if (= target* 'lua)
      (let x (apply compile-function args body name: name global: true)
        (cat (indentation) x))
    (compile `(%set ,name (%function ,args ,@body)) stmt: true)))

(define-special %local-function (name args rest: body) stmt: true tr: true
  (if (= target* 'lua)
      (let x (apply compile-function args body name: name prefix: 'local)
        (cat (indentation) x))
    (compile `(%local ,name (%function ,args ,@body)) stmt: true)))

(define-special return (x) stmt: true
  (let x (if (nil? x)
             "return"
           (cat "return " (compile x)))
    (cat (indentation) x)))

(define-special new (x)
  (cat "new " (compile x)))

(define-special typeof (x)
  (cat "typeof(" (compile x) ")"))

(define-special throw (x) stmt: true
  (let e (if (= target* 'js)
             (cat "throw " (compile x))
           (cat "error(" (compile x) ")"))
    (cat (indentation) e)))

(define-special %local (name value) stmt: true
  (let (id (compile name)
        value1 (compile value)
        rh (if (is? value) (cat " = " value1) "")
        keyword (if (= target* 'js) "var " "local ")
        ind (indentation))
    (cat ind keyword id rh)))

(define-special %set (lh rh) stmt: true
  (let (lh (compile lh)
        rh (compile (if (nil? rh) 'nil rh)))
    (cat (indentation) lh " = " rh)))

(define-special get (t k)
  (let (t1 (compile t)
        k1 (compile k escape-reserved: false))
    (when (or (and (= target* 'lua)
                   (= (char t1 0) "{"))
              (infix-operator? t))
      (set t1 (cat "(" t1 ")")))
    (if (and (string-literal? k)
             (valid-id? (inner k)))
        (cat t1 "." (inner k))
      (cat t1 "[" k1 "]"))))

(define-special %array forms
  (let (open (if (= target* 'lua) "{" "[")
        close (if (= target* 'lua) "}" "]")
        s "" c "")
    (each (k v) forms
      (when (number? k)
        (cat! s c (compile v))
        (set c ", ")))
    (cat open s close)))

(define-special %object forms
  (let (s "{" c ""
        sep (if (= target* 'lua) " = " ": "))
    (each (k v) (pair forms)
      (when (number? k)
        (let ((k v) v)
          (cat! s c (key k) sep (compile v))
          (set c ", "))))
    (cat s "}")))

(define-special %literal args
  (apply cat (map unquoted args)))

(define-special unpack (x)
  (if (= target* 'lua)
      (cat "(unpack or table.unpack)(" (compile x) ")")
    (cat "..." (compile x))))

(export run
        eval
        expand
        compile)
