(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

; (ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun calc (acc ops)
  (if (null ops)
    acc
    (list
      (calc (+ acc (car ops)) (cdr ops))
      (calc (* acc (car ops)) (cdr ops))
      )
  )
)

(defun solve (lst)
  (reduce (lambda (acc x)
            (if
              (not (null
                       (member
                         (first x)
                         (alexandria:flatten (calc
                                               (car (second x))
                                               (cdr (second x))
                                               )
                                             )
                         )
                       )
                   )
              (+ acc (first x))
              acc
              )
            )
          lst
          :initial-value 0
          )
  )

(defun preprocess (input)
  (mapcar (lambda (x)
            (let
              (
               (out '())
               (splitted
                 (uiop:split-string x :separator ":")
                 )
               )
              (push (parse-integer (first splitted)) out)
              (push
                (mapcar #'parse-integer (cdr (uiop:split-string (second splitted) :separator " ")))
                out
                )
              (reverse out)
              )
            ) input)
  )

(write (solve (preprocess data)))
(terpri)
