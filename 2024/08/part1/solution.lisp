; (let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
;                                         (user-homedir-pathname))))
;   (unless (probe-file quicklisp-setup)
;     (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
;   (load quicklisp-setup))

; (ql:quickload "cl-ppcre")
; (ql:quickload "alexandria")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))
(defvar height (length data))
(defvar width (length (first data)))

(defun hash-table-keys (hash-table)
  (let (keys)
    (maphash (lambda (key value)
               (push key keys))
             hash-table)
    keys)
)

(defun in-bounds (pos)
  (and
    (>= (first pos) 0)
    (>= (second pos) 0)
    (< (first pos) height)
    (< (second pos) width)
  )
)

(defun has-station-at (stations pos)
  (not (null (member pos stations :test #'equal)))
)

(defun add-pos (pos vect)
  (list
    (+ (first pos) (first vect))
    (+ (second pos) (second vect))
  )
)

(defun solve (stations)
  (let
    (
     (antinodes '())
     (freqs (hash-table-keys stations))
     (vect '())
     (currStations '())
     )
    (loop for y from 0 to (1- height) do
          (loop for x from 0 to (1- width) do
                ; (write '================)
                ; (write (list y x))
                ; (terpri)
                (loop for freq in freqs do
                      (setf currStations (gethash freq stations))
                      (loop for pos in currStations do
                            (setf vect (list (- (first pos) y) (- (second pos) x)))
                            (when (and(in-bounds (add-pos pos vect)) (has-station-at currStations (add-pos pos vect)) (not (equal '(0 0) vect)))
                              ; (write vect)
                              ; (terpri)
                              (push (list y x) antinodes)
                            )
                            )
                      )
                )
          )
    (length (remove-duplicates antinodes :test #'equal))
    )
  )

(defun preprocess (input)
  (let
    (
     (stations (make-hash-table))
     (chr nil)
     )
    (loop for y from 0 to (1- height) do
          (loop for x from 0 to (1- width) do
                (setf chr (char (nth y input) x))
                (when (not (string= chr "."))
                  (setf (gethash chr stations) (cons (list y x) (gethash chr stations)))
                  )
                )
          )
    ; (write (gethash #\A stations))
    ; (terpri)
    ; (write (gethash #\0 stations))
    ; (terpri)
    stations
    )
  )

(write (solve (preprocess data)))
(terpri)
