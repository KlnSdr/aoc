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

(defun get-file-size (memSpace index)
  (let
    (
     (id (aref memSpace index))
     (size 0)
     )
    (loop do
      (incf size)

      (decf index)
      (when (or (< index 0) (not (= id (aref memSpace index))))
        (return)
      )
    )
    size
  )
)

(defun get-free-space-size (memSpace index)
  (let
    (
     (size 0)
     )
    (loop do
      (incf size)

      (incf index)
      (when (or (> index (1-(length memSpace))) (not (= -1 (aref memSpace index))))
        (return)
      )
    )
    size
  )
)

(defun get-first-fitting-free-space (memSpace size)
  (let
    (
     (index 0)
     (firstIndex -1)
     )

    (loop do
          (if (= -1 (aref memSpace index))
            (let (
                  (spaceSize (get-free-space-size memSpace index))
                  )
              (when (>= spaceSize size)
                (setf firstIndex index)
                (return)
                )
              (incf index spaceSize)
              )
            (incf index)
            )

          (when (>= index (length memSpace))
            (return)
            )
          )

    firstIndex
    )
)

(defun move-file (fromIndex toIndex size memSpace)
  (loop for i from 0 to (1- size) do
      (rotatef (aref memSpace (- fromIndex i)) (aref memSpace (+ toIndex i)))
  )
)

(defun solve (files freeSpace)
  (let*
    (
     (memSpace (apply #'vector (build-mem-space files freeSpace)))
     (l 0)
     (r (1- (length memSpace)))
     (fileSize 0)
     (firstFreeIndex -1)
     (res 0)
     )

    (loop do
          (when (not (= (aref memSpace r) -1))
            (return)
            )
          (decf r)
          )

    (loop do
          (setf fileSize (get-file-size memSpace r))
          (setf firstFreeIndex (get-first-fitting-free-space memSpace fileSize))

          (when (and (not (= firstFreeIndex -1)) (< firstFreeIndex r))
            (move-file r firstFreeIndex fileSize memSpace)
          )

          (decf r fileSize)

          (loop do
                (when (or (< r 0) (not (= (aref memSpace r) -1)))
                  (return)
                  )
                (decf r)
                )

          (when (or (<= r l) (<= r 0))
            (return)
            )
          )

    (loop for i from 0 to (1- (length memSpace)) do
          (when (not (= -1 (aref memSpace i)))
            (incf res (* i (aref memSpace i)))
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
