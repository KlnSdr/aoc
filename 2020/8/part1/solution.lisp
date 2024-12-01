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

(defun solve (lst)
  (let
    (
     (pcr 0)
     (acc 0)
     (known '())
     (command "")
     (arg 0)
    )
    (loop do
      (push pcr known)
      (setf command (first (nth pcr lst)))
      (setf arg (second (nth pcr lst)))

      (when (string= "nop" command)
          (setf pcr (+ pcr 1))
      )
      (when (string= "acc" command)
          (setf pcr (+ pcr 1))
          (setf acc (+ acc arg))
      )
      (when (string= "jmp" command)
          (setf pcr (+ pcr arg))
      )

      (when (or
              (= pcr (length lst))
              (not (eq nil (find pcr known :test #'=)))
            )
        (return-from solve acc)
      )
    )
  )
)

(defun preprocess (input)
  (mapcar
    (lambda (pair)
        (list (first pair) (parse-integer (second pair)))
    )
    (mapcar
      (lambda (instruction)
          (uiop:split-string instruction :separator " ")
      )
      input
    )
  )
)

(write (solve (preprocess data)))
(terpri)
