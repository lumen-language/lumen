
(define-macro fn [args & body]
  `(%function ,@(bind-function args body) ,@(props body)))

(define-macro let [bs & body]
  (if (atom? bs) `(let [,bs ,(hd body)] ,@(tl body))
      (none? bs) `(%do ,@body)
      (and (one? bs) (atom? (hd bs))) `(let [,@bs ,(hd body)] ,@(tl body) ,@bs)
      (brackets? bs) `(,(if (empty? body) `var `let) ,(tl bs) ,@body)
      ((fn* [lh rh & bs2]
         ((fn* [id val & bs1]
            ((fn* [id1]
               `(%do (%local ,id1 ,val)
                 (let-symbol [,id ,id1]
                             (let [,@(join bs1 bs2)] ,@body))))
              (unique id)))
           (bind lh rh)))
        bs)))
;    (let [[lh rh & bs2] bs
;          [id val & bs1] (bind lh rh)
;          id1 (unique id)]
;      `(%do (%local ,id1 ,val)
;        (let-symbol [,id ,id1]
;          (%let [,@(join bs1 bs2)] ,@body))))))

(define-macro for [i to & body]
  (if (obj? i)
      `(let ,(apply join (map (fn [x] `(,x nil)) i))
        (%for ,to (%names ,@i) (%do ,@body) ,@(props body)))
      `(let [,i 0]
        (while (< ,i ,to)
               ,@body
               (inc ,i)))))
