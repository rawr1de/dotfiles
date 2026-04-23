;;; --- WAYLAND SCRATCHPAD & CLIPBOARD LOGGER ---
;; Spawns a floating scratchpad buffer. Committing (C-c C-c) copies the text
;; to the Wayland clipboard, permanently logs it to ~/.emacs.d/.scratch_copy,
;; and safely destroys the frame.

(defun my-scratchpad-commit ()
  "Copy text to Wayland clipboard, append to log with timestamp, and close safely."
  (interactive)
  ;; 1. Jump past the visual separator
  (goto-char (point-min))
  (if (search-forward "---" nil t)
      (forward-line 1)
    (goto-char (point-min)))

  ;; 2. Grab the text
  (let* ((text (string-trim (buffer-substring-no-properties (point) (point-max))))
         (log-file (expand-file-name ".scratch_copy" user-emacs-directory)))

    (when (> (length text) 0)
      ;; 3. Write text to the hidden log file with timestamp header (appends to the bottom)
      (let ((timestamp (format-time-string "[%Y-%m-%d] --- [%H:%M:%S]")))
        (write-region (concat timestamp "\n" text "\n\n") nil log-file 'append))

      ;; 4. The Magic: Pipe to wl-copy asynchronously and force EOF
      (let* ((process-connection-type nil)
             (proc (start-process "wl-copy-proc" nil "wl-copy")))
        (process-send-string proc text)
        (process-send-eof proc))))

  ;; 5. Nuke the buffer and close the frame
  (set-buffer-modified-p nil)
  (erase-buffer)
  (save-buffers-kill-terminal))

;; Create a MINOR MODE so we can layer it on top of Org-Mode
(define-minor-mode my-scratchpad-minor-mode
  "Enforces strict rules for the Wayland scratchpad."
  :init-value nil
  :lighter " Scratch"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c C-c") #'my-scratchpad-commit)
            map)
  (when my-scratchpad-minor-mode
    ;; 1. Nuke hard wrapping (no physical line breaks inserted)
    (auto-fill-mode -1)

    ;; 2. Force soft wrapping at the window boundary (breaks cleanly at words)
    (visual-line-mode 1)
    (setq-local word-wrap t)

    ;; 3. Kill whitespace-mode locally to prevent the ugly font color on long lines
    (when (bound-and-true-p whitespace-mode)
      (whitespace-mode -1))

    ;; 4. Kill the vertical fill-column line if it exists
    (when (bound-and-true-p display-fill-column-indicator-mode)
      (display-fill-column-indicator-mode -1))))

(defun my-spawn-scratchpad ()
  "Setup the floating scratchpad environment."
  (interactive)
  (switch-to-buffer (get-buffer-create "*Scratchpad*"))

  ;; 1. Activate Org-Mode FIRST
  (org-mode)

  ;; 2. Apply our custom rules on top
  (my-scratchpad-minor-mode 1)

  ;; 3. THE ISOLATION HACK:
  ;; Tell this specific frame to pretend no other buffers exist.
  (set-frame-parameter nil 'buffer-predicate (lambda (buf) (eq buf (current-buffer))))

  ;; Insert your custom visual header if empty
  (when (= (buffer-size) 0)
    (insert "type text, COPY/CLOSE with [C-c C-c]\n\n---\n\n"))
  (goto-char (point-max))

  ;; Force Insert Mode with a micro-delay to beat the Emacs frame-creation hook
  (run-at-time 0.05 nil (lambda ()
                          (when (fboundp 'xah-fly-insert-mode-activate)
                            (xah-fly-insert-mode-activate)))))

(provide 'my-scratchpad)
;;; my-scratchpad.el ends here
