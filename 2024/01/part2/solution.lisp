(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun solve (lst)
  (let
    (
     (left (sort (mapcar #'parse-integer (mapcar #'first lst)) #'<))
     (right (sort (mapcar #'parse-integer (mapcar #'second lst)) #'<))
     )
    (reduce #'+
      (mapcar (lambda (x)
          (* x (count x right))
        )
        left
      )
    )
   )
)

(defun preprocess (lst)
  (mapcar (lambda (line)
      (remove-if (lambda (x) (string= x "")) (uiop:split-string line :separator " "))
    )
    lst
  )
)

(write (solve (preprocess data)))
(terpri)
