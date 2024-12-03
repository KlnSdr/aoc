(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

(ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun solve (lst)
  (reduce
    (lambda (acc x)
      (+ acc (* (first x) (second x)))
    )
    (mapcar
      (lambda (x)
        (mapcar #'parse-integer (uiop:split-string x :separator ","))
      )
      lst
    )
    :initial-value 0
  )
)

(defun preprocess (lst)
  (let
    (
     (scanner (ppcre:create-scanner "(mul\\(\\d{1,3},\\d{1,3}\\))"))
    )
    (mapcar
      (lambda (x)
        (subseq x 4 (1- (length x)))
      )
      (alexandria:flatten
        (mapcar
          (lambda (x)
            (ppcre:all-matches-as-strings scanner x)
          )
        lst
        )
      )
    )
  )
)

(write (solve (preprocess data)))
(terpri)
