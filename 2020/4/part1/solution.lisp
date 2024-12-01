(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))
(defvar requiredKeys '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"))

(defun hasKey (passport key)
  (= (length (remove-if-not (lambda (keyVal) (string= key (first keyVal))) passport)) 1)
)

(defun isValidPassport (passport)
  (= (length (remove-if-not (lambda (v) (eq v T)) (mapcar (lambda (k) (hasKey passport k)) requiredKeys))) (length requiredKeys))
)

(defun solve (lst)
  (length (remove-if-not (lambda (p) (eq p T)) (mapcar #'isValidPassport lst)))
)

(defun ~ (a b)
   (reduce #'cons
    a
    :initial-value b
    :from-end t)
)

(defun extractPassports (input)
  (let ((passports '()) (currentPassport '()))
    (
     dolist (line input)
     (if (string= line "")
       (
        when currentPassport
            (push currentPassport passports)
            (setf currentPassport '())
        )
       (push line currentPassport)
      )
    )
    (
     when currentPassport (push currentPassport passports)
     )
    passports
  )
)

(defun normalizePassport (passport)
  (let ((normalized '()))
    ; split lines containing multiple values
    (dolist (line passport)
      (setf normalized (~ (uiop:split-string line :separator " ") normalized))
    )
    ; split into key-value pairs
    (mapcar (lambda (e) (uiop:split-string e :separator ":")) normalized)
  )
)

(defun preprocess (input)
  (mapcar #'normalizePassport (extractPassports input))
)

(write (solve (preprocess data)))
(terpri)
