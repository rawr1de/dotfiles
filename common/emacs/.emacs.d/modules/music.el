;; -*- lexical-binding: t; -*-
;;
;; EMACS MULTI MEDIA SYSTEM (EMMS)
;;

;;; --- PACKAGE CONFIG // MPD BACKEND
(use-package emms
  :defer t
  :config
  (require 'emms-setup)
  (require 'emms-player-mpd)
  (emms-all)
  (setq emms-volume-change-function #'emms-volume-mpd-change)
  (setq emms-player-list '(emms-player-mpd))
  (setq emms-player-mpd-server-name "localhost")
  (setq emms-player-mpd-server-port "6600")
  (setq emms-player-mpd-music-directory "~/Musk/")
  (setq emms-source-file-default-directory "~/Musk/")
  (setq emms-info-functions '(emms-info-mpd))
  ;; XFK FUNCTION to force insert-mode on EMMS (even after 'q')
  (defun my-emms-force-insert-mode ()
    "Force insert mode whenever we enter an EMMS buffer."
    (when (memq major-mode '(emms-browser-mode emms-playlist-mode emms-mode))
      (xah-fly-insert-mode-activate)))
  ;; Run after the commands that actually switch to the buffers
  (define-advice emms-smart-browse (:after () force-insert)
    (my-emms-force-insert-mode))
  (define-advice emms-playlist-mode-go (:after () force-insert)
    (my-emms-force-insert-mode))
  (define-advice emms (:after () force-insert)
    (my-emms-force-insert-mode))
  ;; Safety net for first creation
  (add-hook 'emms-browser-mode-hook  #'my-emms-force-insert-mode)
  (add-hook 'emms-playlist-mode-hook #'my-emms-force-insert-mode)
  (add-hook 'emms-mode-hook          #'my-emms-force-insert-mode))


;;; --- HELPER: safe playlist window width
(defun my-emms-get-width ()
  "Get playlist window width for truncation and line drawing."
  (let* ((buf (if (boundp 'emms-playlist-buffer) emms-playlist-buffer (current-buffer)))
         (win (get-buffer-window buf t)))
    (if win (window-body-width win) 80)))


;;; --- BROWSER LOOKS + PLAYLIST LOOKS
(with-eval-after-load 'emms-browser
  (setq emms-mode-line-icon-before-format "")
  (add-hook 'emms-browser-mode-hook #'hl-line-mode)

  ;; remove EMMS hardcoded colors for theme override
  (set-face-attribute 'emms-browser-artist-face nil :foreground 'unspecified)
  (set-face-attribute 'emms-browser-album-face  nil :foreground 'unspecified)
  (set-face-attribute 'emms-browser-track-face  nil :foreground 'unspecified)

  ;; COMMENTED OUT: my-emms-track-description conflicts with emms-mark-track-description
  ;; emms-mark-mode-disable cannot restore faces while this overrides the description function
  ;; (defun my-emms-track-description (track)
  ;;   (let* ((artist (or (emms-track-get track 'info-artist) "Unknown"))
  ;;          (title  (or (emms-track-get track 'info-title)  "Unknown"))
  ;;          (str    (format "%s: %s" artist title)))
  ;;     (when (> (length str) 40)
  ;;       (setq str (concat (substring str 0 37) "...")))
  ;;     (propertize str 'face '(:foreground "#B8860B"))))
  ;; (setq emms-track-description-function #'my-emms-track-description)
  (setq emms-mode-line-format "%s")
  (emms-playing-time-mode 1)


  ;;;; --- BROWSER
  (defun my-emms-album-fmt (_bdata fmt)
    (concat "%i"
            (let ((year (emms-browser-format-elem fmt "y")))
              (if (and year (not (string= year "0")))
                  "%y - " ""))
            "%n"))
  (setq emms-browser-info-album-format #'my-emms-album-fmt)
  (setq emms-browser-info-title-format "%i%T. %t")


  ;;;; --- PLAYLIST

  ;; Force the Album Header to be the exact same size/weight as standard tracks
  (set-face-attribute 'emms-browser-album-face nil :height 1.0 :weight 'normal)
  (setq emms-browser-playlist-info-artist-format "")
  (add-hook 'emms-playlist-mode-hook #'hl-line-mode)

  (defun my-emms-bdata-total-duration (bdata)
    (let ((total 0))
      (cl-labels ((sum (items)
                    (dolist (item items)
                      (if (emms-browser-bdata-p item)
                          (sum (emms-browser-bdata-data item))
                        (setq total (+ total (or (emms-track-get item 'info-playing-time) 0)))))))
        (sum (emms-browser-bdata-data bdata)))
      (format "%02d:%02d" (/ total 60) (% total 60))))

  ;; COMMENTED OUT: custom playlist album format — may interfere with mark-mode redraw
  ;; (defun my-emms-playlist-album-fmt (bdata _fmt)
  ;;   (let* ((track  (emms-browser-bdata-first-track bdata))
  ;;          (artist (emms-track-get track 'info-albumartist))
  ;;          (album  (emms-browser-bdata-name bdata))
  ;;          (year   (or (emms-track-get track 'info-year)
  ;;                      (emms-track-get track 'info-date) ""))
  ;;          (year-str (if (string-match "^[0-9]\\{4\\}" (format "%s" year))
  ;;                        (match-string 0 (format "%s" year)) ""))
  ;;          (has-year (> (length year-str) 0))
  ;;          (title  (if (and artist (not (string= artist "")) (not (string= artist album)))
  ;;                      (concat artist " - " album)
  ;;                    album))
  ;;          (target-w (my-emms-get-width))
  ;;          (max-len (max 10 (- target-w (length year-str) 6)))
  ;;          (title-clean (if (> (length title) max-len)
  ;;                           (concat (substring title 0 (- max-len 3)) "...")
  ;;                         title))
  ;;          (left   (concat title-clean " "))
  ;;          (right  (if has-year (concat " " year-str) ""))
  ;;          (dash-count (max 1 (- target-w (length left) (length right))))
  ;;          (dashes (make-string dash-count ?\u2500)))
  ;;   (concat left dashes right)))
  ;; (setq emms-browser-playlist-info-album-format #'my-emms-playlist-album-fmt)

  ;; COMMENTED OUT: custom playlist track line format — may interfere with mark-mode redraw
  ;; (defun my-emms-playlist-title-fmt (bdata _fmt)
  ;;   (let* ((track    (emms-browser-bdata-first-track bdata))
  ;;          (no-raw   (emms-browser-track-number track))
  ;;          (no-clean (if (string-match "^\\([0-9]+\\)" (format "%s" no-raw))
  ;;                        (format "%02d" (string-to-number (match-string 1 (format "%s" no-raw))))
  ;;                      "00"))
  ;;          (title    (or (emms-track-get track 'info-title) "Unknown"))
  ;;          (dur      (emms-browser-track-duration track))
  ;;          (max-t-len (max 10 (- (my-emms-get-width) (length dur) 8)))
  ;;          (title-clean (if (> (length title) max-t-len)
  ;;                           (concat (substring title 0 (- max-t-len 3)) "...")
  ;;                         title))
  ;;          (left     (format " %s. %s" no-clean title-clean))
  ;;          (align    (propertize " " 'display `(space :align-to (- right ,(length dur))))))
  ;;   (concat left align dur)))
  ;; (setq emms-browser-playlist-info-title-format #'my-emms-playlist-title-fmt)

  ;; COMMENTED OUT: album footer advice — inserting extra lines may confuse mark-mode redraw
  ;; (defun my-emms-insert-album-footer (bdata _starting-level)
  ;;   (when (eq (emms-browser-bdata-type bdata) 'info-album)
  ;;     (let* ((total (my-emms-bdata-total-duration bdata))
  ;;            (align (propertize " " 'display `(space :align-to (- right ,(length total))))))
  ;;       (with-current-emms-playlist
  ;;         (insert (concat align total) "\n")))))
  ;; (advice-add 'emms-browser-playlist-insert-bdata :after #'my-emms-insert-album-footer)

  ;; COMMENTED OUT: skip-empty-groups advice — leaving default group insert behavior
  ;; (defun my-emms-skip-empty-groups (orig bdata)
  ;;   (let ((name (emms-browser-format-line bdata 'playlist)))
  ;;     (unless (string-blank-p name)
  ;;       (funcall orig bdata))))
  ;; (advice-add 'emms-browser-playlist-insert-group :around #'my-emms-skip-empty-groups)
) ;; end with-eval-after-load 'emms-browser


;;; --- THE REDRAW BUTTON
(defun my-emms-redraw-lines ()
  "Recalculate and redraw the literal dashes in the EMMS playlist to fit the current window."
  (interactive)
  (when (get-buffer emms-playlist-buffer-name)
    (with-current-buffer emms-playlist-buffer-name
      (let ((inhibit-read-only t)
            (target-w (my-emms-get-width)))
        (save-excursion
          (goto-char (point-min))
          (while (re-search-forward "\\(.*? \\)\\(\u2500+\\)\\( .*\\|$\\)" nil t)
            (let* ((left (match-string 1))
                   (right (match-string 3))
                   (dash-count (max 1 (- target-w (length left) (length right)))))
              (replace-match (concat left (make-string dash-count ?\u2500) right) t t))))))))


;;; --- AUTO-REDRAW ON RESIZE
(defun my-emms-auto-redraw-on-resize (&optional _)
  "Trigger EMMS redraw automatically when any window changes size."
  (when (fboundp 'my-emms-redraw-lines)
    (my-emms-redraw-lines)))

(add-hook 'window-size-change-functions #'my-emms-auto-redraw-on-resize)

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
