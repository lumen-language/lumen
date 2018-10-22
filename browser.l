(when-compiling
  `(do ,(read-from-file "html.l")))

(when-compiling
  (read-from-file "srv.l"))

; (define render ()
;   (<div>
;     (<a> href: "ext/react.js" "ext/react.js")))

; (define render ()
;   (tab
;     (row (link "foo" "ext/react.js"))
;     (row "zz" "foo")
;     (row (single-input "Foo" "afoo" 20 "Submit!"))
;     (row (pagemessage "msg"))
    
;     ))

; (set (get _G 'render) render)
