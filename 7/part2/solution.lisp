(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))


(ql:quickload "cl-ppcre")

(use-package :cl-ppcre)
(require 'uiop)

(defvar data (uiop:read-file-lines "input.txt"))
(defvar wordBlacklist (list "bag," "bags," "bag." "bags."))

(defun ~ (a b)
   (reduce #'cons
    a :initial-value b
    :from-end t)
)

(defun get-bag (key bags)
  (loop for i in bags do
    (when (equal key (first i))
      (return-from get-bag i)
    )
  )
  nil
)

(defun child-bag-count (parent allBags)
  (let
    (
     (sum 0)
     (range '())
     (j 0)
    )
    (when (eq nil (second parent))
      (return-from child-bag-count 0)
    )

    (loop for i in (second parent) do
          (push j range)
          (setf j (+ 1 j))
    )
    (setf range (reverse range))

    (loop for i in range do
        (setf sum (+
                    sum
                    (nth i (third parent))
                    (*
                      (nth i (third parent))
                      (child-bag-count (get-bag (nth i (second parent)) allBags) allBags)
                    )
                  )
        )
    )
    sum
  )
)

(defun solve (lst)
  (let
    (
     (goldBag (get-bag (list "shiny" "gold") lst))
     )
    (child-bag-count goldBag lst)
  )
)

(defun to-object (splittedLine)
  (let (
        (out (list (list (first splittedLine) (second splittedLine)) '() '()))
        (buf '())
        (counts "")
    )
    (loop for i in (rest (rest(rest (rest splittedLine)))) do
        (when (string= i "no")
          (return-from to-object out)
        )
        (when (not (eq nil (cl-ppcre:scan "^[0-9]+$" i)))
          (setf counts (parse-integer i))
        )
        (when
          (and
            (eq nil (find i wordBlacklist :test #'equal))
            (eq nil (cl-ppcre:scan "^[0-9]+$" i))
          )
          (push i buf)
          (when (eq 2 (length buf))
            (push (reverse buf) (second out))
            (push counts (third out))
            (setf buf '())
            (setf counts '())
          )
        )
    )
    out
  )
)

(defun preprocess (input)
  (mapcar
    (lambda (line)
      (to-object
        (uiop:split-string line :separator " ")
      )
    )
    input)
)

(write (solve (preprocess data)))
(terpri)
