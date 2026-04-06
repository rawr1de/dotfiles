;;; musk-visuals.el --- Visual formatting for EMMS Browser and Playlist

(require 'emms)
(require 'emms-browser)

;; --- 2. BROWSER VIEW (Hierarchical) ---
;; Level 1: Artist
(setq emms-browser-info-artist-format "%n")

;; Level 2: Year - Album (Indented, bold via face settings)
(setq emms-browser-info-album-format "%i%y - %n")

;; Level 3: Track. Title (Custom parser for clean 2-digit track numbers)
(defun musk-browser-track-format (bdata fmt)
  (let* ((track (emms-browser-bdata-first-track bdata))
         (track-raw (or (emms-track-get track 'info-tracknumber) "00"))
         (track-clean (if (string-match "^\\([0-9]+\\)" (format "%s" track-raw))
                          (format "%02d" (string-to-number (match-string 1 (format "%s" track-raw))))
                        "00"))
         (title (or (emms-track-get track 'info-title) "Unknown Title")))

    (concat (emms-browser-format-elem fmt "i")
            track-clean ". " title)))

(setq emms-browser-info-title-format #'musk-browser-track-format)


;; --- 3. PLAYLIST VIEW (Track on left, Time right-aligned) ---
(defun musk-playlist-description (track)
  (let* ((artist (or (emms-track-get track 'info-artist) "Unknown"))
         (album  (or (emms-track-get track 'info-album)  "Unknown"))

         ;; Fetch track number and forcefully extract only the first numbers
         (track-raw (or (emms-track-get track 'info-tracknumber) "00"))
         (trackp (if (string-match "^\\([0-9]+\\)" (format "%s" track-raw))
                     (format "%02d" (string-to-number (match-string 1 (format "%s" track-raw))))
                   "00"))

         ;; Restored missing Title and Time variables!
         (title  (or (emms-track-get track 'info-title) "Unknown Title"))
         (time   (let ((sec (emms-track-get track 'info-playing-time)))
                   (if (and sec (> sec 0))
                       (format "%02d:%02d" (/ sec 60) (% sec 60))
                     "00:00")))

         ;; 1. Left side: Artist  -  Album  -  Track  -  Title
         (left-side (format "%s - %s - %s - %s" artist album trackp title))

         ;; 2. Dynamic space: Pushes the next item exactly to the right edge
         (align-space (propertize " " 'display `(space :align-to (- right ,(length time))))))

    ;; 3. Combine: Left Side + Space + Time
    (concat left-side align-space time)))

(setq emms-track-description-function #'musk-playlist-description)


;; --- 4. PREVENT BROWSER FROM HIJACKING THE PLAYLIST ---
;; Silence the Artist and Album grouping headers when adding from the browser
(setq emms-browser-playlist-info-artist-format "")
(setq emms-browser-playlist-info-album-format "")

;; Tell EMMS to completely skip inserting those grouping headers if they are empty
(defun musk-skip-empty-browser-groups (orig-fun bdata)
  (let ((name (emms-browser-format-line bdata 'playlist)))
    (unless (string-blank-p name)
      (funcall orig-fun bdata))))
(advice-add 'emms-browser-playlist-insert-group :around #'musk-skip-empty-browser-groups)

;; Force the browser to use our flat layout for the actual tracks
(defun musk-browser-playlist-track-format (bdata _fmt)
  (let ((track (emms-browser-bdata-first-track bdata)))
    (musk-playlist-description track)))
(setq emms-browser-playlist-info-title-format #'musk-browser-playlist-track-format)


;; --- 5. MODE-LINE (Reverse Countdown & Truncation) ---
(require 'emms-playing-time)
(require 'emms-mode-line)

;; 1. Silence the default EMMS formatting
(setq emms-mode-line-format "")
(setq emms-playing-time-display-format "")

;; 2. Build the custom ticking mode-line
(defun musk-custom-modeline-tick ()
  "Draws the 13-char artist and reverse countdown every second."
  (when emms-player-playing-p
    (let* ((track (emms-playlist-current-selected-track))
           (artist (or (emms-track-get track 'info-artist) "Unknown"))

           ;; Truncates to 13 chars. Total width is 15 with the ".."
           (artist-trunc (truncate-string-to-width artist 15 nil nil ".."))

           ;; Time calculations
           (total (round (or (emms-track-get track 'info-playing-time) 0)))
           (current (round emms-playing-time))
           (time-val (if (> total 0) (max 0 (- total current)) current)))

      ;; Inject the 'artist-trunc' into the string
      (setq emms-mode-line-string
            (format " [%s  %02d:%02d] " artist-trunc (/ time-val 60) (% time-val 60)))

      (force-mode-line-update t))))

;; 3. Hook into the ticking timer SAFELY
(advice-add 'emms-playing-time-display :after #'musk-custom-modeline-tick)

;; 4. Clear it out when playback stops
(defun musk-clear-modeline ()
  (setq emms-mode-line-string ""))
(add-hook 'emms-player-stopped-hook #'musk-clear-modeline)

;; 5. Start the engines
(emms-mode-line 1)
(emms-playing-time 1)

(provide 'musk-visuals)
