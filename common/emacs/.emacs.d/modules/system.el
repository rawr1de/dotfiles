(setq gc-cons-threshold 100000000)
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))

(setq use-short-answers t)
(setq inhibit-startup-message t
      ring-bell-function 'ignore
      scroll-preserve-screen-position t
      scroll-step 1
      create-lockfiles nil
      case-fold-search t
      read-quoted-char-radix 10)
;; controls number system (base) numerical code
;; Default (8): Octal (0-7) type C-q 141, get "a"
;; Value (10): Decimal type C-q 97 get "a"
;; Value (16): Hexadecimal type C-q 61 get "a"
;; enable recent files tracking
      (recentf-mode 1)
;; maximum number of saved items
      (setq recentf-max-saved-items 50)

;; FORCE kill-buffer to quit without saving
(defun my-kill-buffer-no-confirm ()
  "Kill buffer without save prompt"
  (interactive)
  (set-buffer-modified-p nil)
  (kill-buffer))

(use-package ibuffer
  :ensure nil
  :bind (:map ibuffer-mode-map
         ("z" . (lambda () (interactive) (ibuffer-switch-to-saved-filter-groups "default"))))
  :config
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Musk" (filename . "Musk/"))
           ("Config" (or (filename . ".emacs.d")
                         (filename . ".config")
                         (filename . ".dotfiles")))
           ("Org" (mode . org-mode))
           ("Dired" (mode . dired-mode))
           ("Internal" (name . "^\\*")))))

  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-auto-mode 1)
              (ibuffer-switch-to-saved-filter-groups "default")
              (xah-fly-insert-mode-activate))))
  ;; To "Smart Clean" the list:
  ;; Press 'z' in ibuffer to filter, or 'S' to save
  ;; Press 'D' on a group to kill all buffers in that group

  ;; kill all "non-file" buffers & unused in a while

(setq make-backup-files t)
(setq auto-save-default t)
;; Create quarantine folders for backups and auto-saves
(make-directory "~/.emacs.d/backups/" t)
(make-directory "~/.emacs.d/auto-saves/" t)

;; Route all backup (~) and auto-save (#) files to the quarantine
(setq backup-directory-alist '(("." . "~/.emacs.d/backups/")))
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-saves/" t)))

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; set Firefox as default web browser
(setq browse-url-browser-function 'browse-url-firefox)

(add-to-list 'auto-mode-alist '("\\.m3u\\'"  . text-mode))
(add-to-list 'auto-mode-alist '("\\.m3u8\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.pls\\'"  . text-mode))
(add-to-list 'auto-mode-alist '("\\.log\\'"  . text-mode))

(use-package savehist
  :init
  (setq savehist-file "~/.emacs.d/history"
        history-length 1000
        history-delete-duplicates t)
  (savehist-mode 1)
  :config
  (add-to-list 'savehist-additional-variables 'query-replace-history))

(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/base_cfg.org"))
(global-set-key (kbd "C-c 9") 'config-visit)

(defun config-reload ()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/base_cfg.el")))
(global-set-key (kbd "C-c 0") 'config-reload)

;; real-time auto-refresh on dired/dirvish
;; Auto-refresh Dired/Dirvish buffers when files change on disk
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; Also, make sure Emacs uses 'ls-lisp' or 'gls' for better update handling
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil) ; Stay quiet while refreshing

;; auto-refreshes screen after a dired/dirvish action
(advice-add 'dired-do-copy :after (lambda (&rest _) (revert-buffer)))
(advice-add 'dired-do-rename :after (lambda (&rest _) (revert-buffer)))
(advice-add 'dired-do-delete :after (lambda (&rest _) (revert-buffer)))

(require 'my-clean-unused-buffers)
(require 'my-xfk-universal-snap)
(provide 'system)
