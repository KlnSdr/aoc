(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

(ql:quickload "cl-ppcre")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun getDia1 (x y all)
  (list
    (char (nth (1- y) all) (1- x))
    (char (nth (1+ y) all) (1+ x))
    )
  )

(defun getDia2 (x y all)
  (list
    (char (nth (1- y) all) (1+ x))
    (char (nth (1+ y) all) (1- x))
    )
  )

(defun checkXmas (x y all)
  (if
    (and
      (not (null (ppcre:scan "(MS)|(SM)" (coerce (getDia1 x y all) 'string))))
      (not (null (ppcre:scan "(MS)|(SM)" (coerce (getDia2 x y all) 'string))))
      )
    1
    0
    )
  )

(defun solve (lst)
  (let
    (
     (acc 0)
     )
    (loop for y from 1 to (- (length lst) 2) do
          (loop for x from 1 to (- (length (first lst)) 2) do
                (when (eq (char (nth y lst) x)#\A)
                  (setf acc (+ acc (checkXmas x y lst)))
                  )
                ))
    acc
    )
  )

(write (solve data))
(terpri)
