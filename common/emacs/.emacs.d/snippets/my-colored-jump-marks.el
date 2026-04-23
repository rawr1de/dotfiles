;;;; --- COLORED JUMP MARKS (CJM) [SPC 0 // 0 // SPC 9]
;; Sets up to 3 persistent, colored markers (Green, Yellow, Pink) per buffer.
;; Press 'SPC 0' to set a mark, '0' to cycle through them, 'SPC 9' to clear.
;; Automatically manages a "first-in, first-out" queue for the 3 visual marks.

(defvar-local my-cycle-marks nil "List of active markers for this buffer")
(defvar-local my-cycle-overlays nil "List of active overlays for this buffer")
(defvar-local my-cycle-index 0 "Current position in the cycle")

(defun my-set-cycle-mark ()
  "Set a persistent colored mark at point"
  (interactive)
  (let* ((max-marks 3)
         (colors '("green" "yellow" "hot pink"))
         (new-marker (point-marker))
         (new-ov (make-overlay (point) (1+ (point)))))

    ;; Apply the color based on the current number of marks
    (overlay-put new-ov 'face
                 `(:background ,(nth (length my-cycle-marks) colors)
                   :foreground "white"))

    ;; Add to the front of our lists
    (push new-marker my-cycle-marks)
    (push new-ov my-cycle-overlays)

    ;; If we hit 4 marks, remove the oldest (the last one in the list)
    (when (> (length my-cycle-marks) max-marks)
      (let ((old-m (car (last my-cycle-marks)))
            (old-ov (car (last my-cycle-overlays))))
        (set-marker old-m nil)
        (delete-overlay old-ov)
        (setq my-cycle-marks (butlast my-cycle-marks))
        (setq my-cycle-overlays (butlast my-cycle-overlays))))

    (message "Mark %d set (Total: %d)"
             (length my-cycle-marks)
             (length my-cycle-marks))))

(defun my-jump-cycle-mark ()
  "Jump to the next mark in the cycle"
  (interactive)
  (if (not my-cycle-marks)
      (message "No marks set in this buffer")
    (let ((target (nth my-cycle-index my-cycle-marks)))
      (goto-char (marker-position target))
      (message "Jumped to mark %d" (1+ my-cycle-index))
      ;; Increment index for next press, wrap around if at the end
      (setq my-cycle-index
            (% (1+ my-cycle-index) (length my-cycle-marks))))))

(defun my-clear-all-cycle-marks ()
  "Remove all colored jump marks from the current buffer"
  (interactive)
  (mapc 'delete-overlay my-cycle-overlays)
  (dolist (m my-cycle-marks) (set-marker m nil))
  (setq my-cycle-marks nil
        my-cycle-overlays nil
        my-cycle-index 0)
  (message "Buffer marks cleared"))

(provide 'my-colored-jump-marks)
;; my-colored-jump-marks.el --> END OF FILE
