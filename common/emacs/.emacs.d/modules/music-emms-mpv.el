;;; music-emms-mpv.el --- epv: Playlist-only EMMS + MPV (silent playback)
;;;
;;; Goals:
;;;   - Playlist-only (no browser)
;;;   - Silent MPV playback
;;;   - Good Dired integration
;;;   - Better metadata reading (especially Comment)

(use-package emms
  :ensure t
  :demand t
  :commands (emms emms-playlist-clear)

  :config
  (require 'emms-setup)
  (require 'emms-player-mpv)

  (setq emms-cache-file "~/.emacs.d/emms/cache")
  (setq emms-source-file-default-directory "~/Musk/")


  ;; === ULTRA SIMPLE TEST READER (for debugging) ===
  (require 'emms-info)

  (defun my/emms-info-test (track)
    "Simple test reader that forces a comment"
    (when (eq (emms-track-type track) 'file)
      (let ((filename (emms-track-name track)))
        (message "TEST READER called for: %s" (file-name-nondirectory filename))
        ;; Force a comment so we can see if the reader is working
        (emms-track-set track 'info-note "(Deluxe Edition) - FORCED BY TEST")
        (emms-track-set track 'info-title "TEST TITLE"))))

  (setq emms-info-functions '(my/emms-info-test))






  ;; Fields shown in tag editor
  (setq emms-tag-editor-fields
        '(info-artist
          info-album
          info-albumartist
          info-title
          info-tracknumber
          info-discnumber
          info-year
          info-genre
          info-note
          info-composer))

  (emms-all)
  (setq emms-player-list '(emms-player-mpv))

  ;; Silent MPV
  (setq emms-player-mpv-parameters
        '("--quiet"
          "--no-video"
          "--gapless-audio=yes"
          "--keep-open=no"))

  (setq emms-browser-enable nil)

  ;; Xah-Fly-Keys insert mode
  (defun my/emms-force-insert-mode ()
    (when (eq major-mode 'emms-playlist-mode)
      (xah-fly-insert-mode-activate)))
  (add-hook 'emms-playlist-mode-hook #'my/emms-force-insert-mode)

  ;; Global keys
  (global-set-key (kbd "C-c m p") #'emms)
  (global-set-key (kbd "C-c m c") #'emms-playlist-clear)
  )

;; ====================== Dired Integration ======================

(defun my/dired-add-to-emms ()
  "Add marked files and directories to EMMS playlist.
Directories are added recursively."
  (interactive)
  (require 'emms)
  (let ((items (dired-get-marked-files)))
    (if items
        (progn
          (dolist (item items)
            (if (file-directory-p item)
                (emms-add-directory-tree item)
              (emms-add-file item)))
          (message "Added %d item(s) to EMMS" (length items)))
      (message "No items marked"))))

(defun my/emms-refresh-from-dired ()
  "Clear playlist and recursively add everything from current Dired directory."
  (interactive)
  (require 'emms)
  (when (eq major-mode 'dired-mode)
    (emms)
    (sleep-for 0.15)
    (emms-playlist-clear)
    (emms-add-directory-tree (dired-current-directory))
    (message "Playlist refreshed recursively from %s" (dired-current-directory))))

;; Bind keys
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "C-c m a") #'my/dired-add-to-emms)
  (define-key dired-mode-map (kbd "C-c m r") #'my/emms-refresh-from-dired))



;; === FINAL AGGRESSIVE DEBUG READER ===
(defun my/emms-info-exiftool-debug (track)
  "Nuclear debug reader - prints everything and forces Comment-xxx"
  (when (eq (emms-track-type track) 'file)
    (with-temp-buffer
      (call-process "exiftool" nil '(t nil) nil "-s" "-a" "-Comment*" (emms-track-name track))
      (let ((output (buffer-string)))
        (message "=== EXIFTOOL DEBUG === File: %s" (file-name-nondirectory (emms-track-name track)))
        (message "%s" output)

        ;; Force extract Comment-xxx
        (when (string-match "Comment-xxx[ \t]*:[ \t]*\\(.+\\)" output)
          (let ((comment (string-trim (match-string 1 output))))
            (emms-track-set track 'info-note comment)
            (message "→ FORCED Comment: %s" comment)))))))

;; Replace all info functions with the debug one temporarily
(setq emms-info-functions '(my/emms-info-exiftool-debug))


(provide 'music-emms-mpv)
