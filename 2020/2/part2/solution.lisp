(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun xor (a b)
  (not (eq a b))
)

(defun isValid (pwd)
    (if (xor
          (eq (char (second pwd) 0) (char (third pwd) (- (first (first pwd)) 1)))
          (eq (char (second pwd) 0) (char (third pwd) (- (second (first pwd)) 1)))
          )
      T
    )
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
