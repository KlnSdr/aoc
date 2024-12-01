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
(defvar requiredKeys '("byr" "iyr" "eyr" "hgt" "hcl" "ecl" "pid"))
(defvar validators
  (list
    (list "byr" (lambda (val)
          (let ((x (parse-integer val)))
            (if (and (>= x 1920) (<= x 2002))
              T
              Nil
            )
          )
        )
     )
    (list "iyr" (lambda (val)
          (let ((x (parse-integer val)))
            (if (and (>= x 2010) (<= x 2020))
              T
              Nil
            )
          )
        )
     )
    (list "eyr" (lambda (val)
          (let ((x (parse-integer val)))
            (if (and (>= x 2020) (<= x 2030))
              T
              Nil
            )
          )
        )
     )
    (list "hgt" (lambda (val)
          (let
            (
                (cm (uiop:split-string val :separator "cm"))
                (in (uiop:split-string val :separator "in"))
            )
            (if (= 3 (length cm))
              (validateCM (first cm))
              (if (= 3 (length in))
                (validateIN (first IN))
                Nil
              )
            )
          )
        )
     )
    (list "hcl" (lambda (val)
        (not (null (cl-ppcre:scan "^#[0-9a-fA-F]{6}$" val)))
    ))
    (list "ecl" (lambda (val)
      (not (eq (find val '("amb" "blu" "brn" "gry" "grn" "hzl" "oth") :test #'string=) nil))
    ))
    (list "pid" (lambda (val)
        (not (null (cl-ppcre:scan "^[0-9]{9}$" val)))
    ))
    )
)

(defun validateCM (val)
  (let ((x (parse-integer val)))
    (and (>= x 150) (<= x 193))
  )
)

(defun validateIN (val)
  (let ((x (parse-integer val)))
    (and (>= x 59) (<= x 76))
  )
)

(defun hasKey (passport key)
  (= (length (remove-if-not (lambda (keyVal) (string= key (first keyVal))) passport)) 1)
)

(defun hasRequiredKeys (passport)
  (if (= (length (remove-if-not (lambda (v) (eq v T)) (mapcar (lambda (k) (hasKey passport k)) requiredKeys))) (length requiredKeys))
    passport
    nil
    )
)

(defun getValue (passport key)
  (loop for keyValue in passport
        when (string= (first keyValue) key)
        do (return-from getValue (second keyValue))
  )
)

(defun validateValues (passport)
  (= (length (remove-if-not (lambda (v) (eq v T)) (mapcar (lambda (val) (funcall (second val) (getValue passport (first val)))) validators))) (length validators))
)

(defun solve (lst)
  (length (remove-if-not (lambda (v) (eq v T)) (mapcar #'validateValues (remove-if (lambda (p) (eq p nil)) (mapcar #'hasRequiredKeys lst)))))
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
  (let ((normalized '())) ; split lines containing multiple values
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
