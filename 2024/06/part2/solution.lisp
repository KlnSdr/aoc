(load "part1Mod.lisp")

(in-package :cl-user)

(require 'uiop)

(defvar data (uiop:read-file-lines "input.txt"))
(defvar height (length data))
(defvar width (length (first data)))

(defun ~ (a b)
  (reduce #'cons
          a
          :initial-value b
          :from-end t)
  )

(defun walk (pos dir)
  (mapcar #'+ pos dir)
  )

(defun is-wall (pos walls)
  (not (eq nil (member pos walls :test #'equal)))
  )

(defun turn (dir)
  (list
    (second dir)
    (* -1 (first dir))
    )
  )

(defun is-loop (path)
  (if (< (length path) 4)
    nil
    (let
      (
       (pastPath (cdr (cdr path)))
       (toFind (list (car path) (car (cdr path))))
       )
      (loop for i from 0 to (- (length pastPath) 2) do
            (when
              (equal (list (nth i pastPath)
                           (nth (1+ i) pastPath)) toFind)
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
          (when (is-loop visited)
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
  (let
    ((loopCount 0))
    (loop for pos in visitedPositions do
      (write pos)
      (terpri)
      (when (eq T (contains-loop (~ (list pos) walls) start))
        (incf loopCount)
        )
    )
    loopCount
    )
  )

(defun get-walls-from-line (line)
  (let
    (
     (xs '())
     (start '())
     )
    (loop for i from 0 to (1- (length line)) do
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

