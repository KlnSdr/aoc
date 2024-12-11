(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

; (ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun hash-table-keys (hash-table)
  (let (keys)
    (maphash (lambda (key value) (push key keys)) hash-table)
    keys
    )
  )

(defun numdigits (n)
  (if (= n 0)
    1
    (1+ (floor (log (abs n) 10)))
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
    (list (* 2024 stone))
    )
  )

(defun solve (input)
  (let
    (
     (oldStones input)
     (newStones input)
     (keys '())
     )
    (loop for i from 1 to 75 do
          (setf oldStones newStones)
          (setf newStones (make-hash-table))
          (setf keys (hash-table-keys oldStones))

          (loop for stone in keys do
                (let
                  (
                   (newStoneValues (applyRules stone))
                   )
                  (loop for newStoneValue in newStoneValues do
                        (if (null (gethash newStoneValue newStones))
                          (setf (gethash newStoneValue newStones) (gethash stone oldStones))
                          (setf
                            (gethash newStoneValue newStones)
                            (+ (gethash stone oldStones) (gethash newStoneValue newStones))
                            )
                          )
                        )
                  )
                )

          )
    (reduce
      (lambda (acc key)
        (+ acc (gethash key newStones))
        )
      (hash-table-keys newStones)
      :initial-value 0
      )
    )
  )

(defun preprocess (input)
  (let
    (
     (stonesMap (make-hash-table))
     )
    (mapcar
      (lambda (x)
        (let
          ((int (parse-integer x)))
          (setf (gethash int stonesMap) 1)
          )
        )
      (uiop:split-string (first input) :separator " ")
      )
    stonesMap
    )
  )

(write (solve (preprocess data)))
(terpri)
