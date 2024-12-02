(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun is-ascending (lst)
  (if (<= (length lst) 1)
    T
    (and (<= (car lst) (cadr lst)) (is-ascending (cdr lst)))
  )
)

(defun is-descending (lst)
  (if (<= (length lst) 1)
    T
    (and (>= (car lst) (cadr lst)) (is-descending (cdr lst)))
  )
)

(defun get-max-diff (line)
  (let
    (
     (i 1)
     (diff -1)
    )
    (loop do
      (setf diff (max diff (abs (- (nth i line) (nth (1- i) line)))))
      (setf i (1+ i))
      (when (>= i (length line))
        (return)
      )
    )
    diff
  )
)

(defun get-min-diff (line)
  (let
    (
     (i 1)
     (diff 100)
    )
    (loop do
      (setf diff (min diff (abs (- (nth i line) (nth (1- i) line)))))
      (setf i (1+ i))
      (when (>= i (length line))
        (return)
      )
    )
    diff
  )
)

(defun is-valid-line (line)
  (and
    (or
      (is-ascending line)
      (is-descending line)
    )
    (<= (get-max-diff line) 3)
    (>= (get-min-diff line) 1)
  )
)

(defun remove-one-element-from-list (lst n)
  (remove-if (constantly t) lst :start n :count 1)
)

(defun is-valid-tolerated-line (line)
  (if (is-valid-line line)
    T
    (
     loop for i from 0 to (1- (length line)) do
      (when (is-valid-line (remove-one-element-from-list line i))
        (return-from is-valid-tolerated-line T)
      )
    )
  )
)

(defun solve (lst)
  (length (remove-if-not #'is-valid-tolerated-line lst))
)

(defun preprocess (lst)
  (mapcar
    (lambda (x)
      (mapcar #'parse-integer (uiop:split-string x :separator " "))
    )
    lst
  )
)

(write (solve (preprocess data)))
(terpri)
