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
  ;; Increase history so you don't lose search strings
  (setq history-length 1000)
  (setq consult-history-max 1000))


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
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))


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


(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-prefix 3)          ;; Trigger popup after 3 chars
  (corfu-auto-delay .8)          ;; popup wait time (0 for instant)
  (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match t)        ;; Auto-quit if there are no matches
  (corfu-preview-current nil)    ;; Disable inline preview (keeps buffer clean)
  (corfu-preselect 'prompt)      ;; Preselect the prompt, not the first candidate

  :init
  (global-corfu-mode)

  :bind
  (:map corfu-map
        ;; use standard modal keys for navigating the popup
        ("C-i"      . corfu-next)
        ("C-k"      . corfu-previous)
        ("C-g"      . corfu-quit)
        ("RET"      . corfu-insert)
        ;; Allows you to type "foo bar" to filter fuzzy matches via Orderless
        ("SPC"      . corfu-insert-separator)))

;; Add extensions for better Elisp/Code completion
(use-package cape
  :ensure t
  :init
  ;; Add these to the global completion list. Order matters!
  ;; The top of the list is prioritized.
  (add-to-list 'completion-at-point-functions #'cape-keyword) ;; Programming keywords
  (add-to-list 'completion-at-point-functions #'cape-file)    ;; File paths
  (add-to-list 'completion-at-point-functions #'cape-dabbrev) ;; Words in current buffer

  :bind
  ;; Optional: Dedicated keys to FORCE a specific completion menu
  ;; (e.g., "I only want to see file paths right now")
  (("C-c p f" . cape-file)
   ("C-c p w" . cape-dict)))




;;; --- END OF FILE !!!
(provide 'completion)



;; M-x package-delete (delete installed files)
;; M-x package-autoremove (remove package dependencies)
;;
;; Local Variables:
;; eval: (outline-minor-mode 1)
;; eval: (local-set-key (kbd "<tab>") 'outline-cycle)
;; outline-regexp: ";;;+ ?---"
;; End:
