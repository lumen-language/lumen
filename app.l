(during-compilation
  (load "lib.l")
  (load "html.l")
  (load "srv.l"))

(init
  hpwfile*   "arc/hpw"
  oidfile*   "arc/openids"
  adminfile* "arc/admins"
  cookfile*  "arc/cooks")

(def asv (port)
  (set port (or port 8080))
  (load-userinfo)
  ; (serve port))
  )

(def load-userinfo ()
  (set hpasswords*   (safe-load-table hpwfile*)
       openids*      (safe-load-table oidfile*)
       admins*       (or (errsafe (readfile adminfile*)) ())
       cookie->user* (safe-load-table cookfile*))
  (each (k v) cookie->user*
    (set (get user->cookie* v) k)))

; idea: a bidirectional table, so don't need two vars (and sets)

(init cookie->user* (obj) user->cookie* (obj) logins* (obj))

(def get-cookie (req res k)
  (let p (listtab (map (fn (x) (split x "=")) (split (req .headers .cookie) "; ")))
    (if k (get p k) p)))

(def set-cookie (req res k v)
  ((res .cookie) k v))

(def cookie (req res k)
  (let-when c (get-cookie req res k)
    (or (get cookie->user* c)
        (do (set-cookie req res "user" "") nil))))

(def get-user (req res)
  (let-when u (cookie req res "user")
    (set (get logins* u) (get req 'ip))
    u))

(mac when-umatch (user req rest: body)
  `(if (= ,user (get-user ,req))
       (do ,@body)
       (mismatch-message)))

(def mismatch-message () 
  "Dead link: users don't match.")

(mac when-umatch/r (user req rest: body)
  `(if (= ,user (get-user ,req))
       (do ,@body)
     "mismatch"))

(defop mismatch (req res) (mismatch-message))

(mac uform (user req after rest: body)
  `(aform (fn (,req)
            (when-umatch ,user ,req
              ,after))
     ,@body))

(mac urform (user req after rest: body)
  `(arform (fn (,req)
             (when-umatch/r ,user ,req 
               ,after))
     ,@body))

; Like onlink, but checks that user submitting the request is the
; same it was generated for.  For extra protection could log the 
; username and ip addr of every genlink, and check if they match.

(mac ulink (user text rest: body)  
  (let-unique (req)
    `(linkf ,text (,req) 
       (when-umatch ,user ,req ,@body))))


(defop admin (req res) (admin-gate (get-user req res)))

(def admin-gate (u)
  (if (admin u)
      (admin-page u)
      (login-page 'login nil
                  (fn (u ip)  (admin-gate u)))))

(def admin (u) (and u (mem u admins*)))

(def user-exists (u) (and u (get hpasswords* u) u))

(def admin-page (user rest: msg)
  (whitepage 
    (<b> "Admin: ")
    (hspace 20)
    user " | "
    (w/link (do (logout-user user)
                (whitepage (<span> "Bye " user ".")))
      "logout")
    (unpack (accum a (when msg (a (hspace 10)) (map a msg))))
    (br2)
    (aform (fn (req)
             (when-umatch user req
               (let (u (arg req "u") p (arg req "p"))
                 (if (or (no u) (no p) (= u "") (= p ""))
                      "Bad data."
                     (user-exists u)
                      (admin-page user "User already exists: " u)
                      (do (create-acct u p)
                          (admin-page user))))))
      (pwfields "create (server) account"))))

(def cook-user (req res user)
  (logout-user user)
  (let id (new-user-cookie)
    (set (get cookie->user*   id) user
         (get user->cookie* user) id)
    (save-table cookie->user* cookfile*)
    (set-cookie req res "user" id)
    id))

; Unique-ids are only unique per server invocation.

(def new-user-cookie ()
  (let id (unique-id)
    (if (get cookie->user* id) (new-user-cookie) id)))

(def logout-user (user)
  (wipe (get logins* user))
  (wipe (get cookie->user* (get user->cookie* user)))
  (wipe (get user->cookie* user))
  (save-table cookie->user* cookfile*))

(def downcase (s)
  (target lua: (tostring ((ustring .lower) ((ustring .new) s)))
          js: (s (.to-locale-lower-case))))

(def create-acct (user pw)
  (set (get dc-usernames* (downcase user)) true)
  (set-pw user pw))

(def disable-acct (user)
  (set-pw user (rand-string 20))
  (logout-user user))
  
(def set-pw (user pw)
  (set (get hpasswords* user) (and pw (bcrypt pw)))
  (save-table hpasswords* hpwfile*))

(def bcrypt (str hash)
  (if (string? hash)
      ((_G .bcryptpw .checkpw) str (inner hash))
    (cat "|" ((_G .bcryptpw .hashpw) str) "|")))

(init dc-usernames* (obj))

(def username-taken (user)
  (when (empty? dc-usernames*)
    (load-userinfo)
    (each (k v) hpasswords*
      (set (get dc-usernames* (downcase k)) true)))
  (get dc-usernames* (downcase user)))

(def bad-newacct (user pw)
  (if (username-taken user)
      "That username is taken. Please choose another."
      (or (no pw) (< (# pw) 4))
      "Passwords should be at least 4 characters long.  Please choose another."))

(def alphadig (c)
  (or (and (>= c "a") (<= c "z"))
      (and (>= c "A") (<= c "Z"))
      (and (>= c "0") (<= c "9"))))

(def goodname (str min max)
  (init min 1 max nil)
  (and (string? str)
       (>= (# str) min)
       (no (find (fn (c) (no (or (alphadig c) (in c "-" "_"))))
              str))
       (not (= (char str 0) "-"))
       (or (no max) (<= (# str) max))
       str))

(def hello-page (user ip)
  (whitepage (<span> "hello " user " at " ip)))

(defop login (req res) (login-page 'login))


; switch is one of: register, login, both

; afterward is either a function on the newly created username and
; ip address, in which case it is called to generate the next page 
; after a successful login, or a pair of (function url), which means 
; call the function, then redirect to the url.

; classic example of something that should just "return" a val
; via a continuation rather than going to a new page.

(def login-page (switch msg afterward)
  (init msg nil
        afterward hello-page)
  (whitepage
    (pagemessage msg)
    (w/span a
      (when (in switch 'login 'both)
        (a (login-form "Login" switch login-handler afterward))
        (hook 'login-form afterward)
        (a (br2)))
      (when (in switch 'register 'both)
        (a (login-form "Create Account" switch create-handler afterward))))))

(def login-form (label switch handler afterward)
  (<span>
    (prbold label)
    (br2)
    (fnform (fn (req res) (handler req res switch afterward))
            (fn () (pwfields (downcase label)))
            (obj? afterward))))

(def login-handler (req res switch afterward)
  (logout-user (get-user req res))
  (aif (good-login req res (arg req "u") (arg req "p") (get req 'ip))
       (login req res it (get req 'ip) (get user->cookie* it) afterward)
       (failed-login switch "Bad login." afterward)))

(def create-handler (req res switch afterward)
  (logout-user (get-user req res))
  (let (user (arg req "u") pw (arg req "p"))
    (aif (bad-newacct user pw)
         (failed-login switch it afterward)
         (do (create-acct user pw)
             (login req res user (get req 'ip) (cook-user req res user) afterward)))))

(def login (req res user ip cookie afterward)
  (set (get logins* user) ip)
  (if (obj? afterward)
      (let ((f url) afterward)
        (f req res user ip)
        url)
      (afterward user ip)))

(def failed-login (switch msg afterward)
  (if (obj? afterward)
      (flink (fn ignore (login-page switch msg afterward)))
    (login-page switch msg afterward)))

(def prcookie (cook)
  ; (cat "Set-Cookie: user=" cook "; expires=Sun, 17-Jan-2038 19:14:07 GMT"))
  (cat "user=" cook "; expires=Sun, 17-Jan-2038 19:14:07 GMT"))

(def pwfields (label)
  (init label "login")
  (<span>
    (inputs u username 20 nil
            p password 20 nil)
    (br)
    (submit label)))

(init good-logins* (queue) bad-logins* (queue))

(def good-login (req res user pw ip)
  ; (error (pp-to-string (list 'good-login user pw ip (get hpasswords* user) (bcrypt pw (get hpasswords* user)))))
  (let record (list (seconds) ip user)
    (if (and user pw (bcrypt pw (get hpasswords* user)))
        (do ;(unless (get user->cookie* user)
              (cook-user req res user)
            (print (str! '(enq-limit record good-logins*)))
            user)
        (do (print (str! '(enq-limit record bad-logins*)))
            nil))))



(defop logout (req res)
  (aif (get-user req res)
       (do (logout-user it)
           "Logged out.")
      "You were not logged in."))

; (def prs (...)
;   (<span> ...))

(defop whoami (req res)
  (aif (get-user req res)
       ; (prs it 'at (get req 'ip) (str! req))
       ; (prs it 'at (get req 'ip) (req .headers .cookie))
       (<span> it " " 'at " " (get req 'ip))
       (<span> "You are not logged in."
            (w/link (login-page 'both) "Log in")
            ".")))

(defop optimes (req res)
  (tab
    (tr (td "op") (tdr "avg") (tdr "med") (tdr "req") (tdr "total"))
    (spacerow 10)
    (accum a
      (each (name q) optimes*
        (let (ms ((only avg) q)
              n (get opcounts* name))
          (a (tr (td name)
                 (tdr ((only round) ms))
                 (tdr ((only med) q))
                 (tdr n)
                 (tdr (and n (round (/ (* n ms) 1000)))))))))))

(init formwid* 60 bigformwid* 80 numwid* 16 formatdoc-url* nil)

; Eventually figure out a way to separate type name from format of 
; input field, instead of having e.g. toks and bigtoks

(def varfield (typ id val)
  (print (str! `(varfield ,typ ,id ,val)))
  (if (in typ 'string 'string1 'url)
       (<input> type: 'text name: id value: val size: formwid*)
      (in typ 'num 'int 'posint 'sym)
       (<input> type: 'text name: id value: val size: numwid*)
      (in typ 'users 'toks)
       (<input> type: 'text name: id value: (apply prs val) size: formwid*)
      (= typ 'sexpr)
       (<input> type: 'text name: id 
                     value: val ;(tostring (map [do (write _) (sp)] val))
                     size: formwid*)
      (in typ 'syms 'text 'doc 'mdtext 'mdtext2 'lines 'bigtoks)
       (let text (if (in typ 'syms 'bigtoks)
                      (apply prs val) ; (tostring (apply prs val))
                     (= typ 'lines)
                      (apply prs val) ;(tostring (apply pr (intersperse #\newline val)))
                     (in typ 'mdtext 'mdtext2)
                      val ;(unmarkdown val)
                     (no val)
                      ""
                     val)
         (pr
           (<textarea> cols: (if (= typ 'doc) bigformwid* formwid*)
                       rows: (needrows text formwid* 4)
                       wrap: 'virtual 
                       style: (if (= typ 'doc) (style "font-size" "8.5pt"))
                       name: id
              text)
             ; (pr (br)) ; needed or 1 initial newline gets chopped off
             ; (pr text))
           (when (and formatdoc-url* (in typ 'mdtext 'mdtext2))
             (pr " "
                 (<font> size: -2
                         (link "help" formatdoc-url* (gray 175)))))))
      (hd? typ 'choice)
       (menu id (cut typ 2) val)
      (= typ 'yesno)
       (menu id (list "yes" "no") (if val "yes" "no"))
      (= typ 'hexcol)
       (<input> type: 'text name: id value: val)
      (= typ 'time)
       (<input> type: 'text name: id value: (if val (english-time val) ""))
      (= typ 'date)
       (<input> type: 'text name: id value: (if val (english-date val) ""))
       (error (cat "unknown varfield type" (str! typ)))))

(def text-rows (text wid pad)
  (init pad 3)
  (+ (trunc (/ (# text) (* wid .8))) pad))

(def needrows (text cols pad)
  (init pad 0)
  (+ pad (max (+ 1 (count "\n" text))
              (roundup (/ (# text) (- cols 5))))))

(def varline (typ id val liveurls)
  (if (in typ 'users 'syms 'toks 'bigtoks)  (apply prs val)
      (=  typ 'lines)                       (pr (unpack (map prn val)))
      (=  typ 'yesno)                       (pr (if val 'yes 'no))
      (hd? typ 'choice)                     (varline (at typ 1) nil val)
      (=  typ 'url)                         (if (and liveurls (valid-url val))
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

(def carif (x)
  (if (obj? x) (hd x) x))

(def striptags (str) str)
(def blank (str) (none? (trim str)))

(def valid-url (str) true)
(def clean-url (str) str)

(def md-from-form (str) str)

(def tokens (str) str)

(def lines (str)
  (split str "\n"))

(def readvar (typ str fail)
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
    sym     (or ((compose sym car tokens) str) fail)
    syms    (map sym (tokens str))
    sexpr   (errsafe (readall str))
    users   (rem (fn (_) (no (goodname _))) (tokens str))
    toks    (tokens str)
    bigtoks (tokens str)
    lines   (lines str)
    choice  (readvar (at typ 1) str)
    yesno   (= str "yes")
    hexcol  (if (hex>color str) str fail)
    time    (or (errsafe (parse-time str)) fail)
    date    (or (errsafe (parse-date str)) fail)
            (error (cat "unknown readvar type " (str! typ)))))

; dates should be tagged date, and just redefine <

(def varcompare (typ)
  (if (in typ 'syms 'sexpr 'users 'toks 'bigtoks 'lines 'hexcol)
       (fn (x y) (> (# x) (# y)))
      (= typ 'date)
       (fn (x y)
         (or (no y) (and x (date< x y))))
       (fn (x y)
         (or (empty? y) (and (not (empty? x)) (< x y))))))


; (= fail* (uniq))

(def fail* ()) ; coudn't possibly come back from a form
  
; ; Takes a list of fields of the form (type label value view modify) and 
; ; a fn f and generates a form such that when submitted (f label newval) 
; ; will be called for each valid value.  Finally done is called.

(def vars-form (user fields f done button lasts)
  (init button "update")
  (taform lasts
          ; (if (all (fn (_) (no (at _ 4))) fields)
          ;     (fn (req res))
              (fn (req res)
                (when-umatch user req
                  (each (k v) (get req 'body)
                    (print (str (list k v fields user (get req 'body))))
                    (let name k
                      (awhen (first (fn (_) (= (at _ 1) name)) fields)
                        ; added sho to fix bug
                        (let ((typ id val sho mod) (at fields it))
                          (when (and mod v)
                            (let newval (readvar typ v fail*)
                              (unless (= newval fail*)
                                (f name newval))))))))
                  (done)))
     (tab (showvars fields))
     (unless (all (fn (_) (no (at _ 4))) fields)  ; no modifiable fields
       (pr (br) (submit button)))))
                
(def showvars (fields liveurls)
  (accum a
    (step (typ id val view mod question) fields
      (when view
        (when question
          (a (tr (td question))))
        (a (tr (unless question (<td> valign: 'top (pr id ":")))
               (td (if mod
                       (varfield typ id val)
                       (varline  typ id val liveurls)))))))))

