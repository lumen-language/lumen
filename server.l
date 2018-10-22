; (when (undefined? __dirname)
;   (set __dirname ((require 'system) (.run "bash -c 'pwd'")))
;   (set __dirname (clip __dirname 0 (edge __dirname))))

; (during-compilation
;   (load "browser.l")
;   ; (load "srv.l")
;   )
(during-compilation
  (load "app.l")
  (load "browser.l")
  (load "blog.l"))

(set app (or (get _G 'app) (express)))
(set (get _G 'app) app)

((app .use) (_G .body-parser (.json)))
((app .use) (_G .body-parser (.urlencoded extended: true)))

(define-global render-page ()
  (ReactDOM (.render-to-string (whitepage (_G (.render))))))

(define-global serve-root (req res next)
  (print req)
  (let op (clip (at (req .params) 0) 1)
    (print op)
    ; (res (.send (render-page)))
    ; (res (.send (sym (arg req 'fnid))))
    (unless (respond op req res next)
      (res (.send "Failed"))))
  nil)
  ; (next)


((app .get) "*" (fn (req res next)
                  (serve-root req res next)
                   ))

((app .post) "*" (fn (req res next)
                  (serve-root req res next)
                   ))


; ((app .get) "/x" (fn (req res next)
;                    ; (print (sym (arg req 'fnid)))
;                   (serve-root req res next)
;                    ))

; ((app .get) "/y" (fn (req res next)
;                   (serve-root req res next)
;                    ))

; ((app .get) "/item" (fn (req res next)
;                   (serve-root req res next)
;                    ))

((app .use) ((express .static) __dirname redirect: false))

(set reloadtime* 500)

(def protect (during after throw: throw?)
  (let ((ok v) (guard (during)))
    (if after (guard (after)))
    (if ok v throw? (throw v) (print (error-message v)))))

(mac errsafe body
  `(protect (fn () ,@body) throw: false))

(define-global reload-every (ms)
  (setTimeout 
    (fn ()
      (print 'reloading)
      ((compose errsafe load) "browser.l")
      ((compose errsafe load) "server.l")
      (reload-every reloadtime*))
    (or ms 500)))

(define main ()
  (reload-every)
  (asv 3000)
  ((app .listen) 3000))

(export main)
