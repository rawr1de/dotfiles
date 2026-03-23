;; -*- lexical-binding: t; -*-
;;
;; TOOLS
;;

;; GIT
(use-package magit :ensure t :defer t)
;; VTERM TERMINAL
(use-package vterm :ensure t :defer t)
;; TEXT EDITION
(use-package iedit :ensure t :bind ("C-;" . iedit-mode))
;; JUMP TO TEXT
(use-package avy :ensure t :bind ("M-s" . avy-goto-char-2))
;; EMACS COMMAND HELPER
(use-package which-key :ensure t :init (which-key-mode))
;; SUDO ELEVATION
(use-package sudo-edit :ensure t :commands (sudo-edit))


(provide 'tools)



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
