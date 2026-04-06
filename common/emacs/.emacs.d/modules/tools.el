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

  ;; WHICH-KEY ()emacs command helper
  (use-package which-key
    :ensure t
    :init (which-key-mode)
    :config
    (setq which-key-max-description-length nil)     ;; no truncation
    ;; (setq which-key-max-description-length 100)     ;; set truncation limit 80, 120...
    (setq which-key-add-column-padding 1)           ;; nicer spacing
    (setq which-key-idle-delay 0.8)                 ;; adjust to your taste
    (which-key-setup-minibuffer)                    ;; show in minibuffer instead of side popup
    (setq which-key-show-prefix 'echo)           ;; show the prefix you typed at the top
    (setq which-key-popup-type 'minibuffer)      ;; force minibuffer (same as setup-minibuffer)
    (setq which-key-side-window-max-height 0.4) ;; if you still prefer side window
    (which-key-mode 1))


;; SUDO ELEVATION
  (use-package sudo-edit :ensure t :commands (sudo-edit))

;; --- LUA (Lazy: only loads when opening a .lua file) ---
  (use-package lua-mode
    :ensure t
    :mode "\\.lua\\'"
    :defer t)

;; --- KDL (Lazy: only loads when opening a .kdl file) ---
  (use-package kdl-mode
    :ensure t
    :mode "\\.kdl\\'"
    :defer t)

;; --- KEYFREQ (Lazy: starts 2 seconds after Emacs is idle) ---
  (use-package keyfreq
    :ensure t
    :init
    (run-with-idle-timer 2 nil (lambda ()
                                 (keyfreq-mode 1)
                                 (keyfreq-autosave-mode 1))))

  ;; add/change/remove surronding brackets and more!
  (use-package embrace
    :ensure t
    :config
    ;; Create a dedicated sub-map for Embrace
    (defvar my-embrace-map (make-sparse-keymap) "Embrace surround map")
    ;; Hook it into standard modes
    (add-hook 'org-mode-hook #'embrace-org-mode-hook)
    ;; (Loads standard programming pairs)
    (add-hook 'prog-mode-hook #'embrace-ruby-mode-hook))


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
