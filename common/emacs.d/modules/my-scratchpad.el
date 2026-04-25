;;; --- WAYLAND SCRATCHPAD & CLIPBOARD LOGGER ---
;; Spawns a floating scratchpad buffer. Committing (C-c C-c) copies the text
;; to the Wayland clipboard, permanently logs it to ~/.emacs.d/.spad_hist,
;; and safely destroys the frame. Quick access to history via (C-c h).

;;; Code:

;;; --- KEYMAP DEFINITION ---
(defvar my-scratchpad-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") #'my-scratchpad-commit)
    ;; Changed to C-c h to avoid Org-mode babel conflicts.
    ;; C-c <single-letter> is strictly reserved for users/custom tools.
    (define-key map (kbd "C-c h") #'my-scratchpad-open-history)
    map)
  "Keymap for `my-scratchpad-minor-mode'.")


;;; --- CORE FUNCTIONALITY ---

(defun my-scratchpad-commit ()
  "Copy text to Wayland clipboard, append to log with timestamp, and close safely."
  (interactive)
  (goto-char (point-min))
  (if (search-forward "---" nil t)
      (forward-line 1)
    (goto-char (point-min)))

  (let* ((text (string-trim (buffer-substring-no-properties (point) (point-max))))
         (log-file (expand-file-name ".spad_hist" user-emacs-directory)))

    (when (> (length text) 0)
      (let ((timestamp (format-time-string "[%Y-%m-%d] --- [%H:%M:%S]")))
        (write-region (concat timestamp "\n" text "\n\n") nil log-file 'append))

      (with-temp-buffer
        (insert text)
        (call-process-region (point-min) (point-max) "wl-copy" nil nil nil))))

  (set-buffer-modified-p nil)
  (erase-buffer)
  (save-buffers-kill-terminal))

(defun my-scratchpad-open-history ()
  "Instantly open the scratchpad history file, creating it safely if it doesn't exist."
  (interactive)
  (let ((log-file (expand-file-name ".spad_hist" user-emacs-directory)))
    (unless (file-exists-p log-file)
      (write-region ";;; Scratchpad History Initialized\n\n" nil log-file))
    (find-file log-file)))


;;; --- ENVIRONMENT CONSTRAINTS ---

(define-minor-mode my-scratchpad-minor-mode
  "Enforces strict rules for the Wayland scratchpad."
  :init-value nil
  :lighter " Scratch"
  (when my-scratchpad-minor-mode
    (auto-fill-mode -1)
    (visual-line-mode 1)
    (setq-local word-wrap t)
    (when (bound-and-true-p whitespace-mode)
      (whitespace-mode -1))
    (when (bound-and-true-p display-fill-column-indicator-mode)
      (display-fill-column-indicator-mode -1))))


;;; --- FRAME INITIALIZATION ---

(defun my-spawn-scratchpad ()
  "Setup the floating scratchpad environment."
  (interactive)
  (switch-to-buffer (get-buffer-create "*Scratchpad*"))

  (org-mode)
  (my-scratchpad-minor-mode 1)
  (set-frame-parameter nil 'buffer-predicate (lambda (buf) (eq buf (current-buffer))))

  (when (= (buffer-size) 0)
    (insert "type text, COPY/CLOSE: [C-c C-c] | VIEW HISTORY: [C-c h]\n\n---\n\n"))
  (goto-char (point-max))

  (run-at-time 0.05 nil (lambda ()
                          (when (fboundp 'xah-fly-insert-mode-activate)
                            (xah-fly-insert-mode-activate)))))

(provide 'my-scratchpad)
;;; my-scratchpad.el ends here
