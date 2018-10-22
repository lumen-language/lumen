(def idfn (x) x)

(def addnew (l x)
  (if (nil? l) (list x)
    (unless (in? x l)
      (add l x))))

(def mappend (f l)
  (apply join (map f l)))

(def exact (x)
  (and (number? x) (= (% x 1) 0)))

(def int (x)
  (if (exact x) x
      (number? x) (trunc x)
      (and (string? x) (numeric? x)) (number x)
    (error (cat "Can't coerce " (str! x) " to int"))))

(mac afn (args rest: body)
  `(let self nil
     (set self (fn ,args ,@body))))

(def orf fns
  (fn (...)
    ((afn (fs)
       (and (some? fs)
            (or ((hd fs) ...) (self (tl fs)))))
     fns)))

(def andf fns
  (fn (...)
    ((afn (fs)
       (if (none? fs)      true
           (none? (tl fs)) ((hd fs) ...)
                           (and ((hd fs) ...)
                                (self (tl fs)))))
     fns)))

(mac nor args `(no (or ,@args))) 

(def firstn (n l)
  (cut l 0 n))

(def keys (h)
  (accum a
    (each (k v) h
      (unless (number? k)
        (a k)))))

(def file-exists (x)
  (if (((require 'system) .file-exists?) x) x))

(def dir (x)
  (split (shell (cat "ls -1 " (escape x))) "\n"))

(def color (r g b)
  (obj r: r g: g b: b))


(init this-site*    "Lambda News"
      site-url*     "http://news.ycombinator.lol"
      parent-url*   "http://www.ycombinator.lol"
      favicon-url*  ""
      site-desc*    "What this site is about."               ; for rss feed
      site-color*   (color 180 180 180)
      border-color* (color 180 180 180)
      prefer-url*   true)


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

(init newsdir*  "arc/news/"
      storydir* "arc/news/story/"
      profdir*  "arc/news/profile/"
      votedir*  "arc/news/vote/")

(init votes* (obj) profs* (obj))

(init initload-users* nil)

(def nsv (port)
  (init port 8080)
  (map ensure-dir (list arcdir* newsdir* storydir* votedir* profdir*))
  (unless stories* (load-items))
  (if (and initload-users* (empty? profs*)) (load-users))
  (asv port))

(def load-users ()
  (print "load users: ")
  (noisy-each 100 id (dir profdir*)
    (load-user id)))

; For some reason vote files occasionally get written out in a 
; broken way.  The nature of the errors (random missing or extra
; chars) suggests the bug is lower-level than anything in Arc.
; Which unfortunately means all lists written to disk are probably
; vulnerable to it, since that's all save-table does.

(def load-user (u)
  (set (get votes* u) (load-table (cat votedir* u))
       (get profs* u) (temload 'profile (cat profdir* u)))
  u)

; Have to check goodname because some user ids come from http requests.
; So this is like safe-item.  Don't need a sep fn there though.

(def profile (u)
  (or (get profs* u)
      (aand (goodname u)
            (file-exists (cat profdir* u))
            (set (get profs* u) (temload 'profile it)))))

(def votes (u)
  (or (get votes* u)
      (aand (file-exists (cat votedir* u))
            (set (get votes* u) (load-table it)))))
          
(def init-user (u)
  (set (get votes* u) (obj) 
       (get profs* u) (inst 'profile 'id u))
  (save-votes u)
  (save-prof u)
  u)



; Need this because can create users on the server (for other apps)
; without setting up places to store their state as news users.
; See the admin op in app.arc.  So all calls to login-page from the 
; news app need to call this in the after-login fn.

(def ensure-news-user (u)
  (if (profile u) u (init-user u)))

(def save-votes (u) (save-table (get votes* u) (cat votedir* u)))

(def save-prof  (u) (save-table (get profs* u) (cat profdir* u)))

(mac uvar (u k) `(get (profile ,u) ',k))

(mac karma   (u) `(uvar ,u karma))
(mac ignored (u) `(uvar ,u ignore))

; Note that users will now only consider currently loaded users.

(def users (f) 
  (let ks (keys profs*)
    (if f (keep f ks) ks)))

(def check-key (u k)
  (and u (mem k (uvar u keys))))

(def author (u i) (= u (get i 'by)))


(init stories* nil comments* nil 
      items* (obj) url->story* (obj)
      maxid* 0 initload* 15000)

; The dir expression yields stories in order of file creation time 
; (because arc infile truncates), so could just rev the list instead of
; sorting, but sort anyway.

; Note that stories* etc only include the initloaded (i.e. recent)
; ones, plus those created since this server process started.

; Could be smarter about preloading by keeping track of popular pages.

(def multiple (x y)
  (= 0 (% x y)))

(mac noisy-each (n var val rest: body)
  (let-unique (gn gc)
    `(let (,gn ,n ,gc 0)
       (step ,var ,val
         (when (multiple (inc ,gc) ,gn)
           (((require 'system) .write) ".")
           ; (flushout)
           )
         ,@body)
       (print)
       ; (flushout)
       )))


(def load-items ()
  (errsafe (shell (cat "rm " storydir* "*.tmp")))
  (print "load items: ")
  (let (items (obj)
        ids   (sort (map int (dir storydir*)) >))
    (if ids (set maxid* (hd ids)))
    (noisy-each 100 id (firstn initload* ids)
      (let i (load-item id)
        (init (get items (get i 'type)) ())
        (add (get items (get i 'type)) i)))
    (set stories*  (get items 'story)  ;(rev (merge (compare < !id) (get items 'story) (get items 'poll)))
         comments* (get items 'comment))
    (hook 'initload items))
  (ensure-topstories))

(def ensure-topstories ()
  ; (aif (errsafe (readfile1 (cat newsdir* "topstories")))
  ;      (set ranked-stories* (map item it))
  ;      (do (prn "ranking stories.") 
  ;          (flushout)
  ;          (gen-topstories))))
  nil)

(def astory   (i) (= (get i 'type) 'story))
(def acomment (i) (= (get i 'type) 'comment))
(def apoll    (i) (= (get i 'type) 'poll))

(def load-item (id)
  (let i (temload 'item (str! storydir* id))
    (set (get items* id) i)
    (awhen (and ((andf astory live) i) (check (get i 'url) (complement blank)))
      (register-url i it))
    i))







(def new-item-id ()
  (while true
    (let i (inc maxid*)
      (unless (file-exists (str! storydir* i))
        (return i)))))

(def item (id)
  (or (get items* id) ((compose errsafe load-item) id)))

(def kids (i) (map item i!kids))

; For use on external item references (from urls).  Checks id is int 
; because people try e.g. item?id=363/blank.php

(def safe-item (id)
  ((andf ok-id item) (if (string? id) (saferead id) id)))

(def ok-id (id)
  (and (exact id) (<= 1 id maxid*)))

(def arg->item (req key)
  ((compose safe-item saferead) (arg req key)))

(def live (i) (nor (get i 'dead) (get i 'deleted)))

(def save-item (i) (save-table i (str! storydir* (get i 'id))))

(def kill (i how)
  (unless (get i 'dead)
    (log-kill i how)
    (wipe (comment-cache* (get i 'id)))
    (set (get i 'dead))
    (save-item i)))

(set kill-log* nil)

(def log-kill (i how)
  (push (list (get i 'id) how) kill-log*))

(mac each-loaded-item (var rest: body)
  (let-unique (g)
    `(let ,g nil
       (loop (set ,g maxid*) (> ,g 0) (-- ,g)
         (whenlet ,var (items* ,g)
           ,@body)))))



(def loaded-items (test)
  (accum a (each-loaded-item i ((andf test a) i))))

(def newslog (...) (srvlog 'news ...))



; Page Layout

(set up-url* "grayarrow.gif" down-url* "graydown.gif" logo-url* "arc.png")

(defopr favicon.ico req favicon-url*)

; redefined later

(def gen-css-url ()
  ; (prn "<link rel=\"stylesheet\" type=\"text/css\" href=\"news.css\">"))
  (<link> rel: 'stylesheet type: "text/css" href: "news.css"))

(mac npage (title rest: body)
  `(<html> 
     (<head> 
       (gen-css-url)
       (<link> rel: "shortcut icon" href: favicon-url*)
       (<script> src: "vote.js")
       (<title> ,title))
     (<body> 
       (center
         (<table> style: (obj background-color: (hexrep sand)
                              border: 0
                              cellpadding: 0
                              cellspacing: 0
                              width: "85%")
          (<tbody>
             ,@body))))))

(set pagefns* nil)

(def check-procrast (x) t)

(def procrast-msg (u w)
  "Get back to work!")

(mac fulltop (user lid label title whence rest: body)
  (let-unique (gu gi gl gt gw)
    `(let (,gu ,user ,gi ,lid ,gl ,label ,gt ,title ,gw ,whence)
       (npage (cat this-site* (if ,gt (cat bar* ,gt) ""))
         (if (check-procrast ,gu)
             (pr (pagetop 'full ,gi ,gl ,gt ,gu ,gw)
                 (hook 'page ,gu ,gl)
                 ,@body)
             (row (procrast-msg ,gu ,gw)))))))

(mac longpage (user t1 lid label title whence rest: body)
  (let-unique (gu gt gi)
    `(let (,gu ,user ,gt ,t1 ,gi ,lid)
       (fulltop ,gu ,gi ,label ,title ,whence
         (trtd ,@body)
         (trtd (vspace 10)
               (color-stripe (main-color ,gu))
               (br)
               (center
                 (hook 'longfoot)
                 (admin-bar ,gu (- (msec) ,gt) ,whence)))))))

(def memory () 0) ;todo

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
  (tab width: "100%" cellspacing: 0 cellpadding: 1
    (tr (tdcolor c))))

(mac shortpage (user lid label title whence rest: body)
  `(fulltop ,user ,lid ,label ,title ,whence 
     (trtd ,@body)))

(mac minipage (label rest: body)
  `(npage (cat this-site* bar* ,label)
     (pagetop nil nil ,label)
     (trtd ,@body)))

(def msgpage (user msg title)
  (minipage (or title "Message")
    (spanclass admin
      (center (if (len> msg 80) 
                  (widtable 500 msg)
                  (pr msg))))
    (br2)))

(set (get max-age* 'news.css) 86400)   ; cache css in browser for 1 day

; turn off server caching via (= caching* 0) or won't see changes

(defop news.css (req res)
  "
body  { font-family:Verdana; font-size:10pt; color:#828282; }
td    { font-family:Verdana; font-size:10pt; color:#828282; }

.admin td   { font-family:Verdana; font-size:8.5pt; color:#000000; }
.subtext td { font-family:Verdana; font-size:  7pt; color:#828282; }

input    { font-family:Courier; font-size:10pt; color:#000000; }
input[type=\"submit\"] { font-family:Verdana; }
textarea { font-family:Courier; font-size:10pt; color:#000000; }

a:link    { color:#000000; text-decoration:none; } 
a:visited { color:#828282; text-decoration:none; }

.default { font-family:Verdana; font-size: 10pt; color:#828282; }
.admin   { font-family:Verdana; font-size:8.5pt; color:#000000; }
.title   { font-family:Verdana; font-size: 10pt; color:#828282; }
.adtitle { font-family:Verdana; font-size:  9pt; color:#828282; }
.subtext { font-family:Verdana; font-size:  7pt; color:#828282; }
.yclinks { font-family:Verdana; font-size:  8pt; color:#828282; }
.pagetop { font-family:Verdana; font-size: 10pt; color:#222222; }
.comhead { font-family:Verdana; font-size:  8pt; color:#828282; }
.comment { font-family:Verdana; font-size:  9pt; }
.dead    { font-family:Verdana; font-size:  9pt; color:#dddddd; }

.comment a:link, .comment a:visited { text-decoration:underline;}
.dead a:link, .dead a:visited { color:#dddddd; }
.pagetop a:visited { color:#000000;}
.topsel a:link, .topsel a:visited { color:#ffffff; }

.subtext a:link, .subtext a:visited { color:#828282; }
.subtext a:hover { text-decoration:underline; }

.comhead a:link, .subtext a:visited { color:#828282; }
.comhead a:hover { text-decoration:underline; }

.default p { margin-top: 8px; margin-bottom: 0px; }

.pagebreak {page-break-before:always}

pre { overflow: auto; padding: 2px; max-width:600px; }
pre:hover {overflow:auto} ")

; only need pre padding because of a bug in Mac Firefox

; Without setting the bottom margin of p tags to 0, 1- and n-para comments
; have different space at the bottom.  This solution suggested by Devin.
; Really am using p tags wrong (as separators rather than wrappers) and the
; correct thing to do would be to wrap each para in <p></p>.  Then whatever
; I set the bottom spacing to, it would be the same no matter how many paras
; in a comment. In this case by setting the bottom spacing of p to 0, I'm
; making it the same as no p, which is what the first para has.

; supplied by pb
;.vote { padding-left:2px; vertical-align:top; }
;.comment { margin-top:1ex; margin-bottom:1ex; color:black; }
;.vote IMG { border:0; margin: 3px 2px 3px 2px; }
;.reply { font-size:smaller; text-decoration:underline !important; }

(defop vote.js (req res)
  "
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


; Page top

(set sand (color 246 246 239) textgray (color 130 130 130))

(def main-color (user) 
  (aif (and user (uvar user topcolor))
       (hex>color it)
       site-color*))

(def hexc (n)
  (with x (n (.to-string 16))
    (while (< (# x) 2)
      (set x (cat "0" x)))))

(def hexrep ((r: r g: g b: b))
  (cat "#" (hexc r) (hexc g) (hexc b)))

(def pagetop (switch lid label title user whence)
; (tr (tdcolor black (vspace 5)))
  (accum a
    (a (tr (tdcolor (main-color user)
           (tab border: 0 cellpadding: 0 cellspacing: 0 width: "100%"
                style: (obj padding: "2px")
             (tr (gen-logo)
                 (when (= switch 'full)
                   (<td> style: (obj line-height: "12pt" height: "10px")
                     (spanclass pagetop
                       (<b> (link this-site* "news"))
                       (hspace 10)
                       (toprow user label))))
                (if (= switch 'full)
                    (<td> style: (obj text-align: "right" padding-right: "4px")
                      (spanclass pagetop (topright user whence)))
                    (<td> style: (obj line-height: "12pt" height: "10px")
                      (spanclass pagetop (prbold label)))))))))
    (if (obj? pagefns*) (map (fn (_) (a (_ user))) pagefns*))
    (a (spacerow 10))))

(def gen-logo ()
  (<td> style: (obj width: "18px" padding-right: "4px")
    (<a> href: parent-url*
      (<img> src: logo-url* width: 18 height: 18 
             style: (obj border: (cat "1px #" (hexrep border-color*) " solid"))))))

(set toplabels* (list null "welcome" "new" "threads" "comments" "leaders" "*"))

; redefined later

(set welcome-url* "welcome")

(mac w/bars body
  `(pr ,@(accum a
           (for i (# body)
             (when (at body i)
               (when (> i 0) (a '" | "))
               (a (at body i)))))))

(def toprow (user label)
  (w/bars 
    (when (noob user)
      (toplink "welcome" welcome-url* label)) 
    (toplink "new" "newest" label)
    ; (when user
    ;   (toplink "threads" (threads-url user) label))
    (toplink "comments" "newcomments" label)
    (toplink "leaders"  "leaders"     label)
    (hook 'toprow user label)
    (link "submit")
    ;(unless (mem label toplabels*)
      (fontcolor white label))
      ;))
      )

(def toplink (name dest label)
  (tag-if (= name label) (span class: 'topsel)
    (link name dest)))

(def topright (user whence showkarma)
  (init showkarma true)
  (accum a
    (when user 
      (a (userlink user user nil))
      (when showkarma (a (pr " (" (karma user) ")")))
      (a " | "))
    (if user
        (rlinkf 'logout (req)
          (when-umatch/r user req
            (logout-user user)
            whence))
        (a (onlink "login"
          (login-page 'both nil 
                      (list (fn (u ip) 
                              (ensure-news-user u)
                              (newslog ip u 'top-login))
                            whence)))))))

(def noob (user)
  ; (and user (< (days-since (uvar user created)) 1)))
  false)


(def userlink (user subject show-avg)
  (init show-avg true)
  ; (link (user-name user subject) (user-url subject))
  ; (awhen (and show-avg* (admin user) show-avg (uvar subject avg))
  ;   (pr " (@(num it 1 t t))")))
  )



; News-Specific Defop Variants

(mac defopt (name parm test msg rest: body)
  `(defop ,name ,parm
     (if (,test (get-user ,@parm))
         (do ,@body)
         (login-page 'both (cat "Please log in" ,msg ".")
                     (list (fn (u ip) (ensure-news-user u))
                           (str! ',name (reassemble-args ,parm)))))))

(mac defopg (name parm rest: body)
  `(defopt ,name ,parm idfn "" ,@body))

(mac defope (name parm rest: body)
  `(defopt ,name ,parm editor " as an editor" ,@body))

(mac defopa (name parm rest: body)
  `(defopt ,name ,parm admin " as an administrator" ,@body))

(mac opexpand (definer name parms rest: body)
  (print (str! `(opexpand ,definer ,name ,parms ,@body)))
  (let-unique (gr ge)
    `(,definer ,name (,gr ,ge)
       (let (user (get-user ,gr ,ge) ip (get ,gr 'ip))
         (let ,(mappend (fn (_) (list 'get _ (list 'arg gr (str! _))))
                         parms)
           (newslog ip user ',name ,@parms)
           ,@body)))))

(init newsop-names* ())

(mac newsop (name parm rest: body)
  `(do (set newsop-names* (addnew newsop-names* ',name))
       (opexpand defop ,name ,parm ,@body)))

(mac adop (name parms rest: body)
  (let-unique (g)
    `(opexpand defopa ,name ,parms 
       (let ,g (str! ',name)
         (shortpage user nil ,g ,g ,g
           ,@body)))))

(mac edop (name parms rest: body)
  (let-unique (g)
    `(opexpand defope ,name ,parms 
       (let ,g (str! ',name)
         (shortpage user nil ,g ,g ,g
           ,@body)))))


; News Admin

(defopa newsadmin (req res) 
  (let user (get-user req)
    (newslog (get req 'ip) user 'newsadmin)
    (newsadmin-page user)))

(def user-fields (user subject)
  (let (e (editor user) 
        a (admin user) 
        w (= user subject)
        k (and w (> (karma user) topcolor-threshold*))
        u (or a w)
        m (or a (and (member user) w))
        o (profile subject)
        p (fn (k) (get o k)))
    `((string  user       ,subject                                 ,t  ,nil)
      (string  name       ,(p 'name)                               ,m  ,m)
      (string  created    ,(text-age:user-age subject)             ,t  ,nil)
      (string  password   ,(resetpw-link)                          ,w  ,nil)
      (string  saved      ,(saved-link user subject)               ,u  ,nil)
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
      (hexcol  topcolor   ,(or (p 'topcolor) (hexrep site-color*)) ,k  ,k)
      (int     delay      ,(p 'delay)                              ,u  ,u))))


; Note that caching* is reset to val in source when restart server.

(def nad-fields ()
  `((num      caching         ,caching*                       ,t ,t)
    (bigtoks  comment-kill    ,comment-kill*                  ,t ,t)
    (bigtoks  comment-ignore  ,comment-ignore*                ,t ,t)
    (bigtoks  lightweights    ,(sort < (keys lightweights*))  ,t ,t)))

; Need a util like vars-form for a collection of variables.
; Or could generalize vars-form to think of places (in the setf sense).

(def newsadmin-page (user)
  (shortpage user nil nil "newsadmin" "newsadmin"
    (vars-form user 
               (nad-fields)
               (fn (name val)
                 (case name
                   caching            (set caching* val)
                   comment-kill       (todisk comment-kill* val)
                   comment-ignore     (todisk comment-ignore* val)
                   lightweights       (todisk lightweights* (memtable val))
                   ))
               (fn () (newsadmin-page user))) 
    (br2)
    (aform (fn (req)
             (let (user (get-user req) subject (arg req "id"))
               (if (profile subject)
                   (do (killallby subject)
                       (submitted-page user subject))
                   ((andf admin newsadmin-page) user))))
      (single-input "" 'id 20 "kill all by"))
    (br2)
    (aform (fn (req)
             (let user (get-user req)
               (set-ip-ban user (arg req "ip") t)
               ((andf admin newsadmin-page) user)))
      (single-input "" 'ip 20 "ban ip"))))





; (def resetpw-link ()
;   (tostring (underlink "reset password" "resetpw")))

(newsop welcome ()
  (pr "Welcome to " this-site* ", " user "!"))


; Main Operators

; remember to set caching to 0 when testing non-logged-in 

(set caching* 1 perpage* 30 threads-perpage* 10 maxend* 210)

; Limiting that newscache can't take any arguments except the user.
; To allow other arguments, would have to turn the cache from a single 
; stored value to a hash table whose keys were lists of arguments.

(mac newscache (name user time rest: body)
  (let-unique (gc)
    `(let ,gc (cache (fn () (* caching* ,time))
                     (fn () (let ,user nil ,@body)))
       (def ,name (,user)
         (if ,user
             (do ,@body)
             (,gc))))))


(newsop news () (newspage user))

; (newsop ||   () (newspage user))

;(newsop index.html () (newspage user))

; (newscache newspage user 90
(def newspage (user)
  (listpage user (msec) (topstories user maxend*) nil nil "news"))

(def topstories (user i)
  nil)

(def listpage (user t1 items label title url number)
  (init url label)
  (init number true)
  (hook 'listpage user)
  (longpage user t1 nil label title url
    (display-items user items label title url 0 perpage* number)))


; Story Display

(def display-items (user items label title whence 
                    ; (o start 0) (o end perpage*) (o number))
                    )
  (tab
  ; (zerotable
    ; (let n start
    ;   (each i (cut items start end)
    ;     (display-item (and number (++ n)) i user whence t)
    ;     (spacerow (if (acomment i) 15 5))))
    ; (when end
    ;   (let newend (+ end perpage*)
    ;     (when (and (<= newend maxend*) (< end (len items)))
    ;       (spacerow 10)
    ;       (tr (tag (td colspan (if number 2 1)))
    ;           (tag (td class 'title)
    ;             (morelink display-items 
    ;                       items label title end newend number))))))))
    ))
