(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))


;; Ensure the library is loaded
(ql:quickload "cl-ppcre")

;; Import the cl-ppcre package
(use-package :cl-ppcre)

(require 'uiop)

(defvar data (uiop:read-file-lines "input.txt"))
(defvar wordBlacklist (list "bag," "bags," "bag." "bags."))

(defun ~ (a b)
   (reduce #'cons
    a :initial-value b
    :from-end t)
)

(defun has-golden-bag (bag all)
  (if
    (not (equal nil
      (find (list "shiny" "gold") (second bag) :test 'equal)
    ))
    T
    (loop for childKey in (second bag) do
      (when (eq T (has-golden-bag (get-bag childKey all) all))
        (return-from has-golden-bag T)
      )
    )
  )
)

(defun get-bag (key bags)
  (loop for i in bags do
    (when (equal key (first i))
      (return-from get-bag i)
    )
  )
  nil
)

(defun solve (lst)
  (length
    (remove-if-not
      (lambda (v) (eq T v))
      (mapcar
        (lambda (bag)
          (
           has-golden-bag bag lst
          )
        )
        lst
      )
    )
  )
)

(defun to-object (splittedLine)
  (let (
        (out (list (list (first splittedLine) (second splittedLine)) '()))
        (buf '())
    )
    (loop for i in (rest (rest(rest (rest splittedLine)))) do
        (when (string= i "no")
          (return-from to-object out)
        )
        (when
          (and
            (eq nil (find i wordBlacklist :test #'equal))
            (eq nil (cl-ppcre:scan "^[0-9]+$" i))
          )
          (push i buf)
          (when (eq 2 (length buf))
            (push (reverse buf) (second out))
            (setf buf '())
          )
        )
    )
    out
  )
)

(defun preprocess (input)
  (mapcar
    (lambda (line)
      (to-object
        (uiop:split-string line :separator " ")
      )
    )
    input)
)

(write (solve (preprocess data)))
(terpri)
