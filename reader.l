(define delimiters (set-of "(" ")" "[" "]" "{" "}" ";" "\r" "\n"))
(define whitespace (set-of " " "\t" "\r" "\n"))

(define stream (str more)
  (obj pos: 0 string: str len: (# str) more: more))

(define peek-char (s (o i 0))
  (let ((pos: pos len: len string: str) s)
    (when (< (+ pos i) len)
      (char str (+ pos i)))))

(define read-char (s)
  (let c (peek-char s)
    (if c (do (inc (get s 'pos)) c))))

(define skip-non-code (s)
  (with any? nil
    (while true
      (let c (peek-char s)
        (if (nil? c) (break)
            (get whitespace c) (read-char s)
            (= c ";")
            (do (while (and c (not (= c "\n")))
                  (set c (read-char s)))
                (skip-non-code s))
          (break)))
      (set any? true))))

(define read-table (obj))

(define read (s eof)
  (skip-non-code s)
  (let c (peek-char s)
    (if (is? c)
        ((or (get read-table c)
             (get read-table ""))
         s)
      eof)))

(define read-all (s)
  (with l ()
    (let eof (obj)
      (while true
        (let form (read s eof)
          (if (= form eof) (break))
          (add l form))))))

(define-global read-string (str more)
  (read (stream str more)))

(define key? (atom)
  (and (string? atom)
       (> (# atom) 1)
       (= (char atom (edge atom)) ":")))

(define expected (s c)
  (let ((more: more pos: pos) s)
    (or more (error (cat "Expected " c " at " pos)))))

(define wrap (s x)
  (let y (read s)
    (if (= y (get s 'more)) y
      (list x y))))

(define hex-prefix? (str)
  (let i (if (= (code str 0) 45) 1 0)  ; "-"
    (and (= (code str i) 48)           ; "0"
         (let n (code str (inc i))
           (or (= n 120) (= n 88)))))) ; "x" or "X"

(define maybe-number (str)
  (if (hex-prefix? str)
      (target js: (parseInt str 16) lua: (tonumber str))
      (number-code? (code str (edge str)))
    (number str)))

(define real? (x)
  (and (number? x) (not (nan? x)) (not (inf? x))))

(define valid-access? (str)
  (and (> (# str) 2)
       (not (= "." (char str 0)))
       (not (= "." (char str (edge str))))
       (nil? (search str ".."))))

(define parse-index (a b)
  (print (str `(parse-index ,a ,b)))
  (if (nil? a)
      (cat "." b)
    (let n (number a)
      (if (nil? n)
          `(get ,b ,(quoted a))
        `(at ,b ,n)))))

(define parse-access (x prev)
  (print (str `(parse-access ,x ,prev)))
  (parse-index x prev))
  ; (let (parts (if prev (list prev) ())
  ;       splits (split x "."))
  ;   (print (str `(parse-access ,x ,prev parts: ,parts splits: ,splits)))
  ;   (reduce parse-index (reverse (join parts (split x "."))))))

(define read-atom (s (o basic? false))
  (let str ""
    (while true
      (let c (peek-char s)
        (if (= c "\\") (cat! str (read-char s) (read-char s))
            (and c (and (not (get whitespace c))
                        (not (get delimiters c))))
            (cat! str (read-char s))
          (break))))
  (if (= str "true") true
      (= str "false") false
      basic? s
    (let n (maybe-number str)
      (if (real? n) n str)))))


(define read-list (s ending) 
  (read-char s)
  (with r nil
    (let l ()
      (while (nil? r)
        (skip-non-code s)
        (let c (peek-char s)
          (if (= c ending) (do (read-char s) (set r l))
              (nil? c) (set r (expected s ending))
            (let x (read s)
              (if (key? x)
                  (let (k (clip x 0 (edge x))
                        v (read s))
                    (set (get l k) v))
                (add l x)))))))))

(define read-next (s prev ws? eof)
  (return prev)
  (case (peek-char s)
    "." (do (read-char s)
            (skip-non-code s)
            (if (nil? (peek-char s))
                (or (get s 'more) eof)
                ; when reading e.g. "(list '(a b) 'c).0.1", the t
                ; parameter avoids parsing "0.1" as a number.
              (let x (read-atom s true)
                (if (or (= x eof) (= x (get s 'more))) x
                  (read-next s (parse-access x prev) nil eof)))))
    "(" (if ws? prev
          (let x (read-list s ")")
            (if (= x (get s 'more)) x
              (read-next s `(,prev ,@x) (skip-non-code s) eof))))
    prev))

(define-reader ("" s) ; atom
  (read-next s (read-atom s)))

(define-reader ("(" s)
  (read-next s (read-list s ")")))

(define-reader (")" s)
  (error (cat "Unexpected ) at " (get s 'pos))))

(define-reader ("[" s)
  (read-char s)
  (with r nil
    (let l '((%brackets))
      (while (nil? r)
        (skip-non-code s)
        (let c (peek-char s)
          (if (= c "]") (do (read-char s) (set r l))
              (nil? c) (set r (expected s "]"))
            (let x (read s)
              (add l x))))))))

(define-reader ("]" s)
  (error (cat "Unexpected ] at " (get s 'pos))))

(define-reader ("{" s)
  (read-char s)
  (with r nil
    (let l '((%braces))
      (while (nil? r)
        (skip-non-code s)
        (let c (peek-char s)
          (if (= c "}") (do (read-char s) (set r l))
              (nil? c) (set r (expected s "}"))
            (let x (read s)
              (add l x))))))))

(define-reader ("}" s)
  (error (cat "Unexpected } at " (get s 'pos))))

(define-reader ("\"" s)
  (read-char s)
  (with r nil
    (let str "\""
      (while (nil? r)
        (let c (peek-char s)
          (if (= c "\"") (set r (cat str (read-char s)))
              (nil? c) (set r (expected s "\""))
            (do (when (= c "\\")
                  (cat! str (read-char s)))
                (cat! str (read-char s)))))))))

(define-reader ("|" s)
  (read-char s)
  (with r nil
    (let str "|"
      (while (nil? r)
        (let c (read-char s)
          (if (nil? c) (set r (expected s "|"))
              (= c "|") (if (= (peek-char s) "|")
                            (cat! str (read-char s))
                          (set r (cat str c)))
            (cat! str c)))))))

(define-reader ("'" s)
  (read-char s)
  (wrap s 'quote))

(define-reader ("`" s)
  (read-char s)
  (wrap s 'quasiquote))

(define-reader ("," s)
  (read-char s)
  (if (= (peek-char s) "@")
      (do (read-char s)
          (wrap s 'unquote-splicing))
    (wrap s 'unquote)))

(define-reader ("~" s)
  (read-char s)
  (wrap s 'complement))

(export stream
        read
        read-all
        read-string
        read-table)
