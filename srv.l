(during-compilation
  (load "lib.l"))

(def sym (x)
  (pp-to-string x))

(def arg (req k)
  (either (get (get req 'query) k)
          (get (get req 'body) k)))


(init srvops* (obj)
      redirector* (obj)
      optimes* (obj)
      opcounts* (obj))

(def save-optime (name elapsed)
  (init (get opcounts* name) 0)
  (inc (get opcounts* name)))

(mac defop-raw (name parms rest: body)
  `(set (get srvops* ',name)
        (fn ,parms
          (with x (do ,@body)
            (save-optime ',name 0)))))

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

(def server-render (x)
  (if (obj? x)
      ((ReactDOM .render-to-string) x)
    (either x "")))

(def respond (op req res next)
  (print srvops*)
  (let-when f (get srvops* op)
    (if (get redirector* op)
        ((res .location) (f req res next))
      ((res .send) (server-render (f req res next))))
    (return true))
  (when (((require 'system) .file-exists?) op)
    ((res .send-file) (cat __dirname "/" op))
    return true))

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
  (aif (get fns* (sym (arg req "fnid")))
       (it req res next)
      dead-msg*))

(defop-raw y (req res next)
  (aif (get fns* (sym (arg req "fnid")))
       (it req res next)
     "deadlink"))

(defop-raw a (req res next)
  (aif (get fns* (sym (arg req "fnid")))
       (do (it req res next) nil)))

(defopr r (req res next)
  (aif (get fns* (sym (arg req "fnid")))
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
  (<input> type: 'hidden name: 'fnid value: id))

(def fnform (f bodyfn redir)
  (<form> method: 'post action: (if (not (= redir nil)) rfnurl2* fnurl*)
    (fnid-field (fnid f))
    (bodyfn)))

(mac aform (f rest: body)
  `(<form> method: 'post action: fnurl*
     (fnid-field (fnid ,f))
     ,@body))

; only unique per server invocation

(init unique-ids* (obj))

(def unique-id (len)
  (let id (rand-string (max 5 len))
    (if (get unique-ids* id)
        (unique-id len)
        (set (get unique-ids* id) id))))

