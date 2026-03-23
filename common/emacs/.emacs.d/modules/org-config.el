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
  (setq org-emphasis-alist
        '(("*" (bold :weight black))
          ("/" (italic :foreground "dark salmon"))
          ("_" (:underline t :foreground "cyan"))
          ("=" (verbatim :foreground "tomato"))
          ("~" (:background "PaleGreen1" :foreground "dim gray"))
          ("+" (:strike-through t :foreground "dark orange")))))


;;;; --- ORG-CAPTURE + BULLETS
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



(provide 'org-config)


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
