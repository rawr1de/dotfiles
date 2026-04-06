;; -*- lexical-binding: t -*-
;;;; --- RANGER-STYLE RENAMING

;; --- XFK Minibuffer Setup ---
(defun my/xfk-minibuffer-setup ()
  "Force Xah Fly Keys into insert mode when entering the minibuffer."
  (when (bound-and-true-p xah-fly-keys)
    (xah-fly-insert-mode-activate)))

(add-hook 'minibuffer-setup-hook #'my/xfk-minibuffer-setup)
(define-key minibuffer-local-map (kbd "<escape>") #'abort-recursive-edit)


;; --- 3. Append Absolute End (A): Point at the very end (after extension) ---
(defun my-ranger-rename-append-end ()
  "Point at the very end (after extension)."
  (interactive)
  (let ((file (dired-get-filename nil t))) ; nil forces Absolute Path
    (minibuffer-with-setup-hook
        (lambda ()
          (when file
            ;; Nuke Dired's suggestion and insert the absolute path
            (delete-region (minibuffer-prompt-end) (point-max))
            (insert file)
            ;; Cursor naturally stays at the absolute end
            ))
      (call-interactively 'dired-do-rename))))


(provide 'my-ranger-renaming)
