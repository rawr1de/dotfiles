;; -*- lexical-binding: t -*-
;;;; --- RANGER-STYLE RENAMING & DUPLICATING

;; --- XFK Minibuffer Setup (SMART ESCAPE) ---
(defun my-xfk-minibuffer-setup ()
  "Force xah-fly-keys insert-mode when entering the minibuffer"
  (when (bound-and-true-p xah-fly-keys)
    (xah-fly-insert-mode-activate)))

(add-hook 'minibuffer-setup-hook #'my-xfk-minibuffer-setup)

;; The Smart Escape Function
(defun my-xfk-smart-escape ()
  "If in minibuffer, abort. Otherwise, go to XFK command-mode"
  (interactive)
  (if (minibufferp)
      (abort-recursive-edit)
    (xah-fly-command-mode-activate)))

;; Override XFK's default escape behavior in both maps
(with-eval-after-load 'xah-fly-keys
  (define-key xah-fly-insert-map  (kbd "<escape>") #'my-xfk-smart-escape)
  (define-key xah-fly-command-map (kbd "<escape>") #'my-xfk-smart-escape))


;; --- The 5 Renaming Functions ---
;; NOTE: Use C-u before any command to COPY (duplicate) instead of rename.

;; 1. Standard (r): Erase base name, keep .extension, point before dot
(defun my-ranger-rename-standard ()
  "Erase base name, keep path and .extension. C-u to duplicate"
  (interactive)
  (let* ((file (dired-get-filename t t))
         (ext (and file (file-name-extension file))))
    (minibuffer-with-setup-hook
        (lambda ()
          ;; SLEDGEHAMMER: Force insert mode AFTER all other setup hooks finish
          (run-with-idle-timer 0 nil #'my-xfk-minibuffer-setup)
          (let* ((current-path (buffer-substring-no-properties (minibuffer-prompt-end) (point-max)))
                 (dir (file-name-directory current-path)))
            (when dir
              (delete-region (minibuffer-prompt-end) (point-max))
              (if ext
                  (progn
                    (insert dir "." ext)
                    (backward-char (1+ (length ext))))
                (insert dir)))))
      ;; Let-bind disables completion frameworks for THIS command only
      (let ((read-file-name-function #'read-file-name-default)
            (completing-read-function #'completing-read-default))
        (call-interactively (if current-prefix-arg 'dired-do-copy 'dired-do-rename))))))

;; 2. Append (a): Keep name, move point right before the dot
(defun my-ranger-rename-append ()
  "Keep name, move point right before the dot. C-u to duplicate"
  (interactive)
  (let* ((file (dired-get-filename nil t)) ; nil forces Absolute Path
         (ext  (and file (file-name-extension file))))
    (minibuffer-with-setup-hook
        (lambda ()
          (run-with-idle-timer 0 nil #'my-xfk-minibuffer-setup)
          (when file
            (delete-region (minibuffer-prompt-end) (point-max))
            (insert file)
            (when ext
              (backward-char (1+ (length ext))))))
      (let ((read-file-name-function #'read-file-name-default)
            (completing-read-function #'completing-read-default))
        (call-interactively (if current-prefix-arg 'dired-do-copy 'dired-do-rename))))))

;; 3. Append Absolute End (A): Point at the very end (after extension)
(defun my-ranger-rename-append-end ()
  "Point at the very end (after extension). C-u to duplicate"
  (interactive)
  (let ((file (dired-get-filename nil t)))
    (minibuffer-with-setup-hook
        (lambda ()
          (run-with-idle-timer 0 nil #'my-xfk-minibuffer-setup)
          (when file
            (delete-region (minibuffer-prompt-end) (point-max))
            (insert file)))
      (let ((read-file-name-function #'read-file-name-default)
            (completing-read-function #'completing-read-default))
        (call-interactively (if current-prefix-arg 'dired-do-copy 'dired-do-rename))))))

;; 4. Insert Beginning (i): Point at the start of the filename
(defun my-ranger-rename-prepend ()
  "Point at the start of the filename. C-u to duplicate."
  (interactive)
  (let* ((file (dired-get-filename nil t))
         (dir  (and file (file-name-directory file))))
    (minibuffer-with-setup-hook
        (lambda ()
          (run-with-idle-timer 0 nil #'my-xfk-minibuffer-setup)
          (when file
            (delete-region (minibuffer-prompt-end) (point-max))
            (insert file)
            (goto-char (+ (minibuffer-prompt-end) (length dir)))))
      (let ((read-file-name-function #'read-file-name-default)
            (completing-read-function #'completing-read-default))
        (call-interactively (if current-prefix-arg 'dired-do-copy 'dired-do-rename))))))

;; 5. Change Extension (e): Erase extension, leave the dot
(defun my-ranger-rename-extension ()
  "Erase extension, leave the dot. C-u to duplicate"
  (interactive)
  (let* ((file (dired-get-filename nil t))
         (ext  (and file (file-name-extension file)))
         (dir  (and file (file-name-directory file)))
         (base (and file (file-name-base file))))
    (minibuffer-with-setup-hook
        (lambda ()
          (run-with-idle-timer 0 nil #'my-xfk-minibuffer-setup)
          (when file
            (delete-region (minibuffer-prompt-end) (point-max))
            (if ext
                (insert (concat dir base "."))
              (insert file))))
      (let ((read-file-name-function #'read-file-name-default)
            (completing-read-function #'completing-read-default))
        (call-interactively (if current-prefix-arg 'dired-do-copy 'dired-do-rename))))))

(provide 'my-ranger-renaming)
;;; my-ranger-renaming.el ends here
