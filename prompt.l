; Prompt: Web-based programming application.  4 Aug 06.

(init appdir* "arc/apps/")

(defop prompt (req res)
  (let user (get-user req res)
    (if (admin user)
        (prompt-page user)
        "Sorry.")))

(def prompt-page (user rest: msg)
  (ensure-dir appdir*)
  (ensure-dir (str! appdir* user))
  (whitepage
    (prbold "Prompt")
    (hspace 20)
    (pr user " | ")
    (link "logout")
    (w/span pr
      (when msg (pr (hspace 10)) (apply pr msg)))
    (br2)
    ; (tab
    ;   (each app (dir (+ appdir* user))
    ;     (tr (td app)
    ;         (td (ulink user 'edit   (edit-app user app)))
    ;         (td (ulink user 'run    (run-app  user app)))
    ;         (td (hspace 40)
    ;             (ulink user 'delete (rem-app  user app))))))
    ; (br2)
    (aform (fn (req res)
             (when-umatch user req
               (aif (goodname (arg req "app"))
                    (edit-app user it)
                    (prompt-page user "Bad name."))))
       (tab (row "name:" (input "app") (submit "create app"))))))

(init repl-history* ())

(defop repl (req res)
  (if (admin (get-user req))
      (replpage req res)
      (pr "Sorry.")))

(def replpage (req res)
  (whitepage
    (repl (readall (stream (or (arg req "expr") ""))) "repl")))

(def repl (exprs url)
  (w/span a
    (step expr exprs 
      (on-err (fn (c) (add repl-history* (list expr c true)))
              (fn () 
                (set that* (eval expr)
                     thatexpr* expr)
                (add repl-history* (list expr that*)))))
    (a (form url
      (textarea "expr" 8 60)
      " "
      (submit)))
    ; (a that*)
    (a (<pre>
      (with s ""
        (step (expr val err) (reverse (cut repl-history* (- (# repl-history) 20)))
          (cat! s "\n\n> ")
          (cat! s (pp-to-string expr) "\n")
          (cat! s (if err "Error: " ""))
          (cat! s (pp-to-string val)) "\n"))))))

;     (tag xmp
;       (each (expr val err) (firstn 20 repl-history*)
;         (pr "> ")
;         (ppr expr)
;         (prn)
;         (prn (if err "Error: " "")
;              (ellipsize (tostring (write val)) 800)))))


