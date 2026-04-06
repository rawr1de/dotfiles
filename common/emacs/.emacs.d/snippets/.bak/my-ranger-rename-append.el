;; -*- lexical-binding: t -*-
;;;; --- RANGER-STYLE RENAMING 

;; --- XFK Minibuffer Setup ---
(defun my/xfk-minibuffer-setup ()
  "Force Xah Fly Keys into insert mode when entering the minibuffer."
  (when (bound-and-true-p xah-fly-keys)
    (xah-fly-insert-mode-activate)))

(add-hook 'minibuffer-setup-hook #'my/xfk-minibuffer-setup)
(define-key minibuffer-local-map (kbd "<escape>") #'abort-recursive-edit)


;; --- 2. Append (a): Keep name, move point right before the dot ---
(defun my-ranger-rename-append ()
  "Keep name, move point right before the dot."
  (interactive)
  (let* ((file (dired-get-filename nil t)) ; nil forces Absolute Path
         (ext  (and file (file-name-extension file))))
    (minibuffer-with-setup-hook
        (lambda ()
          (when file
            ;; 1. Nuke whatever Dired/DWIM suggested
            (delete-region (minibuffer-prompt-end) (point-max))
            ;; 2. Insert the actual full file path
            (insert file)
            ;; 3. If there is an extension, jump back over the ".ext"
            (when ext
              (backward-char (1+ (length ext))))))
      (call-interactively 'dired-do-rename))))


(provide 'my-ranger-renaming)
