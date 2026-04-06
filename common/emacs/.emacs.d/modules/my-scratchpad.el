;;;; --- WAYLAND SCRATCHPAD ---

;; Create a dedicated major mode so we can control XFK behavior
(define-derived-mode my-scratchpad-mode text-mode "Scratchpad"
  "Dedicated mode for the Wayland scratchpad.")

(defun my-scratchpad-commit ()
  "Copy only the user's text to the Wayland clipboard and close safely."
  (interactive)
  ;; 1. Jump past the visual separator
  (goto-char (point-min))
  (if (search-forward "---" nil t)
      (forward-line 1)
    (goto-char (point-min)))

  ;; 2. Grab the text
  (let ((text (string-trim (buffer-substring-no-properties (point) (point-max)))))
    ;; 3. The Magic: Pipe to wl-copy asynchronously and force the EOF signal
    (let* ((process-connection-type nil) ; Force a background pipe, not a terminal
           (proc (start-process "wl-copy-proc" nil "wl-copy")))
      (process-send-string proc text)
      (process-send-eof proc))) ; <--- This stops the freeze!

  ;; 4. Nuke the buffer and close the frame
  (set-buffer-modified-p nil)
  (erase-buffer)
  (save-buffers-kill-terminal))

(defun my-spawn-scratchpad ()
  "Setup the floating scratchpad environment."
  (interactive)
  (switch-to-buffer (get-buffer-create "*Scratchpad*"))

  ;; Activate our custom mode
  (my-scratchpad-mode)
(visual-line-mode 1)
  (setq word-wrap t)

  ;; Insert your custom visual header if empty
  (when (= (buffer-size) 0)
    (insert "type text, COPY/CLOSE with [C-c C-c]\n\n---\n\n"))
  (goto-char (point-max))

  (local-set-key (kbd "C-c C-c") #'my-scratchpad-commit)

  ;; Force Insert Mode with a micro-delay to beat the Emacs frame-creation hook
  (run-at-time 0.05 nil #'xah-fly-insert-mode-activate))

(provide 'my-scratchpad)
