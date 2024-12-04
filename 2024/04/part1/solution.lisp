(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

(ql:quickload "cl-ppcre")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun checkHorizontal (x y all)
  (if
    (< (+ x 3) (length (first all)))
    (list
      (char (nth y all) x)
      (char (nth y all) (+ x 1))
      (char (nth y all) (+ x 2))
      (char (nth y all) (+ x 3))
      )
    '()
    )
  )

(defun checkVertical (x y all)
  (if (< (+ y 3) (length all))
    (list
      (char (nth y all) x)
      (char (nth (+ y 1) all) x)
      (char (nth (+ y 2) all) x)
      (char (nth (+ y 3) all) x)
      )
    '()
    )
  )

(defun checkDiagonally1 (x y all)
  (if (and
        (< (+ x 3) (length (first all)))
        (< (+ y 3) (length all))
        )
    (list
      (char (nth y all) x)
      (char (nth (+ y 1) all) (+ x 1))
      (char (nth (+ y 2) all) (+ x 2))
      (char (nth (+ y 3) all) (+ x 3))
      )
    '()
    )
  )

(defun checkDiagonally2 (x y all)
  (if (and
        (>= (- x 3) 0)
        (< (+ y 3) (length all))
        )
    (list
      (char (nth y all) x)
      (char (nth (+ y 1) all) (- x 1))
      (char (nth (+ y 2) all) (- x 2))
      (char (nth (+ y 3) all) (- x 3))
      )
    '()
    )
  )

(defun check (f x y all)
  (if
    (not (null (ppcre:scan "(XMAS)|(SAMX)" (coerce (funcall f x y all) 'string))))
    1
    0
    )
  )

(defun solve (lst)
  (let
    (
     (acc 0)
     )
    (loop for y from 0 to (1- (length lst)) do
          (loop for x from 0 to (1- (length (first lst))) do
                (setf acc (+ acc
                             (check #'checkHorizontal x y lst)
                             (check #'checkVertical x y lst)
                             (check #'checkDiagonally1 x y lst)
                             (check #'checkDiagonally2 x y lst)
                             ))
                )
          )
    acc
    )
  )

(write (solve data))
(terpri)
