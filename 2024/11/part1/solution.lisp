(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

; (ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun numdigits (n)
  (if (< -10 n 10)
    1
    (1+ (numdigits (truncate n 10)))
    )
  )

(defun split-even-integer (number)
  (let* ((num-digits (truncate (log number 10)))
         (length (1+ num-digits)))
    (if (evenp length)
      (let*
        (
         (half-length (/ length 2))
         (divisor (expt 10 half-length))
         (part1 (truncate number divisor))
         (part2 (mod number divisor))
         )
        (list part1 part2)
        )
      (error "The number does not have an even number of digits.")
      )
    )
  )

(defun applyRules (stone)
  (if (= stone 0)
    '(1)
    (applyRules2 stone)
    )
  )

(defun applyRules2 (stone)
  (if (= 0(mod (numdigits stone) 2))
    (split-even-integer stone)
    (* 2024 stone)
    )
  )

(defun blink(stones)
  (alexandria:flatten (mapcar #'applyRules stones))
  )

(defun solve (lst)
  (let
    ((stones lst))
    (loop for i from 1 to 25 do
          (setf stones (blink stones))
          )
    (length stones)
    )
  )

(defun preprocess (input)
  (mapcar  #'parse-integer (uiop:split-string (first input) :separator " "))
  )

(write (solve (preprocess data)))
(terpri)
