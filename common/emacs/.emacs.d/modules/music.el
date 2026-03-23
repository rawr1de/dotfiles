;; -*- lexical-binding: t; -*-
;;
;; MULTIMEDIA SYSTEM
;;

;;; --- MUSIC PLAYER / TAG EDITOR / OTHER
(use-package emms
  :ensure t
  :defer t
  :commands (emms-smart-browse emms-tag-editor-edit)
  :config
  (require 'emms-setup)
  (require 'emms-player-mpd)
  (emms-all)

  ;; --- MPD BACKEND CONFIG
  (setq emms-player-list '(emms-player-mpd)
        emms-player-mpd-server-name "localhost"
        emms-player-mpd-server-port "6600"
        emms-player-mpd-music-directory "~/Musk"
        emms-info-functions '(emms-info-mpd))

  ;; --- 1. FIXING THE BROWSER (b 1) LOOK
  ;; This controls exactly what you see in the 'b 1' list.
  ;; Format: [Track No] Title | (Duration)
  (setq emms-browser-info-title-format
        (lambda (track)
          (let ((name (emms-track-get track 'info-title))
                (no (emms-track-get track 'info-tracknumber)))
            (format "%2s. %s" (or no "0") (or name "Unknown Track")))))

  ;; Force a clean, non-indented tree look
  (setq emms-browser-default-covers nil) ; Removes placeholder icons if you don't use them
  (setq emms-browser-level-indent 2)

  ;; --- 2. NIRI/WAYLAND NOTIFICATIONS
  (defun my-music-now-playing-notify ()
    "Send a Wayland notification when a new track starts."
    (interactive)
    (let* ((track (emms-playlist-current-selected-track))
           (artist (emms-track-get track 'info-artist "Unknown Artist"))
           (album (emms-track-get track 'info-album "Unknown Album"))
           (title (emms-track-get track 'info-title "Unknown Title")))
      (start-process "emms-notify" nil "notify-send"
                     "-a" "EMMS"
                     "-i" "audio-x-generic" ; Standard icon
                     (format "Now Playing")
                     (format "%s\n%s — %s" title artist album))))

  ;; Trigger notification every time a new track starts
  (add-hook 'emms-player-started-hook #'my-music-now-playing-notify)

  ;; --- TAG EDITOR CONFIG
  (with-eval-after-load 'emms-tag-editor
    (setq emms-tag-editor-tagfile-functions
          '(("mp3"  . emms-info-mp3info)
            ("flac" . emms-info-flacinfo)
            ("ogg"  . emms-info-ogginfo)))))


(provide 'music)



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
