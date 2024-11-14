(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))
(defvar height (length data))
(defvar width (length (first data)))

(defun cellValue (line x)
  (if (char= #\# (char line x)) 1 0)
)

(defun solve (lst x y)
  (if (>= y height)
     0
  (
   + (cellValue (nth y lst) x) (solve lst (mod (+ 3 x) width) (+ y 1))
   )
  )
)

(write (solve data 0 0))
