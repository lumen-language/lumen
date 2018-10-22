(mac tag-if (test spec rest: body)
  `(if ,test
       (,spec ,@body)
      (do ,@body)))

(mac whitepage body
  `(<html>
     (<body> bgcolor: "white" alink: "blue"
        ,@body)))

(mac center body `(<center> ,@body))
(mac tab body `(<table> (<tbody> ,@(vals body)) ,@(props body)))
(mac tr body `(<tr> ,@body))
(mac td body `(<td> ,@body))
(mac tdr body `(<td> align: 'right ,@body))
(mac trtd body `(tr (td ,@body)))

(mac row args
  `(tr ,@(map (fn (x) `(td ,x)) args)))

(mac br (n)
  (with form '(<span>)
    (for i (or n 1)
      (add form `(<br>)))))

(mac br2 () `(br 2))

(mac prbold body `(<b> ,@body))

(def blank-url () "ext/s.gif")

(def hspace (n)    (<img> src: (blank-url) height: 1 width: n))
(def vspace (n)    (<img> src: (blank-url) height: n width: 0))
(def vhspace (h w) (<img> src: (blank-url) height: h width: w))

(during-compilation
  (define-special px (n)
    (cat (compile n) "px")))

(def style (k v)
  (cat k ": " (compile v)))

(mac new-hspace (n)
  `(<span> style: (style "padding-left" ,n)))

(def spacerow (h)
  (<tr> style: (style "height" (px h))))

(mac sptab body
  `(<table> style: "border-spacing: 7px 0px;" ,@body))

(mac widtable (w rest: body)
  `(<table> width: ,w (tr (td ,@body))))

(def cellpr (x) (either x "&nbsp;"))

(def but (text name)
  (let text (either text "submit")
    (<input> type: 'submit name: name value: text)))

(def submit (val)
  (let val (either val "submit")
    (<input> type: 'submit value: val)))

(mac spanrow (n rest: body)
  `(tr (td colspan: ,n ,@body)))

(mac form (action rest: body)
  `(<form> method: 'post action: ,action ,@body))

(mac textarea (name rows cols rest: body)
  `(<textarea> name: ,name rows: ,rows cols: ,cols ,@body))

(def input (name val size)
  (<input> type: 'text
           name: name
           value: (either val "")
           size: (either size 10)))

(def tuples (l k)
  (init k 2)
  (accum a
    (let (i 0 n (# l))
      (while (< i n)
        (let r ()
          (for j k
            (add r (at l (+ i j))))
          (a r))
        (inc i k)))))

(mac span args
  `(<span> ,@args))

(mac inputs args
  `(tab
     ,@(map (fn ((name label len text))
              (let-unique (gl gt)
                `(let ,gl ,len
                   (tr (td (cat ',label ":"))
                       (if(obj? ,gl)
                         (td (textarea ',name (hd ,gl) (at ,gl 1)
                               ,text))
                         (td (<input> type: ',(if (= label 'password) 'password 'text)
                                name: ',name
                                size: ,len
                                value: ,text)))))))
            (tuples args 4))))
    

(def single-input (label name chars btext pwd: pwd?)
  (<div>
    label
    (<input> type: (if pwd? 'password 'text) name: name size: chars)
    " "
    (submit btext)))

(def link (text dest color)
  (<a> href: (either dest text)
       text))

(mac line (rest: body)
  `(<span> ,@body (br2) "zz"))

(mac spanclass (name rest: body)
  `(<span> class: ',name ,@body))

(def pagemessage (text)
  (when (and (string? text) (some? text))
    (line text)))
    



(<Button>) ; React.createElement("Button")

(<a> href: "google.com" "Google!") ; React.createElement

