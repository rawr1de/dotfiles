;; -*- lexical-binding: t; -*-
;;
;;; --- COMPLETION STACK

(use-package vertico :ensure t :init (vertico-mode))
(use-package orderless :ensure t
  :custom (completion-styles '(orderless basic)))
(use-package marginalia :ensure t :init (marginalia-mode))
(use-package consult :ensure t)
(use-package embark :ensure t
  :bind (("C-." . embark-act) ("M-." . embark-dwim)))
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))



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
