;; -*- lexical-binding: t; -*-
;;
;;; --- ASYNCHRONOUS MODE
(use-package async
  :ensure t
  :init (dired-async-mode 1))


;;; --- DIRED
(use-package dired
  :ensure nil
  :config
  (setq dired-kill-when-opening-new-dired-buffers t
        dired-dwim-target t
        delete-by-moving-to-trash t
        dired-recursive-deletes 'always
        dired-recursive-copies 'always)

  ;; Moved from init.el as requested
  (put 'dired-find-alternate-file 'disabled nil)

  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil
        ls-lisp-dirs-first t
        ls-lisp-ignore-case t
        dired-listing-switches "-AGFhlv --time-style=long-iso")
  (add-hook 'dired-mode-hook #'dired-hide-details-mode))

(use-package dirvish
  :ensure t
  :init (dirvish-override-dired-mode)
  :custom
  (dirvish-attributes '(nerd-icons file-size file-time))
  (dirvish-layout '(0 45 55))
  (dirvish-hilite-line nil)
  ;; FIXED: removed 'standard' to stop the void-function error
  (dirvish-preview-dispatchers '(image))
  :config
  (setq dirvish-mode-line-format '(:left (sort symlink) :right (omit)))
  ;; FIXED: set to 1 to enable peeking on .el and other files
  (dirvish-peek-mode 1)

  (setq dirvish-quick-access-entries
        '(("h" "~/"                          "Home")
          ("l" "~/Desk/"                     "Desk")
          ("w" "~/DLs/"                      "DLs")
          ("d" "~/Docs/"                     "Docs")
          ("r" "~/Docs/11.git_docs/"         "git-docs")
          ("m" "~/Musk/"                     "Musk")
          ("p" "~/Pix/"                      "Pix")
          ("v" "~/Vidz/"                     "Vidz")
          ("t" "~/tmp/"                      "tmp")
          ("f" "~/.dotfiles/"                ".dotfiles")
          ("c" "~/.config/"                  ".config")
          ("e" "~/.emacs.d/"                 ".emacs.d")
          ("s" "~/.scripts/"                 ".scripts")
          ("T" "~/.local/share/Trash/files/" "Trash")
          ("i" "/run/media/"                 "Media")))
  :bind
  (("C-c f" . dirvish)
   :map dirvish-mode-map
   ("g"   . dirvish-quick-access)
   ("f"   . dirvish-file-info-menu)
   ("y"   . dirvish-yank-menu)
   ("s"   . dirvish-quicksort)
   ("j"   . dired-up-directory)
   ("k"   . dired-next-line)
   ("i"   . dired-previous-line)
   ("l"   . dired-find-file)
   ("TAB" . dirvish-subtree-toggle)
   ("v"   . dirvish-layout-toggle)
   ("q"   . dirvish-quit)))


;;; --- DIRED OPEN
(use-package dired-open
  :ensure t
  :config
  (setq dired-open-extensions '(("png"  . "nsxiv") ("jpg"  . "nsxiv")
                                ("jpeg" . "nsxiv") ("gif"  . "nsxiv")
                                ("bmp"  . "nsxiv") ("mkv"  . "mpv")
                                ("avi"  . "mpv")   ("mp4"  . "mpv")
                                ("mp3"  . "mpv")   ("pdf"  . "zathura"))))

(provide 'file-manager)



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
