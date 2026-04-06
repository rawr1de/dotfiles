;; -*- lexical-binding: t; -*-
;;
;; ORG-MODE CONFIGS
;;

;;; --- ORG MODE - LAZY LOADED
(use-package org
  :ensure nil
  :defer t
  :config
  (setq org-dir "~/Docs/Org/"
        dropbox-orgriz "~/Desk/Dropbox/orgriz/"
        dropbox-configs "~/Desk/Dropbox/configs/"
        org-hide-leading-stars t
        org-startup-folded t
        org-src-window-setup 'current-window
        org-support-shift-select t
        org-hide-emphasis-markers t)
  ;; disable subscripts globally
  ;; write it with: H_{2}O or a_{i}
  (setq org-pretty-entities nil)
  (setq org-emphasis-alist
        '(("*" (bold :weight black))
          ("/" (italic :foreground "dark salmon"))
          ("_" (:underline t :foreground "cyan"))
          ("=" (verbatim :foreground "tomato"))
          ("~" (:background "PaleGreen1" :foreground "dim gray"))
          ("+" (:strike-through t :foreground "dark orange")))))


;;; --- ORG-CAPTURE + BULLETS
(use-package org-capture
  :bind ("C-c c" . org-capture)
  :config
  (setq org-export-coding-system 'utf-8)
  (setq org-capture-templates
        '(("r" "relatorio tcc" entry
           (file+headline "~/Desk/TCC_rdo/textos_tcc/relat_tcc.org"
                          "March")
           "* %<%d/%m/%Y>\nAtividade: %^{qual atividade?}"
           :empty-lines 1 :append t))))

(use-package org-bullets :ensure t :hook (org-mode . org-bullets-mode))


;;; --- ORG-MODERN
;; pretify .org files
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :config
  (set-face-attribute 'org-modern-symbol nil :height 1.5))

;; (setq org-modern-star '("◉" "○" "✸" "✿" "✤"))
;; Filled circles
;; (setq org-modern-star '("●" "◉" "○" "◈" "◇"))
;; Arrows
;; (setq org-modern-star '("▶" "▷" "◆" "◇" "✦"))
;; Minimal
;; (setq org-modern-star '("•" "◦" "▸" "▹" "·"))

; hides *bold* markers, shows only the formatting
(setq org-hide-emphasis-markers t)
; renders \alpha as α etc
(setq org-pretty-entities t)
; clean indentation by heading level
(setq org-startup-indented t)


;;; --- ORG-TEMPO
  ;; Enable quick template expansion in Org
  (require 'org-tempo)
  (with-eval-after-load 'org
    (require 'org-tempo)
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("sh" . "src bash"))
    (add-to-list 'org-structure-template-alist '("py" . "src python")))
    ;; add more languages if necessary above


;;; --- OTHER ORG CONFIGS
(setq org-file-apps
      '((auto-mode . emacs)
        (directory . emacs)
        ("\\.mm\\'" . default)
        ("\\.x?html?\\'" . default)
        ("\\.pdf\\'" . system)   ; Opens PDF in system default app
        ("\\.png\\'" . system)   ; Opens images in system default app
        ("\\.jpg\\'" . system)))


;;; --- END OF FILE
(provide 'org-config)



;; M-x package-delete (delete installed files)
;; M-x package-autoremove (remove package dependencies)
;;
;; Local Variables:
;; eval: (outline-minor-mode 1)
;; eval: (local-set-key (kbd "<tab>") 'outline-cycle)
;; outline-regexp: ";;;+ ?---"
;; End:
