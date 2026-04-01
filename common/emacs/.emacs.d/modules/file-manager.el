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
  (add-hook 'dired-mode-hook #'dired-hide-details-mode)

  ;; Force music and video files to open in external MPV with visible window
  (defun my/dired-open-with-mpv (orig-fun &rest args)
    "Open music/video files with MPV in a visible window instead of inside Emacs."
    (let ((file (dired-get-filename)))
      (if (and file
               (string-match-p "\\.\\(mp3\\|flac\\|ogg\\|opus\\|m4a\\|wav\\|aac\\|mp4\\|mkv\\|webm\\)$" 
                               (downcase file)))
          (progn
            (start-process "mpv" nil "mpv"
                           "--force-window=yes"
                           "--gapless-audio=yes"
                           "--keep-open=no"
                           file)
            (message "Opening in MPV: %s" (file-name-nondirectory file)))
        ;; For non-media files, call original function
        (apply orig-fun args))))

  ;; Apply the advice to both normal RET and other-window
  (advice-add 'dired-find-file :around #'my/dired-open-with-mpv)
  (advice-add 'dired-find-file-other-window :around #'my/dired-open-with-mpv))


;;; --- DIRVISH
(use-package dirvish
  :ensure t
  :init (dirvish-override-dired-mode)
  :custom
  (dirvish-attributes '(nerd-icons file-size file-time))
  (dirvish-layout '(0 45 55))
  (dirvish-hilite-line nil)
  (setq auto-revert-use-notify t)
  ;; (setq transient-default-level 7)
  (global-auto-revert-mode 1)
  ;; FIXED: removed 'standard' to stop the void-function error
  (dirvish-preview-dispatchers '(image))
  :config
  (require 'dirvish-extras)
  (require 'dirvish-peek)
  (dirvish-peek-mode 1)
  (define-key dirvish-mode-map (kbd "M-i")
  (lambda () (interactive) (scroll-other-window-down 1)))
  (define-key dirvish-mode-map (kbd "M-k")
  (lambda () (interactive) (scroll-other-window 1)))
  (setq dirvish-mode-line-format '(:left (sort symlink) :right (omit)))
  (setq dirvish-preview-dispatchers '(font gif epub archive pdf audio image))
  ;; define the XFK segment for dirvish
  (dirvish-define-mode-line xfk-mode
    "Show current XFK mode."
    (if xah-fly-insert-state-p
        (propertize " INSERT " 'face '(:foreground "#5faf5f"))
      (propertize " COMMAND " 'face '(:foreground "#ff5f5f"))))

  ;; add it to the mode line
  (setq dirvish-mode-line-format '(:left (sort symlink) :right (omit xfk-mode)))

  ;; start dired in XFK insert-mode
  (add-hook 'dired-mode-hook #'xah-fly-insert-mode-activate)
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
  (transient-append-suffix 'dirvish-file-info-menu '(0 -1)
    '("x" "Cut"   dired-copy-paste-do-cut))
  (transient-append-suffix 'dirvish-file-info-menu '(0 -1)
    '("c" "Copy"  dired-copy-paste-do-copy))
  (transient-append-suffix 'dirvish-file-info-menu '(0 -1)
    '("v" "Paste" dired-copy-paste-do-paste))
  (transient-append-suffix 'dirvish-file-info-menu '(0 -1)
    '("q" "Quit" transient-quit-one))


  :bind
  (("C-c f" . dirvish)
   :map dirvish-mode-map
   ("f"   . dirvish-file-info-menu)
   ("g"   . dirvish-quick-access)
   ("y"   . dirvish-yank-menu)
   ("s"   . dirvish-quicksort)
   ("j"   . dired-up-directory)
   ("k"   . dired-next-line)
   ("i"   . dired-previous-line)
   ("l"   . dired-find-file)
   ("TAB" . dirvish-subtree-toggle)
   ("v"   . dirvish-layout-toggle)
   ("r"   . revert-buffer)
   ("I"   . beginning-of-buffer)
   ("K"   . end-of-buffer)
   (","   . xah-next-window-or-frame)
   ("q"   . dirvish-quit)))



;;; --- DIRED OPEN
(use-package dired-open
  :ensure t
  :config
  (setq dired-open-extensions '(("png"  . "nsxiv") ("jpg"  . "nsxiv")
                                ("jpeg" . "nsxiv") ("gif"  . "nsxiv")
                                ("bmp"  . "nsxiv") ("mkv"  . "mpv")
                                ("avi"  . "mpv")   ("mp4"  . "mpv")
                                ("mp3"  . "mpv")   ("pdf"  . "zathura")
				("epub"  . "FBReader"))))

;; COPY/PASTE/CUT for DIRED/DIRVISH
(with-eval-after-load 'dired
  (require 'dired-copy-paste))


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
