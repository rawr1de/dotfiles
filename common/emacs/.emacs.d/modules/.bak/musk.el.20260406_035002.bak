;; -*- lexical-binding: t; -*-
;;
;; musk.el --- Core Hybrid EMMS Setup (MPD Metadata + MPV Playback)
;;

;;; --- PACKAGES/CONFIGS
(use-package emms
  :ensure t
  :demand t
  :config
  (require 'emms-setup)
  (require 'emms-player-mpv)
  (require 'emms-player-mpd)


  ;; --- 1. DIRECTORY DEFAULTS ---
  (setq emms-source-file-default-directory "~/Musk/")
  (setq emms-player-mpd-music-directory "~/Musk/")

  ;; --- 2. BACKEND PLAYER (MPV) ---
  (setq emms-player-list '(emms-player-mpv))
  (setq emms-player-mpv-parameters
        '("--quiet" "--no-video" "--gapless-audio=yes" "--keep-open=no"))

  ;; --- 3. METADATA ENGINE (MPD) ---
  (setq emms-player-mpd-server-name "localhost")
  (setq emms-player-mpd-server-port "6600")
  (setq emms-info-functions '(emms-info-mpd))


  ;; --- 4. THE SYNC LOGIC
  (defun musk-sync-music-metadata ()
    "Force MPD update and pull all metadata into EMMS browser/cache."
    (interactive)
    (message "Syncing MPD and EMMS...")
    ;; 1. Tell MPD server to scan disk for changes
    (emms-player-mpd-update-all)
    ;; 2. Clear EMMS local metadata cache
    (emms-cache-reset)
    ;; 3. Dump the entire MPD database into EMMS instantly (The fast way)
    (emms-cache-set-from-mpd-all)
    ;; 4. Refresh the UI
    (when (fboundp 'emms-browser-refresh)
      (emms-browser-refresh))
    (message "Music sync complete."))


  ;; --- 5. MPV ISOLATED VOLUME CONTROL & PERSISTENCE
  (defvar musk-mpv-volume-file (expand-file-name "emms-volume-cache" user-emacs-directory)
    "File where EMMS saves the last known MPV volume.")

  (defun musk-load-saved-volume ()
    "Read the saved volume from cache, default to 100."
    (if (file-exists-p musk-mpv-volume-file)
        (string-to-number (with-temp-buffer
                            (insert-file-contents musk-mpv-volume-file)
                            (buffer-string)))
      100))

  (defun musk-apply-saved-volume ()
    "Inject the saved volume into MPV as soon as it starts."
    (let ((vol (musk-load-saved-volume)))
      (emms-player-mpv-cmd (list 'set_property 'volume vol))))

  ;; Hook to apply volume instantly when a track begins
  (add-hook 'emms-player-started-hook #'musk-apply-saved-volume)

  (defun musk-volume-change (amount)
    "Change MPV internal volume, save state, and notify Noctalia."
    (emms-player-mpv-cmd (list 'add 'volume amount))
    (emms-player-mpv-cmd '(get_property volume)
                         (lambda (data _err)
                           (let ((vol (round data)))
                             ;; 1. Save new volume to cache file
                             (with-temp-file musk-mpv-volume-file
                               (insert (number-to-string vol)))
                             ;; 2. Update Emacs Minibuffer
                             (message "MPV Volume: %d%%" vol)
                             ;; 3. Fire OSD-style transient notification
                             (start-process "emms-vol-notify" nil "notify-send"
                                            "-a" "EMMS" "-u" "low" "-t" "1500"
                                            "-h" "string:x-canonical-private-synchronous:mpv-volume"
                                            "-h" (format "int:value:%d" vol)
                                            "-h" "int:transient:1"
                                            "MPV Volume" (format "%d%%" vol))))))


  ;; --- 6. XFK ACTIVE LINE HIGHLIGHT ---
  ;; 1. Force line highlights to ONLY show in the currently focused window
  (setq global-hl-line-sticky-flag nil)

  ;; 2. Ensure we have a visible color from your theme for the highlight
  (set-face-attribute 'hl-line nil :inherit 'highlight :extend t)

  ;; 3. Hook directly into Xah-Fly-Keys to toggle the highlight
  (with-eval-after-load 'xah-fly-keys
    (add-hook 'xah-fly-insert-mode-activate-hook
              (lambda () (global-hl-line-mode 1)))

    (add-hook 'xah-fly-command-mode-activate-hook
              (lambda () (global-hl-line-mode -1))))


  (emms-all)

  ;; open playing track cover art
  ;; my-musk-show-album-art.el
  (require 'my-musk-show-album-art)

  ;; kitty popup window with song info/progression bar
  ;; my-emms-now-playing-popup.el
  (require 'my-emms-now-playing-popup)

  ;; add marked/pointer file/dir(s) in Dired/Dirvish to EMMS
  ;; my-dirvish-enqueue-emms.el
  (require 'my-dirvish-enqueue-emms)

  ;; add marked/pointer file/dir(s) in Dired/Dirvish
  ;; to EMMS and Jump to playlist
  ;; my-dirvish-enqueue-emms-go.el
  (require 'my-dirvish-enqueue-emms-go )

  ;; toggle 'emms-mark-mode' ON/OFF
  ;; my-emms-mark-mode-toggle.el
  (require 'my-emms-mark-mode-toggle)

  ;; modeline now playing visuals
  (require 'musk-visuals)

  ;; Auto-Save Playlist Function
  ;; my-emms-save-last-playlist.el
  (require 'my-emms-save-last-playlist))



(provide 'musk)

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
