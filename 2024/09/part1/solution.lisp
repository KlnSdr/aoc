(let ((quicklisp-setup (merge-pathnames ".quicklisp/setup.lisp"
                                        (user-homedir-pathname))))
  (unless (probe-file quicklisp-setup)
    (error "Quicklisp is not installed. Please install it from https://www.quicklisp.org."))
  (load quicklisp-setup))

; (ql:quickload "cl-ppcre")
(ql:quickload "alexandria")

(require 'uiop)
(defvar data (uiop:read-file-lines "input.txt"))

(defun build-mem-space (files freeSpace)
  (let
    (
     (out '())
     (takeFile T)
     (fileI 0)
     (freeI 0)
     )
    (loop do
          (if takeFile
            (let ()
              (push (make-list (nth fileI files) :initial-element fileI) out)
              (incf fileI)
              )
            (let ()
              (push (make-list (nth freeI freeSpace) :initial-element -1) out)
              (incf freeI)
              )
            )

          (setf takeFile (not takeFile))
          (when (and
                  (>= fileI (length files))
                  (>= freeI (1- (length freeSpace)))
                  )
            (return)
            )
          )
    (alexandria:flatten (reverse (remove-if #'null out)))
    )
  )

(defun solve (files freeSpace)
  (let*
    (
     (memSpace (build-mem-space files freeSpace))
     (l 0)
     (r (1- (length memSpace)))
     (res 0)
     )
    (loop do
          (when (= (nth l memSpace) -1)
            (return)
            )
          (incf l)
          )
    (loop do
          (rotatef (nth l memSpace) (nth r memSpace))

          (incf l)
          (loop do
                (when (= (nth l memSpace) -1)
                  (return)
                  )
                (incf l)
                )

          (decf r)

          (loop do
                (when (not (= (nth r memSpace) -1))
                  (return)
                  )
                (decf r)
                )

          (when (<= r l)
            (return)
            )
          )

    (loop for i from 0 to (1- (length memSpace)) do
          (when (not (= -1 (nth i memSpace)))
            (incf res (* i (nth i memSpace)))
            )
          )
    res
    )
  )

(defun preprocess (input)
  (let
    (
     (line (first input))
     (isFile T)
     (files '())
     (freeSpace '())
     )
    (loop for chr across line do
          (if isFile
            (push (digit-char-p chr) files)
            (push (digit-char-p chr) freeSpace)
            )
          (setf isFile (not isFile))
          )
    (list (reverse files) (reverse freeSpace))
    )
  )

(write (apply 'solve (preprocess data)))
(terpri)
