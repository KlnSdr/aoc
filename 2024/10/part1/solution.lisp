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

(defun explore-trails-right (y x curr mapData)
  (if (and
        (< (1+ x) width)
        (= (nth (1+ x) (nth y mapData)) (1+ curr))
        )
    (explore-trails y (1+ x) (nth (1+ x) (nth y mapData)) mapData)
    nil
    )
  )

(defun explore-trails-left (y x curr mapData)
  (if (and
        (>= (1- x) 0)
        (= (nth (1- x) (nth y mapData)) (1+ curr))
        )
    (explore-trails y (1- x) (nth (1- x) (nth y mapData)) mapData)
    nil
    )
  )

(defun explore-trails-up (y x curr mapData)
  (if (and
        (>= (1- y) 0)
        (= (nth x (nth (1- y) mapData)) (1+ curr))
        )
    (explore-trails (1- y) x (nth x (nth (1- y) mapData)) mapData)
    nil
    )
  )

(defun explore-trails-down (y x curr mapData)
  (if (and
        (< (1+ y) height)
        (= (nth x (nth (1+ y) mapData)) (1+ curr))
        )
    (explore-trails (1+ y) x (nth x (nth (1+ y) mapData)) mapData)
    nil
    )
  )

(defun explore-trails (y x curr mapData)
  (let
    ()
    ; (when (= curr 9)
    ;   (write (list y x))
    ;   (terpri)
    ; )
    (if (= curr 9)
      (coerce (list y x) 'vector)
      (list
        (explore-trails-right y x curr mapData)
        (explore-trails-left y x curr mapData)
        (explore-trails-up y x curr mapData)
        (explore-trails-down y x curr mapData)
        )
      )
    )
  )

(defun remove-duplicate-arrays (list-of-arrays)
  "Remove duplicate arrays from a list of arrays where each array contains two integers."
  (remove-duplicates list-of-arrays 
                     :test (lambda (a b) (and (arrayp a)
                                              (arrayp b)
                                              (equal (coerce a 'list) 
                                                     (coerce b 'list))))))

(defun solve (lst)
  (let ((trailScore 0))
    (loop for y from 0 to (1- height) do
          (loop for x from 0 to (1- width) do
                (let ((curr (nth x (nth y lst))))
                  (when (= curr 0)
                    (incf trailScore (length (remove-duplicate-arrays (alexandria:flatten (explore-trails y x curr lst)))))
                    )
                  )
                )
          )
    trailScore
    )
  )

(defun preprocess (input)
  (mapcar
    (lambda (line)
      (map 'list #'digit-char-p line)
      )
    input
    )
  )

(write (solve (preprocess data)))
(terpri)
