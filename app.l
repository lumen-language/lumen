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


