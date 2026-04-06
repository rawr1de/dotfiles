;; -*- lexical-binding: t -*-
;;;; --- XFK MINIBUFFER ESCAPE

;; --- XFK Minibuffer Setup (SMART ESCAPE) ---
(defun my-xfk-minibuffer-setup ()
  "Force Xah Fly Keys into insert mode when entering the minibuffer."
  (when (bound-and-true-p xah-fly-keys)
    (xah-fly-insert-mode-activate)))

(add-hook 'minibuffer-setup-hook #'my-xfk-minibuffer-setup)

;; The Smart Escape Function
(defun my-xfk-smart-escape ()
  "If in minibuffer, abort. Otherwise, go to XFK command mode."
  (interactive)
  (if (minibufferp)
      (abort-recursive-edit)
    (xah-fly-command-mode-activate)))

;; Override XFK's default escape behavior in both maps
(with-eval-after-load 'xah-fly-keys
  (define-key xah-fly-insert-map  (kbd "<escape>") #'my-xfk-smart-escape)
  (define-key xah-fly-command-map (kbd "<escape>") #'my-xfk-smart-escape))


(provide 'my-tab-or-frame-close)
