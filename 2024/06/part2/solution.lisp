(load "part1Mod.lisp")

(in-package :cl-user)

(require 'uiop)

(defvar data (uiop:read-file-lines "input.txt"))
(defvar height (length data))
(defvar width (length (first data)))

(defun ~ (a b)
  (nconc (copy-list a) b)
  )

(defun list-to-2d-array (lst)
  (make-array (list (length lst)
                    (length (first lst))
                    )
              :initial-contents lst
              )
  )

(defun list-to-array (lst)
  (make-array (list (length lst))
              :initial-contents lst
              )
  )

(defun walk (pos dir)
  (mapcar #'+ pos dir)
  )

(defun is-wall (pos walls)
  (let
    ()
    (loop for i from 0 to (1- (first (array-dimensions walls))) do
          (when
            (and
              (eq (first pos) (first (aref walls i)))
              (eq (second pos) (second (aref walls i)))
              )
            (return-from is-wall T)
            )
          )
    nil
    )
  )

(defun turn (dir)
  (list
    (second dir)
    (* -1 (first dir))
    )
  )

(defun is-loop (steps path)
  (if (< (first (array-dimensions path)) 4)
    nil
    (let
      (
       (maxI (- (first (array-dimensions path)) 2))
       )
      (loop for i from 0 to maxI do
            (when
              (equal (list
                       (list
                         (aref path i 0)
                         (aref path i 1)
                         )
                       (list
                         (aref path (1+ i) 0)
                         (aref path (1+ i) 1)
                         )
                       ) steps)
              (return-from is-loop T)
              )
            )
      nil
      )
    )
  )

(defun contains-loop (walls start)
  (let
    (
     (pos start)
     (dir '(-1 0))
     (nextPos '())
     (visited (list start))
     )
    (loop do
          (setf nextPos (walk pos dir))
          (when
            (or
              (< (first nextPos) 0)
              (< (second nextPos) 0)
              (>= (first nextPos) height)
              (>= (second nextPos) width)
              )
            (return-from contains-loop nil)
            )
          ; (write (car visited))
          ; (write (car (cdr visited)))
          ; (terpri)
          ; (terpri)
          (when (is-loop (list (car visited) (car (cdr visited))) (list-to-2d-array (cdr (cdr visited))))
            (return-from contains-loop T)
            )

          (if (is-wall nextPos walls)
            (setf dir (turn dir))
            (let ()
              (setf pos nextPos)
              (push pos visited)
              )
            )
          )
    )
  )

(defun solve (walls start visitedPositions)
  (let*
    (
     (loopCount 0)
     (arrWalls (list-to-array walls))
     (arrVisitedPositions (list-to-array visitedPositions))
     (arrNewWalls (make-array (1+(length arrWalls)) :initial-contents (~ walls '('(-1 -1)))))
     (wallCount (length arrWalls))
     )

    (map nil
         (lambda (pos)
           (let ()
             (write pos)
             (terpri)
             (setf (aref arrNewWalls wallCount) pos)
             (when (eq T (contains-loop arrNewWalls start))
               (incf loopCount)
               )
             pos
             )
           )
         arrVisitedPositions)
    ; (loop for pos in visitedPositions do
    ;   (write pos)
    ;   (terpri)
    ;   (when (eq T (contains-loop (~ (list pos) walls) start))
    ;     (incf loopCount)
    ;     )
    ; )
    loopCount
    )
)

(defun get-walls-from-line (line)
  (let
    (
     (xs '())
     (start '())
     (maxI (1- (length line)))
     )
    (loop for i from 0 to maxI do
          (when (eq (char line i) #\#)
            (push i xs)
            )
          (when (eq (char line i) #\^)
            (push i start)
            )
          )
    (list
      xs
      start
      )
    )
  )

(defun preprocess (input)
  (let
    (
     (walls '())
     (start '())
     (buf '())
     )
    (loop for y from 0 to (1- (length input)) do
          (setf buf (get-walls-from-line (nth y input)))
          (setf walls
                (~ walls
                   (mapcar
                     (lambda (x) (list y x))
                     (first buf)
                     )
                   )
                )
          (setf start
                (~ start
                   (mapcar
                     (lambda (x) (list y x))
                     (second buf)
                     )
                   )
                )
          )
    (list
      walls
      (first start)
      )
    )
  )

(write
  (apply
    'solve
    (~
      (preprocess data)
      (list (partOne:run))
      )
    )
  )
(terpri)

