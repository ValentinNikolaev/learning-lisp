;; hello world with function
;; read-eval-print loop

(defun simple-list ()
  (list 1 2 3))
(defun simple-plist()
  (list :a 1 :b 2 :third-34 34))

(defun get-simple-plist(el)
  (getf (simple-plist) el))


(defun make-track (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))

(defvar *db* nil)

(defun add-track(album)
  (push album *db*))

(defun dump-db ()
  (dolist (track *db*)
    (format t "~{~a:~10t~a~%~}~%" track)))

(defun dump-db-oneline ()
  (format t "~{~{~a:~10t~a~%~}~%~}" *db*))

(defun prompt-read (prompt)
 (format *query-io* "~a: " prompt)
 (force-output *query-io*)
 (read-line *query-io*))

(defun prompt-for-track ()
 (make-track
   (prompt-read "Title")
   (prompt-read "Artist")
   (or (parse-integer (prompt-read "Rating") :junk-allowed t) 0)
   (y-or-n-p "Ripped [y/n]: ")))

(defun add-tracks()
  (loop (add-track (prompt-for-track))
	(if (not (y-or-n-p "Another one [y/n]: /")) (return))))

(defun save-db (filename)
  (with-open-file (out filename
                   :direction :output
                   :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))

(defun select-by-artist(artist)
  (remove-if-not #'
   (lambda (track) (equal (getf track :artist) artist)) *db*)
  )


(defun artist-selector (artist)
  #'(lambda(track) (equal (getf track :artist) artist)))

(defun select (selector-fn)
  
  (remove-if-not selector-fn *db*))

(defun foo_var_args
    (&key a (b 20) (c 30 c-p)) (list a b c c-p))

(defun where-old (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
    (and
      (if title    (equal (getf cd :title)  title)  t)
      (if artist   (equal (getf cd :artist) artist) t)
      (if rating   (equal (getf cd :rating) rating) t)
      (if ripped-p (equal (getf cd :ripped) ripped) t))))


(defun update (selector-fn &key title artist rating (ripped nil ripped-p))
  (setf *db*
	(mapcar
	 #'(lambda(row)
	     (when (funcall selector-fn row)
	       (if title (setf (getf row :title) title))
	       (if artist (setf (getf row :artist) artist))
	       (if rating (setf (getf row :rating) rating))
	       (if ripped-p (setf (getf row :ripped) ripped)))
	     row)
	 *db* )))

(defun delete-rows (selector-fn)
  (setf *db* (remove-if selector-fn *db*)))

(defmacro backwards (expr)
  (reverse expr))

(defun make-comparison-expr-old (field value)
  (list 'equal (list 'getf 'cd field) value))

(defun make-comparison-expr (field value)
  `(equal (getf cd ,field) ,value))

(defun make-comparisons-list (fields)
  (loop while fields
	collecting (make-comparison-expr (pop fields) (pop fields))))

(defmacro where (&rest clauses)
  `#'(lambda (cd) (and ,@(make-comparisons-list clauses))))
