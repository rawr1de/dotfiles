;; -*- lexical-binding: t -*-
;;;; --- RANGER-STYLE RENAMING 

;; --- XFK Minibuffer Setup ---
(defun my/xfk-minibuffer-setup ()
  "Force Xah Fly Keys into insert mode when entering the minibuffer."
  (when (bound-and-true-p xah-fly-keys)
    (xah-fly-insert-mode-activate)))

(add-hook 'minibuffer-setup-hook #'my/xfk-minibuffer-setup)
(define-key minibuffer-local-map (kbd "<escape>") #'abort-recursive-edit)


;; --- 5. Change Extension (e): Erase extension, leave the dot ---
(defun my-ranger-rename-extension ()
  "Erase extension, leave the dot."
  (interactive)
  (let* ((file (dired-get-filename nil t)) ; nil forces Absolute Path
         (ext  (and file (file-name-extension file)))
         (dir  (and file (file-name-directory file)))
         (base (and file (file-name-base file))))
    (minibuffer-with-setup-hook
        (lambda ()
          (when file
            (delete-region (minibuffer-prompt-end) (point-max))
            (if ext
                ;; Forcefully construct: /path/to/basename.
                (insert (concat dir base "."))
              ;; If no extension, just put the full file path back
              (insert file))))
      (call-interactively 'dired-do-rename))))

(provide 'my-ranger-renaming)
