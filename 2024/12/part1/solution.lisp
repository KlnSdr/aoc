(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

; (ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))
(defvar height (length data))
(defvar width (length (first data)))

(defun arr-equal (a b)
  (and
    (arrayp a)
    (arrayp b)
    (equal (coerce a 'list) 
           (coerce b 'list))
    )
  )

(defun remove-duplicate-arrays (list-of-arrays)
  (remove-duplicates
    list-of-arrays 
    :test #'arr-equal
    )
  )

(defun list-to-array (lst)
  (make-array
    (list
      (length lst))
    :initial-contents lst
    )
  )

(defun list-to-2d-array (lst)
  (make-array
    (list
      (length lst)
      (length (first lst))
      )
    :initial-contents lst
    )
  )

(defun is-known-spot (y x knownSpots)
  (borders (vector y x) knownSpots)
  )

(defun borders (pos knownSpots)
  (not (null
         (find
           pos
           knownSpots
           :test #'arr-equal
           )
         )
       )
  )

(defvar *knownSpots* '())

(defun discover-for (y x farmMap target)
  (if (or
        (>= x width)
        (>= y height)
        (< x 0)
        (< y 0)
        (null (eq (aref farmMap y x) target))
        (eq T (is-known-spot y x *knownSpots*))
        )
    nil
    (let ()
      (setq *knownSpots* (cons (vector y x) *knownSpots*))
      (remove-duplicate-arrays
        (alexandria:flatten
          (list
            (vector y x)
            (discover-for (1+ y) x farmMap target)
            (discover-for y (1+ x) farmMap target)
            (discover-for (1- y) x farmMap target)
            (discover-for y (1- x) farmMap target)
            )
          )
        )
      )
    )
  )

(defun pos-add (a b)
  (vector
    (+ (aref a 0) (aref b 0))
    (+ (aref a 1) (aref b 1))
    )
  )

(defun area-of (region)
  (length region)
  )

(defun perimiter-of (region)
  (let
    ((perimiter 0))
    (loop for pos in region do
          (when (not(borders (pos-add pos #(1 0)) region))
            (incf perimiter)
            )
          (when (not(borders (pos-add pos #(0 1)) region))
            (incf perimiter)
            )
          (when (not(borders (pos-add pos #(-1 0)) region))
            (incf perimiter)
            )
          (when (not(borders (pos-add pos #(0 -1)) region))
            (incf perimiter)
            )
          )
    perimiter
    )
  )

(defun solve (lst)
  (let
    (
     (regions '())
     (knownSpots '())
     )
    (loop for y from 0 to (1- height) do
          (loop for x from 0 to (1- width) do
                (setq *knownSpots* knownSpots)
                (push (discover-for y x lst (aref lst y x)) regions)
                (loop for pos in (first regions) do
                      (push pos knownSpots)
                      )
                )
          )
    (reduce
      (lambda (acc x)
        (+ 
          acc
          (*
            (area-of x)
            (perimiter-of x)
            )
          )
        )
      (remove-if #'null regions)
      :initial-value 0
      )
    )
  )

(defun preprocess (input)
  (list-to-2d-array
    (mapcar
      (lambda (line)
        (map 'list
             (lambda (x) x)
             line
             )
        )
      input
      )
    )
  )

(write (solve (preprocess data)))
(terpri)
