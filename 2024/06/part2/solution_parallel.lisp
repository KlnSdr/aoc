(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

(ql:quickload "bt-semaphore")

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
             (setf (aref arrNewWalls wallCount) pos)
             (when (eq T (contains-loop arrNewWalls start))
               (incf loopCount)
               )
             pos
             )
           )
         arrVisitedPositions)
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

(defun split-into-n-lists (lst n)
  (let* ((len (length lst))
         (chunk-size (floor len n))
         (result '()))
    (loop for i from 0 to (1- n) do
          (let ((start (* i chunk-size))
                (end (* (+ i 1) chunk-size)))
            (push (subseq lst start end) result)))

    (nreverse result)))

(defvar processedData (preprocess data))
(defvar possiblePositions (partOne:run))
(defvar threadCount 12)
(defvar *counter* 0)
(defvar *mutex* (sb-thread:make-mutex)) ; Create a mutex

(defun run ()
  (let
    (
     (threads '())
     (parts (split-into-n-lists possiblePositions threadCount))
     )
    (loop for i from 1 to threadCount do
          (let ((index i))
          (push (sb-thread:make-thread
                  (lambda () 
                    (let*
                      (
                       (val
                         (apply
                           'solve
                           (~
                             processedData
                             (list (nth (1- index) parts))
                             )
                           )
                         )
                       )
                      (sb-thread:with-mutex (*mutex*)         ; Acquire the mutex before modifying *counter*
                        (incf *counter* val))
                      )
                    )
                ) ; Each thread increments counter 1000 times
                threads)
          )
    )
    (loop for thread in threads do
          (sb-thread:join-thread thread))
    (write *counter*)
    (terpri)
    )
  )
(run)
