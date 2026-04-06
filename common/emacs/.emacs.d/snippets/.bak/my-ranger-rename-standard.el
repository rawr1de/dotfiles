;; -*- lexical-binding: t -*-
;;;; --- RANGER-STYLE RENAMING (FIXED & PATH-AWARE)


;; 5. Change Extension (e): Erase extension, keep the dot
;; (defun my-ranger-rename-extension ()
  ;; (interactive)
  ;; (let* ((file (dired-get-filename t))
         ;; (ext (file-name-extension file)))
    ;; (if (not ext)
        ;; (dired-do-rename)
      ;; (my-ranger-rename-get-dest (concat (file-name-base file) ".")))))




;; -*- lexical-binding: t -*-
;;;; --- RANGER-STYLE RENAMING (TESTING: STANDARD RENAME)

;; --- XFK Minibuffer Setup ---
(defun my/xfk-minibuffer-setup ()
  "Force Xah Fly Keys into insert mode when entering the minibuffer."
  (when (bound-and-true-p xah-fly-keys)
    (xah-fly-insert-mode-activate)))

(add-hook 'minibuffer-setup-hook #'my/xfk-minibuffer-setup)
(define-key minibuffer-local-map (kbd "<escape>") #'abort-recursive-edit)

;; --- 1. Standard (r): Erase base name, keep .extension, point before dot ---
(defun my-ranger-rename-standard ()
  "Erase base name, keep path and .extension, point before dot."
  (interactive)
  (let* ((file (dired-get-filename t t))
         (ext (and file (file-name-extension file))))
    (minibuffer-with-setup-hook
        (lambda ()
          ;; Grab the absolute path Dired just put in the prompt
          (let* ((current-path (buffer-substring-no-properties (minibuffer-prompt-end) (point-max)))
                 (dir (file-name-directory current-path)))
            (when dir
              ;; Clear it and rebuild it exactly how we want
              (delete-region (minibuffer-prompt-end) (point-max))
              (if ext
                  (progn
                    (insert dir "." ext)
                    (backward-char (1+ (length ext))))
                (insert dir)))))
      (call-interactively 'dired-do-rename))))

(provide 'my-ranger-renaming)
