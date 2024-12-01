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
(defvar chr2Num
  (list
    (list "F" "0")
    (list "B" "1")
    (list "L" "0")
    (list "R" "1")
  )
)

(defun solve (lst)
  (reduce #'max
  (mapcar (lambda (pair)
    (
     +
     (* 8 (first pair))
     (second pair)
     )
  ) lst)
  )
)

(defun replaceCharsWithDigits (val)
  (let ((newVal val))
    (loop for n in chr2Num
    do (setf newVal (cl-ppcre:regex-replace-all (first n) newVal (second n)))
    )
  newVal
  )
)

(defun split-at (val index)
    (list (subseq val 0 index) (subseq val index))
)

(defun replaceStringsWithNums (val)
  (split-at (replaceCharsWithDigits val) 7)
)

(defun preprocess (input)
  (mapcar (lambda (pair)
    (list (parse-integer (first pair) :radix 2) (parse-integer (second pair) :radix 2))
  ) (mapcar #'replaceStringsWithNums input))
)

(write (solve (preprocess data)))
(terpri)
