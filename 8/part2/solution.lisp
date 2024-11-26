(require 'uiop)

(defvar data (uiop:read-file-lines "input.txt"))

(defun exec (program)
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
      (setf command (first (nth pcr program)))
      (setf arg (second (nth pcr program)))

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

      (when (= pcr (length program))
        (return-from exec (list T acc))
      )
      (when (not (eq nil (find pcr known :test #'=)))
        (return-from exec (list nil nil))
      )
    )
  )
)

(defun solve (initial)
  (let
    (
     (i 0)
     (current '())
     (res '())
    )
    (loop do
      (setf current (cl:copy-tree initial))

      (when (string= "nop" (first (nth i initial)))
        (setf (nth i current) (list "jmp" (second (nth i initial))))
      )

      (when (string= "jmp" (first (nth i initial)))
        (setf (nth i current) (list "nop" (second (nth i initial))))
      )

      (setf res (exec current))

      (when (eq T (first res))
        (return-from solve (second res))
      )

      (setf i (1+ i))
      (when (= i (length initial))
        (return-from solve nil)
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
