;;; my-pomodoro-timer-edit.el --- Org Timer Modeline & Alarm -*- lexical-binding: t; -*-

;; ============================================================================
;; ORG TIMER DOOM-MODELINE INTEGRATION & VISUAL/AUDIO ALARM
;;
;; Forces the Org countdown timer to render as bold red text in doom-modeline,
;; triggers a recursive UI flashing sequence, and asynchronously plays an audio
;; file upon completion.
;;
;; Usage: `C-c C-x 0` (Start: "25m"), `C-c C-x ,` (Pause), `C-c C-x _` (Stop).
;; Optional: Run `M-x my-pomodoro-set-audio-file` to change the alarm sound.
;; ============================================================================

(require 'org-timer)

;; --- Customization Variables ---

(defgroup my-pomodoro nil
  "Custom settings for the Org Pomodoro timer"
  :group 'org)

(defcustom my-pomodoro-audio-file nil
  "Path to the audio file to play when the timer finishes
If nil, no sound will play
You can set this in your init.el or change it interactively via `my-pomodoro-set-audio-file'"
  :type '(choice (const :tag "None" nil) file)
  :group 'my-pomodoro)

(defcustom my-pomodoro-audio-player
  (cond ((executable-find "afplay") "afplay")       ; macOS
        ((executable-find "paplay") "paplay")       ; PulseAudio/Linux
        ((executable-find "mpv") "mpv")             ; Cross-platform
        ((executable-find "mplayer") "mplayer")     ; Cross-platform
        (t nil))
  "Executable used to play the alarm sound asynchronously"
  :type '(choice (const :tag "None" nil) string)
  :group 'my-pomodoro)

;; --- Core Functions ---

(defun my-pomodoro-set-audio-file ()
  "Interactively select the audio file for the pomodoro alarm and save it permanently"
  (interactive)
  (let ((selected-file (read-file-name "Select alarm audio: ")))
    ;; customize-save-variable writes the setting to your init.el/custom.el
    ;; so it persists across Emacs reboots
    (customize-save-variable 'my-pomodoro-audio-file (expand-file-name selected-file))
    (message "Pomodoro alarm audio permanently set to: %s" my-pomodoro-audio-file)))

(defun my-org-timer-play-alarm ()
  "Play the configured audio file asynchronously without freezing Emacs"
  (when (and my-pomodoro-audio-file
             (file-exists-p my-pomodoro-audio-file))
    (if my-pomodoro-audio-player
        (let ((args (cond
                     ;; If using mpv, ignore user configs to prevent single-instance locks
                     ;; and force it to run headlessly
                     ((string= my-pomodoro-audio-player "mpv")
                      (list "--no-video" "--no-config" "--really-quiet"
                            (expand-file-name my-pomodoro-audio-file)))
                     ;; For afplay, paplay, etc., just pass the file path
                     (t
                      (list (expand-file-name my-pomodoro-audio-file))))))
          ;; Apply passes the arguments as a flat list to start-process
          (apply #'start-process "pomodoro-alarm" nil my-pomodoro-audio-player args))
      (message "No compatible audio player found on system Visual alarm only"))))

;; 1. Force the timer string to be red and bold in doom-modeline
(defun my-doom-modeline-timer-red (orig-fun &rest args)
  "Intercept doom-modeline's misc-info segment and make the Org timer red"
  (let ((str (apply orig-fun args)))
    ;; Check if the timer is active and the string is valid
    (when (and (stringp str)
               (bound-and-true-p org-timer-mode-line-string)
               (not (string-empty-p org-timer-mode-line-string)))
      ;; Copy sequence to safely mutate the string without altering cached data
      (setq str (copy-sequence str))
      ;; Trim whitespace to ensure the regexp matches even if Doom strips padding
      (let ((timer-regexp (regexp-quote (string-trim org-timer-mode-line-string))))
        (when (string-match timer-regexp str)
          (put-text-property (match-beginning 0) (match-end 0)
                             'face '(:foreground "red" :weight bold)
                             str))))
    str))

(advice-add 'doom-modeline-segment--misc-info :around #'my-doom-modeline-timer-red)

;; 2. Dirvish Modeline Integration
(with-eval-after-load 'dirvish
  (dirvish-define-mode-line my-org-timer
    "Display the active org-timer"
    (when (and (bound-and-true-p org-timer-mode-line-string)
               (not (string-empty-p org-timer-mode-line-string)))
      (propertize (string-trim org-timer-mode-line-string)
                  'face '(:foreground "red" :weight bold)))))

;; 3. The Flashing mechanism
(defun my-org-timer-flash (flashes-left)
  "Recursively invert the mode-line face to create a flashing effect"
  (when (> flashes-left 0)
    (invert-face 'mode-line)
    (force-mode-line-update)
    ;; Wait 0.4 seconds, then run this function again with 1 less flash
    (run-at-time 0.4 nil #'my-org-timer-flash (1- flashes-left))))

;; 4. Hook the flash and audio to the timer completion
(defun my-org-timer-done-action ()
  "Trigger the flashing sequence audio and clear the timer from the mode-line"
  ;; 10 toggles = 5 complete flashes (color change and change back)
  (my-org-timer-flash 10)
  (my-org-timer-play-alarm)

  ;; Wipe the timer string from memory so it vanishes
  (setq org-timer-mode-line-string nil)
  ;; Force every window's mode-line to redraw instantly
  (force-mode-line-update t))

(add-hook 'org-timer-done-hook #'my-org-timer-done-action)

(provide 'my-pomodoro-timer-edit)
;;; my-pomodoro-timer-edit.el ends here
