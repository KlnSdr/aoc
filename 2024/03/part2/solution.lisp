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
  (let*
    (
     (scanner (ppcre:create-scanner "(mul\\(\\d{1,3},\\d{1,3}\\))|(do\\(\\))|(don't\\(\\))"))
     (
      filtered
      (alexandria:flatten
        (mapcar
          (lambda (x)
            (ppcre:all-matches-as-strings scanner x)
            )
          lst
          )
        )
      )
     (out '())
     (enabled T)
     )
    (loop for i in filtered do
          (when (string= i "do()")
            (setf enabled T)
          )
          (when (string= i "don't()")
            (setf enabled nil)
          )
          (when (and (eq T enabled) (string= "mul" (subseq i 0 3)))
            (push i out)
          )
      )
    (mapcar
      (lambda (x)
        (subseq x 4 (1- (length x)))
      )
      out)
    )
  )

(write (solve (preprocess data)))
(terpri)
