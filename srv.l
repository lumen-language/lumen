(during-compilation
  (load "lib.l"))

(init arcdir* "arc/" logdir* "arc/logs/" staticdir* "static/")

(init quitsrv* nil breaksrv* nil) 

(def ensure-srvdirs ()
  (map ensure-dir (list arcdir* logdir* staticdir*)))

(ensure-srvdirs)

(init srv-noisy* nil)

(def sym (x)
  (pp-to-string x))

(def arg ((method: method body: body query: query) k)
  (let l (if (= method 'POST) body query)
    (print (str! `(arg ,method ,k ,l ,(get l k))))
    (if k (get l k) l)))

(init srvops* (obj)
      redirector* (obj)
      optimes* (obj)
      opcounts* (obj))

(def save-optime (name elapsed)
  (init (get opcounts* name) 0
        (get optimes* name) (list))
  (print (str! `(op ,name ,elapsed)))
  (inc (get opcounts* name))
  (add (get optimes* name) elapsed))

(mac defop-raw (name parms rest: body)
  (let-unique (t1)
    `(set (get srvops* ',name)
          (fn ,parms
            (let ,t1 (msec)
              (with x (do ,@body)
                (save-optime ',name (- (msec) ,t1))))))))

(mac defopr-raw (name parms rest: body)
  `(set (get redirector* ',name) true
        (get srvops* ',name) (fn ,parms ,@body)))

(mac defop (name parms rest: body)
  `(do (wipe (get redirector* ',name))
       (defop-raw ,name ,parms
         ,@body)))

(mac defopr (name parms rest: body)
  `(do (set (get redirector* ',name) true)
       (defop-raw ,name ,parms
         ,@body)))

(init unknown-msg* "Unknown." max-age* (obj) static-max-age* nil)

(mac time body
  (let-unique (t1 t2)
    `(let ,t1 (msec)
       (with x (do ,@body)
         (let ,t2 (msec)
           (print (cat "time: " (str (- ,t2 ,t1)) " msec.")))))))

(def server-render (x)
  (print (pp-to-string x))
  (if ((React .is-valid-element) x)
      ((ReactDOM .render-to-string) x)
      (obj? x)
      (server-render (<span> (unpack x)))
    (either x "")))

(def log-request (type op args cooks ip t0 t1)
  (srvlog 'srv ip type op
          ; (let arg1 (hd args)
          ;   (if (hd? arg1 "fnid") "" arg1))
          args
          cooks))

(def log-req (op req res)
  (let (type (get req 'method)
        ip (get req 'ip)
        cooks (get-cookie req res)
        args (arg req))
    (log-request type op args cooks ip)))

; (def get-cookie (req res k)
;   (let p (listtab (map (fn (x) (split x "=")) (split (req .headers .cookie) "; ")))
;     (if k (get p k) p)))

(def respond (op req res next)
  ; (print srvops*)
  (let-when f (get srvops* op)
    (if (get redirector* op)
        ((res .location) (time (f req res next)))
      ((res .send) (time (server-render (time (f req res next))))))
    (log-req op req res)
    (return true))
  (when (((require 'system) .file-exists?) op)
    (time ((res .send-file) (cat __dirname "/" op)))
    ; (log-req op req res)
    (return true)))

(init fns* (obj))

(def new-fnid ()
  (let x (rand-string 10)
    (if (has? fns* x) (new-fnid) x)))

(def fnid (f)
  (with k (new-fnid)
    (set (get fns* k) f)))

(init fnurl* "/x" rfnurl* "/r" rfnurl2* "/y" jfnurl* "/a")

(init dead-msg* "\nUnknown or expired link.")

(defop-raw x (req res next)
  (aif (get fns* (arg req "fnid"))
       (it req res next)
      dead-msg*))

(defopr-raw y (req res next)
  ; (error (str! (arg req "fnid") (get fns* (arg req "fnid"))))
  (aif (get fns* (arg req "fnid"))
       (it req res next)
     "deadlink"))

(defop-raw a (req res next)
  (aif (get fns* (arg req "fnid"))
       (do (it req res next) nil)))

(defopr r (req res next)
  (aif (get fns* (arg req "fnid"))
       (it req res next)
      "deadlink"))

(defop deadlink (req res next)
  dead-msg*)

(def url-for (fnid)
  (cat fnurl* "?fnid=" fnid))

(def flink (f)
  (cat fnurl* "?fnid=" (fnid f)))

(def rflink (f)
  (cat rfnurl* "?fnid=" (fnid f)))

(mac w/link (expr rest: body)
  `(<a> href: (flink (fn () ,expr))
        ,@body))

(mac w/rlink (expr rest: body)
  `(<a> href: (rflink (fn () ,expr))
        ,@body))

(mac onlink (text rest: body)
  `(w/link (do ,@body) ,text))

(mac onrlink (text rest: body)
  `(w/rlink (do ,@body) ,text))

(mac linkf (text parms rest: body)
  `(<a> href: (flink (fn ,parms ,@body)) ,text))

(mac rlinkf (text parms rest: body)
  `(<a> href: (rflink (fn ,parms ,@body)) ,text))

(mac whitepage body
  `(<html>
     (<head>
       (<script> src: "ext/react.js")
       (<script> src: "ext/react-dom.js")
       (<script> src: "ext/lumen.js")
       (<script> src: "ext/browser.js"))
     (<body> bgcolor: "white" alink: "blue"
        ,@body)))

(defop hello (req res next)
  (whitepage
    (linkf "Woo" (req res next) (whitepage "asdf"))))

(mac w/link-if (test expr rest: body)
  `(if ,test (<a> href: (flink (fn () ,expr)) ,@body)
     (do ,@body)))

(def fnid-field (id)
  (<input> type: 'hidden name: 'fnid value: id key: id))

(def fnform (f bodyfn redir)
  (<form> method: 'post action: (if (not (= redir nil)) rfnurl2* fnurl*)
    (fnid-field (fnid f))
    (bodyfn)))

(mac aform (f rest: body)
  `(<form> method: 'post action: fnurl*
     (fnid-field (fnid ,f))
     ,@body))

; Like aform except creates a fnid that will last for lasts seconds
; (unless the server is restarted).

(mac taform (lasts f rest: body)
  `(aform ,f ,@body))
  ; (w/uniq (gl gf gi ga)
  ;   `(withs (,gl ,lasts
  ;            ,gf (fn (,ga) (prn) (,f ,ga)))
  ;      (tag (form method 'post action fnurl*)
  ;        (fnid-field (if ,gl (timed-fnid ,gl ,gf) (fnid ,gf)))
  ;        ,@body))))


; only unique per server invocation

(init unique-ids* (obj))

(def unique-id (len)
  (let id (rand-string (max 5 len))
    (if (get unique-ids* id)
        (unique-id len)
        (set (get unique-ids* id) id))))

(mac w/appendfile (o name rest: body)
  (let-unique (s)
    `(let (,s "" ,o (fn (x) (cat! ,s x)))
       ,@body
       (writefile (cat (or (errsafe (read-file ,name)) "") ,s) ,name))))

(def srvlog (type ...)
  (w/appendfile o (logfile-name type)
    (o (cat (tostring (seconds)) " " (inner (pp-to-string (list ...))) "\n"))))

; (def memodate ()
;   (let now (seconds)
;     (if (or (no lastasked) (> (- now lastasked) 60))
;         (= lastasked now lastval (datestring))
;         lastval)))


(def logfile-name (type)
  (cat logdir* type "-" (datestring)))

