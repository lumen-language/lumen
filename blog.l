; (during-compilation
;   (load "app.l"))

(init postdir* "arc/posts/" maxid* 0 posts* (obj))

(init blogtitle* "A Blog")

; (def temload (kind path)
;   (with p (read-string (read-file path))
;     (set (hd p) kind)))

(def load-posts ()
  (while (file? (str! postdir* (+ maxid* 1)))
    (set (get posts* (+ maxid* 1)) (temload 'post (str! postdir* (+ maxid* 1))))
    (inc maxid*))
  maxid*)

(load-posts)

; (def inst (kind rest: self)
;   (set (hd self) kind)
;   self)

; (def save-table (x path)
;   (write-file path (pp-to-string x))
;   x)

(def save-post (p) (save-table p (str! postdir* (get p 'id))))

(def post (id) (get posts* (number (tostring id))))

(def file? (x) (((require 'system) .file-exists?) x))

(mac blogpage body
  `(whitepage
     (center
       (widtable 600
         (<b> (link blogtitle* "blog"))
         (br 3)
         ,@body
         (br 3)
         (row (link "archive") " | " (link "new post" "newpost"))))))

(defop viewpost (req res) (blogop post-page req))

; (def get-user (req)
;   "root")

(def blogop (f req)
  (aif (post (arg req "id"))
       (f (get-user req) it)
       (blogpage (pr "No such post."))))

(def post-link (p) (str! "viewpost?id=" (get p 'id)))

(def post-page (user p) (blogpage (display-post user p)))

(def display-post (user p)
  (<span>
    (<b> (link (get p 'title) (post-link p)))
    (when user " ")
    (when user
      (link "[edit]" (str! "editpost?id=" (get p 'id))))
    (br2)
    (get p 'text)))

(defop newpost (req res)
  (whitepage
    (aform (fn (req res next)
             (let u (get-user req)
               (post-page u (addpost u (arg req "t") (arg req "b")))))
      (tab (row "title" (input "t" "" 60))
           (row "text"  (textarea "b" 10 80))
           (row ""      (submit))))))

(def addpost (user title text)
  (let p (inst 'post id: (inc maxid*) title: title text: text)
    (save-post p)
    (set (get posts* (get p 'id)) p)))

(defop editpost (req res) (blogop edit-page req))

(def edit-page (user p)
  (whitepage
    (str! user p)))

(defop archive (req res)
  (blogpage
    (load-posts)
    (<ul>
      (with forms ()
        (for i maxid*
          (let-when p (post (+ i 1))
            (add forms (<li> (link (get p 'title) (post-link p))))))))))

(defop blog (req res)
  (let user (get-user req)
    (blogpage
      (with forms ()
        (for i 4
          (aif (post (- maxid* i))
               (do (add forms (display-post user it))
                   (add forms (br 3)))))))))

