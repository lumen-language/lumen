(define-global React (require 'react))
(define-global ReactDOM (require 'react-dom/server))
(define-global express (require 'express))
(define-global websocket (require 'websocket))
(define-global http (require 'http))

(define-variable app (express))
(define-variable server* nil)

(target js:
  (define-global html (x)
    ((ReactDOM .renderToStaticMarkup) x)))

(target js:
  (define-global render (x)
    ((ReactDOM .renderToString) x)))

(define-macro %js body
  (set target* 'js)
  (quoted (compile (expand `(do ,@body)))))

(define-global compile-script (expr)
  (set target* 'js)
  (<script> dangerouslySetInnerHTML: (obj __html: (compile (expand expr)))))

(define-global tag (name rest: body)
  ((React .createElement) name (props body) (unpack (vals body))))

(define-global whitepage (name: name)
  ;(define-global App2 ((require "./app") .App2))
  (define App2 ((load "app/app.l") .App2))
  (<html>
    (<head>
      (<script> cross-origin: "" src: "https://unpkg.com/react@17/umd/react.development.js")
      (<script> cross-origin: "" src: "https://unpkg.com/react-dom@17/umd/react-dom.development.js"))
    (<body>
      (<div> id: "root" ((React .createElement) App2 (obj name: name)))
      (compile-script
        `(do
           (set _G window)
           ,(almost (read-from-file "runtime.l"))
           ,(almost (read-from-file "app/app.l"))
           (define tick (hydrate)
             ((if hydrate (ReactDOM .hydrate) (ReactDOM .render))
              (<App2> name: ',name)
              (document (.get-element-by-id "root"))))
           (tick true)
           (setInterval (fn () (tick)) 1000))))))

(define-global app-index (req res)
  (let component (render (whitepage name: "SSR"))
    (res (.send component))))

(app (.get "/" app-index))

(define-global main (argv)
  (let ((port: (o port 8090)
         wsport: (o wsport 3001))
        (parse-arguments (obj p: 'port ws: 'wsport)))
    ((app .listen)
     port
     [do (print (cat "Server is running on " (str port)))
         (let srv (http (.create-server))
           (srv (.listen wsport))
           (set server* (new ((websocket .server) (obj httpServer: srv))))

           ((server* .on)
            'request
            [let request _
              (print "Connected")
              (print (keys request))
              (set client* (request (.accept null (request .origin))))
              ((client* .on)
               'message
               [let data _
                 (print (str `(data ,data from ,(request .httpRequest .headers .host))))])
              ])
           )
         ])
    app))
      
(export main)




