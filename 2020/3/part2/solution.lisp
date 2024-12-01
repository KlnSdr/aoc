(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))
(defvar height (length data))
(defvar width (length (first data)))

(defun cellValue (line x)
  (if (char= #\# (char line x)) 1 0)
)

(defun solveWith (lst x y newX newY)
  (if (>= y height)
     0
  (
   + (cellValue (nth y lst) x) (solveWith lst (funcall newX x) (funcall newY y) newX newY)
   )
  )
)

(defun solve (inp funs)
  (apply '* (mapcar (lambda (fun) (solveWith inp 0 0 (first fun) (second fun))) funs))
)

(defvar nextPos (list
  (list (lambda (x) (mod (+ 1 x) width)) (lambda (y) (+ 1 y)))
  (list (lambda (x) (mod (+ 3 x) width)) (lambda (y) (+ 1 y)))
  (list (lambda (x) (mod (+ 5 x) width)) (lambda (y) (+ 1 y)))
  (list (lambda (x) (mod (+ 7 x) width)) (lambda (y) (+ 1 y)))
  (list (lambda (x) (mod (+ 1 x) width)) (lambda (y) (+ 2 y)))
))

(write (solve data nextPos))
