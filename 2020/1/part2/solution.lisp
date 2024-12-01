(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun solve (lst)
  (loop for n in lst do
        (loop for n2 in lst do
          (loop for n3 in lst
            when (= 2020 (+ n n2 n3))
              do (return-from solve (* n n2 n3))
          )
        )
    )
)

(defun preprocess (lst)
    (mapcar #'parse-integer lst)
)

(write (solve (preprocess data)))
