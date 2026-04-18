;; -*- lexical-binding: t; -*-
;;
;;; --- UI ELEMENTS
(column-number-mode 1)
(show-paren-mode 1)
(save-place-mode 1)
(delete-selection-mode t)
(global-subword-mode 1)
(global-hl-line-mode t)
(visual-line-mode 1)
(setq-local word-wrap t)
(display-time)
;; (setq scroll-margin 3) ;; Keeps a 3-line buffer from the edge  HAVE TO LEAVE AT 0 FOR ULTRA-SCROLL PKG TO WORK!!
(setq display-time-24hr-format t display-time-load-average nil)
(when window-system (global-prettify-symbols-mode t))
;; PREVENT UI FLICKERING, DISABLE BARS BEFORE FRAME EVEN OPENS
(setq default-frame-alist '((tool-bar-lines . 0)
                            (menu-bar-lines . 0)
                            (vertical-scroll-bars . nil)))


;;; --- LINE NUMBERS / WHITESPACES / COLUMN_DELIMITER
;; show line numbers/whitespaces/column_delimiter in code/text enviroments
;; prevents apps from look ugly (vterm, dirvish, magit..)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
  (add-hook 'text-mode-hook #'display-line-numbers-mode)
  (setq-default fill-column 80)
  ;; (add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
  ;; (add-hook 'text-mode-hook #'display-fill-column-indicator-mode)
  (require 'whitespace)
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  (add-hook 'prog-mode-hook #'whitespace-mode)
  (add-hook 'text-mode-hook #'whitespace-mode)


;;; --- SHOW MATCHING PARENTHESIS, BRACKETS..
(electric-pair-mode 1)
(setq electric-pair-pairs '((?\{ . ?\}) (?\( . ?\)) (?\[ . ?\]) (?\" . ?\")))


;;; --- THEMES & APPEARANCE
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t doom-themes-enable-italic t)
    ;; 'latte (light) 'frappe (dark) 'macchiato (darker) 'mocha (darkest)
    ;; (setq catppuccin-flavor 'mocha)
    ;; (load-theme 'catppuccin t) ;;
  (set-face-attribute 'default nil :height 220)

  ;; Apply Org faces ONLY after Org is loaded to prevent "Invalid Face" error
  (with-eval-after-load 'org
    (set-face-attribute 'org-level-1 nil :height 1.1)
    (set-face-attribute 'org-level-2 nil :height 1.08)
    (set-face-attribute 'org-level-3 nil :height 1.05)
    (set-face-attribute 'org-level-4 nil :height 1.0)))

(use-package doom-modeline
  :ensure t
  :init (add-hook 'after-init-hook #'doom-modeline-mode)
  :config (setq doom-modeline-icon nil doom-modeline-minor-modes nil))



(provide 'ui)


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
