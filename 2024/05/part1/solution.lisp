(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun split-list-at (list index)
  (let ((left nil)
        (right list))
    (dotimes (i index (values (reverse left) right))
      (push (pop right) left))))

(defun check-rule (rule line)
  (let
    (
     (posFirst (position (first rule) line))
     (posSecond (position (second rule) line))
     )
    (if
      (or
        (eq nil posFirst)
        (eq nil posSecond)
        )
      T
      (<= posFirst posSecond)
      )
    )
  )

(defun is-valid-line (rules line)
  (=(length
      (remove-if (lambda (x) (eq nil x))
                 (mapcar
                   (lambda (rule)
                     (check-rule rule line)
                     )
                   rules
                   )
                 )) (length rules))
  )

(defun solve (lst)
  (let
    (
     (rules (first lst))
     (lines (second lst))
     )
    (reduce (lambda (acc x)
              (if (is-valid-line rules x)
                (+ acc (nth (/ (- (length x) 1) 2) x))
                acc
                )
              ) lines :initial-value 0)
    )
  )

(defun preprocess (lst)
  (multiple-value-bind (left right)
    (split-list-at
      lst
      (position "" lst :test #'string=)
      )
    (list
      (mapcar (lambda (x)
                (mapcar #'parse-integer (uiop:split-string x :separator "|"))
                ) left)
      (mapcar (lambda (x)
                (mapcar #'parse-integer (uiop:split-string x :separator ","))
                ) (cdr right)))
    )
  )

(write (solve (preprocess data)))
(terpri)
