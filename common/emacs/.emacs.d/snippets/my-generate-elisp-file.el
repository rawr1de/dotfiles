(defun my-generate-elisp-file (slug)
  "Generate a brand new, standalone .el file for custom functions."
  (interactive "sFunction Name (without 'my-'): ")
  (let* ((dir (file-truename "~/.dotfiles/common/emacs/.emacs.d/snippets/"))
         (filename (format "my-%s.el" slug))
         (filepath (expand-file-name filename dir)))

    ;; 1. Ensure the target directory actually exists
    (unless (file-exists-p dir)
      (make-directory dir t))

    ;; 2. Open the file (this creates it if it does not exist)
    (find-file filepath)

    ;; 3. If the file is completely empty, inject your skeleton
    (when (= (buffer-size) 0)
      (insert ";; function description, 80 char column rule\n")
      (insert ";; short & concise\n\n")
      (insert ";; prefix functions with:\n")
      (insert ";; my-\n\n\n\n")
      (insert (format "(provide 'my-%s)\n" slug))
      (insert (format ";;; my-%s.el <-- ENDS HERE\n" slug))

      ;; Set mode, save, and position cursor for immediate typing
      (emacs-lisp-mode)
      (save-buffer)
      (goto-char (point-min))
      (search-forward ";; my-")
      (forward-line 2))))
