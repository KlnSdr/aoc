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
    (list buf (length group))
  )
)

(defun count-of (s lst)
  (let ((c 0))
    (loop for e in lst do
      (when (eq e s) (setf c (+ 1 c)))
    )
    c
  )
)

(defun keep-answered-by-all (group)
  (let (
    (res '())
    (len (second group))
    (known '())
    )
    (loop for question in (first group) do
      (when (not(eq question (find question known)))
        (when (eq len (count-of question (first group)))
          (setf res (~ res (list question)))
        )
        (setf known (~ known (list question)))
      )
    )
    res
  )
)

(defun solve (lst)
  (apply #'+ (mapcar #'length (mapcar #'keep-answered-by-all (mapcar #'splitPeople lst))))
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
