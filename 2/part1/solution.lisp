(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun isValid (pwd)
  (let ((num (count (char (second pwd) 0) (third pwd))))
    (if (and 
          (>= num (first (first pwd)))
          (<= num (second (first pwd)))
          )
      T
      ))
  )

(defun solve (lst)
  (length (remove-if-not (lambda (v) (eq v T)) (mapcar #'isValid lst)))
)

(defun preprocess (lst)
  (mapcar (lambda (tpl) (
    list
        (mapcar #'parse-integer (uiop:split-string (first tpl) :separator "-"))
        (first (uiop:split-string (second tpl) :separator ":"))
        (third tpl)
    ))
      (mapcar (lambda (line) (uiop:split-string line :separator " " )) lst)
  )
)

(write (solve (preprocess data)))
