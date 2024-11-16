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

(defun ~ (a b)
   (reduce #'cons
    a
    :initial-value b
    :from-end t)
)

(defun splitPeople (group)
  (let ((buf '()))
    (loop for person in group do
      (loop for q in (coerce person 'list) do
        (push q buf)
      )
    )
    buf
  )
)

(defun solve (lst)
  (apply #'+ (mapcar #'length (mapcar #'remove-duplicates (mapcar #'splitPeople lst))))
)

(defun toGroups (input)
  (let ((groups '()) (current '()))
    (loop for person in input do
      (if (string= "" person)
      (when current
        (setf groups (~ groups (list current)))
        (setf current '())
      )
      (push person current)
      )
    )
    groups
  )
)

(defun preprocess (input)
  (toGroups input)
)

(write (solve (preprocess data)))
(terpri)
