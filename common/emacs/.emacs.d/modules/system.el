;; -*- lexical-binding: t; -*-
;;
;;; --- PERFORMANCE ENGINE
(setq gc-cons-threshold 100000000)
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))


;;; --- SYSTEM IMPROVEMENTS
(setq use-short-answers t)
(setq inhibit-startup-message t
      ring-bell-function 'ignore
      scroll-conservatively 100
      scroll-preserve-screen-position t
      create-lockfiles nil
      case-fold-search t
      read-quoted-char-radix 10)
;; controls number system (base) numerical code
;; Default (8): Octal (0-7) type C-q 141, get "a"
;; Value (10): Decimal type C-q 97 get "a"
;; Value (16): Hexadecimal type C-q 61 get "a"


;;; --- KEEP BACKUP/AUTO-SAVE FILES
(setq make-backup-files t)
(setq auto-save-default t)
;; Create quarantine folders for backups and auto-saves
(make-directory "~/.emacs.d/backups/" t)
(make-directory "~/.emacs.d/auto-saves/" t)

;; Route all backup (~) and auto-save (#) files to the quarantine
(setq backup-directory-alist '(("." . "~/.emacs.d/backups/")))
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/auto-saves/" t)))


;;; --- SYSTEM LANGUAGE/CODING ENVIRONMENT
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)


;;; --- SAVE HISTORY
(use-package savehist
  :init
  (setq savehist-file "~/.emacs.d/history"
        history-length 1000
        history-delete-duplicates t)
  (savehist-mode 1)
  :config
  (add-to-list 'savehist-additional-variables 'query-replace-history))


;;; --- OPEN/RELOAD CONFIG FILE [C-c 9 / C-c 0]
(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/base_cfg_1.el"))
(global-set-key (kbd "C-c 9") 'config-visit)

(defun config-reload ()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/base_cfg_1.el")))
(global-set-key (kbd "C-c 0") 'config-reload)



(provide 'system)


;;; --- END OF FILE !!!
;;
;; M-x package-delete (delete installed files)
;; M-x package-autoremove (remove package dependencies)
;;
;; Local Variables:
;; eval: (outline-minor-mode 1)
;; eval: (local-set-key (kbd "<tab>") 'outline-cycle)
;; outline-regexp: ";;;+ ?---"
;; End:
