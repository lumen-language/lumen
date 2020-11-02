(unless (undefined? window)
  (define-global socket* (new (WebSocket "ws://127.0.0.1:3001/path")))

  (set (socket* .onopen)
       [do ((console .log) "Opened!")
           (socket* (.send "foo"))])

  (set (socket* .onmessage)
       [do ((console .log) "Message!" _)
           ])
)

(define-global datestring ((o now (new (Date))))
  (now (.toLocaleTimeString) (.replace |/[:][0-9][0-9] /| " ")))

(define-global App (props)
  (<>
    (<h1> "Hello, " (props .name))))

(define-global App2 ((name: (o name "Unknown Name") date: (o date (new (Date)))))
  (let ((count set-count) (React (.useState 0)))
  (<>
    (<h1> "Hello, " name "!")
    (<p> "The time is now " (datestring date))
    (<p> "You clicked " count " times")
    (<button> onClick: [set-count (+ count 1)]
      "Click me"))))
      
(export App App2)



