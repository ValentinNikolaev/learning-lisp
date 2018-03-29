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
