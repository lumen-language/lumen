(when-compiling
  (set expand-atom-functions* (list expand-compose expand-ref expand-and))
  nil)
  
(during-compilation
(define-macro def args
  `(during-compilation
     (define-global ,@args)))

(define-macro mac args
  `(during-compilation
     (define-macro ,@args)))

(define-macro is args `(== ,@args))
(define-macro table args `(obj ,@args))

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


)

(during-compilation


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

(define-macro accum (accfn rest: body)
  (w/uniq gacc
    `(let (,gacc nil ,accfn [push _ ,gacc])
       ,@body
       (rev ,gacc))))
)


(during-compilation

(define-global shell (x)
  (((require 'system) .run) x))

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
  (target lua: (+ (* (seconds) 1000)
                  (% (/ ((uv .hrtime)) 1000000) 1000))
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
  (let (cache (table) nilcache (table))
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
   #\. "."
   #\, ","
   #\; ";"
   #\: ":"
   #\! "!"
   #\? "?")
)

(during-compilation

(define-global empty (x)
  (or (nil? x)
      (and (obj? x) (empty? x))
      (and (string? x) (none? x))))

(define-global no? (x) (or (== x false) (empty x)))
(define-global yes? (x) (not (no? x)))

(define-global acons (x) 
  (and (obj? x) (not (empty? x))))

(define-global atom (x)
  (~acons x))

(define-global expt (n k) (pow n k))
(define-global rand (...) (random ...))

(define-global cons (a b) (if (nil? b) (list a) (obj? b) `(,a ,@b) `(,a rest: ,b)))
(define-global car (x) (if (nil? x) x (hd x)))
(define-global cdr (x) (if (nil? x) x (tl x)))
(define-global caar (x) (car (car x)))
(define-global cadr (x) (car (cdr x)))
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

(define-global in (x ...)
  (in? x (list ...)))

(define-global keys (h)
  (if (function? h)
      (keys (h))
    (with l ()
      (each (k v) h
        (unless (number? k)
          (add l k))))))

(define-global idfn (x) x)
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

(define-global only (f)
  (fn (x ...) (unless (== x nil) (f x ...))))

(define-macro conswhen (f x y)
  (w/uniq (gf gx)
   `(let (,gf ,f ,gx ,x)
      (if (,gf ,gx) (cons ,gx ,y) ,y))))

; Could combine with firstn if put f arg last, default to (fn (x) t).

(define-global retrieve (n f xs)
  (if (no? n)                (keep f xs)
      (or (<= n 0) (no? xs)) nil
      (f (car xs))           (cons (car xs) (retrieve (- n 1) f (cdr xs)))
                             (retrieve n f (cdr xs))))
(define-global dedup (xs)
  (let (h (table) acc nil)
    (each x xs
      (unless (get h x)
        (push x acc)
        (set (get h x) true)))
    (rev acc)))

(define-global single (x) (and (acons x) (no (cdr x))))

(define-global intersperse (x ys)
  (and ys (cons (car ys)
                (mappend [list x _] (cdr ys)))))

(define-global counts (seq (o c (table)))
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

(define-global some (f x)
  (unless (nil? x)
    (find f x)))

(define-global all (test seq)
  (~some (complement (testify test)) seq))

(define-global mem (f x (o test is))
  (unless (nil? x)
    (first [test f _] x)))

(define-global rem (f x)
  (unless (nil? x)
    (let i (first f x)
      (if (number? i)
          (join (cut x 0 i) (rem f (cut x (+ i 1))))
        x))))

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

(define-global pr (x ...)
  (((require 'system) .write) (apply cat (map tostring (list x ...))))
  x)

(define-global prn (x ...)
  (pr x ...) (pr "\n")
  x)

(define-global flushout ()
  (do))

(define-global firstn (n xs)
  (if (nil? xs) xs (cut xs 0 n)))

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
  name)

)

(during-compilation

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
  `(fromdisk ,var ,file (table) load-table save-table))

(define-macro todisk (var (o expr var))
  `((savers* ',var) 
    ,(if (is var expr) `(,var) `(= (,var) ,expr))))

(define-macro evtil (expr test)
  (w/uniq gv
    `(let ,gv ,expr
       (while (no (,test ,gv))
         (= ,gv ,expr))
       ,gv)))


(define-macro time (expr)
  (w/uniq (t1 t2)
    `(let ,t1 (msec)
       (do1 ,expr
            (let ,t2 (msec)
              (prn "time: " (- ,t2 ,t1) " msec."))))))

(define-macro jtime (expr)
  `(do1 'ok (time ,expr)))

(define-macro time10 (expr)
  `(time (repeat 10 ,expr)))


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


(def asv (port)
  port)
)

(define-global family (i)
  `(,i ,@(mappend family:items* i!kids)))

; (define-global item (id)
;   (or (items* id)
;       (set (items* id) (obj id: id))))

; (define-global new-item-id ()
;   (+ (apply max (map !id (items*))) 1))


; News.  2 Sep 06.

; to run news: (nsv), then go to http://localhost:8080
; put usernames of admins, separated by whitespace, in arc/admins

; bug: somehow (+ votedir* nil) is getting evaluated.

; (declare 'atstrings t)

(= this-site*    "My Forum"
   site-url*     "http://news.yourdomain.com/"
   parent-url*   "http://www.yourdomain.com"
   favicon-url*  ""
   site-desc*    "What this site is about."               ; for rss feed
   ; site-color*   (color 180 180 180)
   ; border-color* (color 180 180 180)
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

(defvar vote* (table))
(defvar prof* (table))
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
  (= (vote* u) (load-table (cat votedir* u))
     (prof* u) (temload 'profile (cat profdir* u)))
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
            (= (vote* u) (load-table it)))))
          
(def init-user (u)
  (= (vote* u) (table) 
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
(defvar items* (table))
(defvar url->story* (table))
(= maxid* 0)
(defvar initload* 15000)

; (define-global quote-table ((k v))
;   (list (quoted k) (if (obj? v) `(list ,@(map (fn (x) `(list ,@x)) v)) v)))

(define-global arc-eval (x)
  (if (obj? x) `(list ,@(map arc-eval x))
      (string-literal? x) x
      (is x 'nil) `',null
      (atom? x) (quoted x)
    x))

(define-global load-arc-table (l)
  (with r (obj)
    (step (k v) l
      (set (get r k) (eval (arc-eval v))))))

(= arc3-dir* "/Users/bb/Documents/Share/arc3.1/arc3.1/arc/news/")

(define-global load-from-arc ((o path arc3-dir*))
  (with r (obj stories: (obj) profs: (obj))
    (let i 1
      (while (aand (cat path "story/" (tostring i))
                   (file-exists it)
                   (last (read-from-file it))
                   (load-arc-table it)
                   (set (get r!stories i) it))
        (inc i)))
    (defconst prof* (obj))
    (defconst vote* (obj))
    (step x (dir (cat path "profile/"))
      (aand (file-exists (cat path "profile/" x))
            (last (read-from-file it))
            (load-arc-table it)
            (set (get r!profs x) it)
            (set (prof* x) it)
            (set (vote* x) it!votes)
            ))
    (let (ids (sort (map !id r!stories) >)
          items (table))
      (= maxid* (car ids))
      (defconst items* (obj))
      (step id ids
        (let i (get r!stories id)
          (push i (get items i!type))
          (= (items* i!id) i)))
      (defconst stories* (rev items!story))
      (defconst comments* (rev items!comment))
      (hook 'initload items))
    ))

(define-global load-items ()
  ; (system (cat "rm " storydir* "*.tmp"))
  (print "load items: ") 
  (let (items (table)
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

(mac check (x test (o alt))
  (w/uniq gx
    `(let ,gx ,x
       (if (,test ,gx) ,gx ,alt))))

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

(defvar stemmable-sites* (table))

(define-global sitename (url)
  false)

(define-global canonical-url (url)
  (if (stemmable-sites* (sitename url))
      (cut url 0 (pos #\? url))
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

(defvar comment-cache* (table))

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

(let mature (table)
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


(def sum (f (o xs ()))
  (with n 0
    (step x xs (inc n (f x)))))

(def visible-family (user i)
  (+ (if (cansee user i) 1 0)
     (sum [visible-family user (item _)] i!kids)))



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

(defconst comment-cache* (table))
(defconst comment-cache-timeout* (table))
(defvar cc-window* 10000)

(defvar comments-printed* 0)
(defvar cc-hits* 0)

(defvar comment-caching* true)


(do)
