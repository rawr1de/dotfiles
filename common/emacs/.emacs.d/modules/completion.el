;; -*- lexical-binding: t; -*-
;;
;;; --- COMPLETION STACK

;; VERTICO
(use-package vertico
  :ensure t
  :init (vertico-mode)
  ;; :config
  )


;; CONSULT
;; second brain notes dirs + other dirs
(use-package consult
  :ensure t
  :config
  (require 'transient)
  (transient-define-prefix rdo/search-menu ()
    "Ripgrep search menu."
    ["Search in:"
     ("n" "notes"    (lambda () (interactive) (consult-ripgrep "~/Docs/10.notes/")))
     ("a" "agenda"   (lambda () (interactive) (consult-ripgrep "~/Desk/Dropbox/orgriz/")))
     ("d" "docs"     (lambda () (interactive) (consult-ripgrep "~/Docs/")))
     ("g" "git-docs" (lambda () (interactive) (consult-ripgrep "~/Docs/11.git_docs/")))
     ("e" "emacs.d"  (lambda () (interactive) (consult-ripgrep "~/.emacs.d/")))
     ("p" "prompt"   (lambda () (interactive) (consult-ripgrep
                                                (read-directory-name "Search in: " "~/"))))]))

;; CONSULT-DIR
(use-package consult-dir
  :ensure t
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file))
  :config
  (defun consult-dir--zoxide-dirs ()
    (split-string (shell-command-to-string "zoxide query --list") "\n" t))
;; consult within zoxide
  (defvar consult-dir--source-zoxide
    `(:name "Zoxide"
      :narrow ?z
      :category file
      :face consult-file
      :history file-name-history
      :items ,#'consult-dir--zoxide-dirs)
    "Zoxide source for consult-dir.")
  (add-to-list 'consult-dir-sources 'consult-dir--source-zoxide t))


;; ORDERLESS
(use-package orderless :ensure t
  :custom (completion-styles '(orderless basic)))

;; MARGINALIA
(use-package marginalia :ensure t :init (marginalia-mode))

;; EMBARK
(use-package embark :ensure t
  :bind (("C-." . embark-act) ("M-." . embark-dwim)))

;; EMBARK-CONSULT
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; ZOXIDE
(use-package zoxide
  :ensure t
  :hook (dired-after-readin . (lambda () (zoxide-add default-directory))))


(provide 'completion)


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
