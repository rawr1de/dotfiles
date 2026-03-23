;; -*- lexical-binding: t; -*-
;;
;; BASE CONFIG FILE
;;
;;; --- LOADOUT FOLDERS
(add-to-list 'load-path "~/.emacs.d/modules/")
(add-to-list 'load-path "~/.emacs.d/snippets/")


;;; --- AUTOLOADS (LAZY LOADING)

;; drag and drop files in dired/dirvish
(autoload 'my-dired-ripdrag "ripdrag" nil t)
;; Colored Jump Marks
(autoload 'my-set-cycle-mark "colored-jump-marks" nil t)
(autoload 'my-jump-cycle-mark "colored-jump-marks" nil t)
(autoload 'my-clear-all-cycle-marks "colored-jump-marks" nil t)
;; Math & Logic
(autoload 'mini-calc "mini-calc" nil t)
(autoload 'org-column-sum "org-column-sum" nil t)
(autoload 'increment-number-decimal "increment-number-decimal" nil t)
(autoload 'eval-replace "eval-replace" nil t)
;; Package & Formatting
(autoload 'package-menu-find-marks "package-filter" nil t)
(autoload 'package-menu-filter-by-status "package-filter" nil t)
(autoload 'format-lyrics-current-buffer "lyrics-formatter" nil t)


;;; --- LOAD MODULES
(require 'system)
(require 'ui)
(require 'completion)
(require 'file-manager)
(require 'music)
(require 'tools)
(require 'org-config)


;;; --- THE MODAL CORE (Xah Fly Keys)
(use-package xah-fly-keys
  :load-path "~/.emacs.d/lisp/"
  :config
  (setq xah-fly-use-control-key t)
  (setq xah-fly-command-mode-cursor-color nil)
  (setq xah-fly-insert-mode-cursor-color nil)
  (xah-fly-keys-set-layout "qwerty")
  (xah-fly-keys 1))
  (add-hook 'server-after-make-frame-hook 'xah-fly-command-mode-activate)
  (global-set-key (kbd "<home>") 'xah-fly-command-mode-activate)


;;; --- KEY OVERRIDES & BINDINGS

;;;; --- CONTEXTUAL RIPDRAG (DIRED/DIRVISH ONLY)
  (define-key xah-fly-leader-key-map (kbd "1")
    '(menu-item "Contextual 1" nil
                :filter (lambda (_)
                          (if (derived-mode-p 'dired-mode)
                              'my-dired-ripdrag
                            'execute-extended-command))))

;;;; --- CUSTOM FUNCTIONS BINDINGS
  (define-key xah-fly-leader-key-map (kbd "0") 'my-set-cycle-mark)
  (define-key xah-fly-command-map    (kbd "0") 'my-jump-cycle-mark)
  (define-key xah-fly-leader-key-map (kbd "9") 'my-clear-all-cycle-marks)
  (define-key xah-fly-leader-key-map (kbd "a") 'mini-calc)
  (define-key xah-fly-leader-key-map (kbd "s") 'consult-line)


;;;; --- OTHER BINDINGS
  (global-set-key (kbd "C-s") 'save-buffer)
  (define-key xah-fly-leader-key-map (kbd "s") 'consult-line)
  (define-key xah-fly-leader-key-map (kbd "r") 'replace-string)
  (define-key xah-fly-leader-key-map (kbd "R") 'query-replace)
  (define-key xah-fly-leader-key-map (kbd "f") 'ibuffer)


;;;; --- VERT/HORIZ SPLIT CONTROL
  (global-set-key (kbd "C-S-i") 'enlarge-window)
  (global-set-key (kbd "C-S-k") 'shrink-window)
  (global-set-key (kbd "C-S-l") 'enlarge-window-horizontally)
  (global-set-key (kbd "C-S-j") 'shrink-window-horizontally)
  (define-key xah-fly-leader-key-map (kbd "=") 'balance-windows)


;;;; --- NUMBERS ROW
  (define-key xah-fly-key-map (kbd "5") 'delete-char)
  (define-key xah-fly-key-map (kbd "6") 'xah-select-block)
  (define-key xah-fly-key-map (kbd "7") 'xah-select-line)
  (define-key xah-fly-key-map (kbd "8") 'xah-select-text-in-quote)


;;;; --- SCREEN SCROLLING  [M-i / M-k]
(defun scroll-one-line-down ()
  "Scroll down one line."
  (interactive)
  (scroll-down 1))

(defun scroll-one-line-up ()
  "Scroll up one line."
  (interactive)
  (scroll-up 1))

(global-set-key (kbd "M-i") 'scroll-one-line-down)
(global-set-key (kbd "M-k") 'scroll-one-line-up)


;;;; --- MULTIPLE CURSORS
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this))
  :config (setq mc/always-run-for-all t))


;;;; --- REGISTERS
(set-register ?a (cons 'file "~/Desk/Dropbox/orgriz/[PERSO]_agenda_2026.org"))
(set-register ?h (cons 'file "~/Desk/Dropbox/orgriz/health.org"))
(set-register ?s (cons 'file "~/Desk/Dropbox/configs/[BIZ]_sys_config.org"))
(set-register ?t (cons 'file "~/Docs/Org/trade_kbase.org"))
(set-register ?p (cons 'file "~/Docs/Org/perso_search.org"))
(set-register ?f (cons 'file "~/Docs/11.git_docs/03.system/FIXES_LOG.org"))



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
