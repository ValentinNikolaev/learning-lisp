;; hello world with function
;; read-eval-print loop

(defun simple-list ()
  (list 1 2 3))
(defun simple-plist()
  (list :a 1 :b 2 :third-34 34))

(defun get-simple-plist(el)
  (getf (simple-plist) el))


(defun make-album (title artist rating ripped)
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
