;;; my-mako-last-sms.el --- Mako SMS extraction and KDE Connect integration

;; reads mako history natively to find recent sms, formats the number,
;; matches to contacts, and triggers the kde reply sequence in a split frame

(defun my-clean-phone-number (num-str)
  "Strips absolutely everything except raw digits. Preserves leading plus sign."
  (let ((clean (replace-regexp-in-string "[^0-9]" "" (or num-str ""))))
    (if (string-prefix-p "+" (or num-str ""))
        (concat "+" clean)
      clean)))

(defun my-find-contact-by-number (clean-num)
  "Searches `my-kde-contacts' for a matching number. Returns the name or nil."
  (let ((matched-name nil))
    (when (boundp 'my-kde-contacts)
      (catch 'found
        (dolist (contact my-kde-contacts)
          (let ((stored-num (my-clean-phone-number (cdr contact))))
            ;; Ensure we aren't matching empty strings, and then check if the
            ;; raw digits of one number exist inside the other.
            (when (and (> (length stored-num) 5)
                       (> (length clean-num) 5)
                       (or (string-match-p stored-num clean-num)
                           (string-match-p clean-num stored-num)))
              (setq matched-name (car contact))
              (throw 'found t))))))
    matched-name))

;; --- ISOLATION MINOR MODE ---

(defun my-mako-sms-abort ()
  "Safely kill the SMS buffer and close the isolated frame."
  (interactive)
  (let ((frame (selected-frame)))
    (when (get-buffer "*Last SMS*")
      (kill-buffer "*Last SMS*"))
    (delete-frame frame)))

(define-minor-mode my-mako-sms-mode
  "Minor mode for isolated Mako SMS frames."
  :init-value nil
  :lighter " MakoSMS"
  :keymap (let ((map (make-sparse-keymap)))
            ;; Safely close the frame without triggering save-buffers-kill-terminal
            (define-key map (kbd "C-c C-x") #'my-mako-sms-abort)
            (define-key map (kbd "C-c C-k") #'my-mako-sms-abort)
            map))

;; --- MAIN COMMAND ---

(defun my-mako-last-sms ()
  "Parse mako history, find the last sms, copy it, show it, and pre-fill the reply prompt."
  (interactive)
  (let* ((json-str (shell-command-to-string "makoctl history -j"))
         (data (condition-case nil
                   (json-parse-string json-str :object-type 'alist :array-type 'list)
                 (error nil)))
         (recent-entries (seq-take data 3))
         (sms-body nil)
         (sms-sender-raw nil))

    ;; 1. Loop through the top 3 entries to find the one from 'Messages'
    (catch 'found
      (dolist (entry recent-entries)
        (let ((summary (alist-get 'summary entry)))
          (when (equal summary "Messages")
            (setq sms-body (alist-get 'body entry))
            (throw 'found t)))))

    (if sms-body
        (progn
          ;; 2. The body looks like "(470) 377-3021: Gauaihds". Split it.
          (if (string-match "^\\(.*?\\): \\(.*\\)$" sms-body)
              (progn
                (setq sms-sender-raw (match-string 1 sms-body))
                (setq sms-body (match-string 2 sms-body)))
            (setq sms-sender-raw "Unknown"))

          (kill-new sms-body)

          ;; 3. Spawn the new frame
          (let ((new-frame (make-frame)))
            (select-frame new-frame)

            ;; THE ISOLATION HACK:
            ;; Tell this specific frame to pretend no other buffers exist.
            (set-frame-parameter new-frame 'buffer-predicate (lambda (buf) (eq buf (current-buffer))))

            (let ((buf (get-buffer-create "*Last SMS*")))
              (with-current-buffer buf
                (erase-buffer)
                (insert "--- RECEIVED MESSAGE ---\n\n"
                        "From: " sms-sender-raw "\n\n"
                        sms-body)
                (visual-line-mode 1)
                ;; Activate our custom minor mode for safe closing
                (my-mako-sms-mode 1))
              (switch-to-buffer buf))

            (split-window-below)
            (other-window 1)

            ;; 4. Figure out who sent this so we can pre-fill the prompt
            (let* ((clean-num (my-clean-phone-number sms-sender-raw))
                   (contact-name (my-find-contact-by-number clean-num))
                   ;; CRITICAL FIX: Never fall back to 'sms-sender-raw'. Use 'clean-num'.
                   (prefill-val (or contact-name clean-num)))

              ;; 5. Setup the prompt and cleanly handle C-g aborts
              (minibuffer-with-setup-hook
                  (lambda () (insert prefill-val))
                (if (fboundp 'my-kde-send-sms)
                    ;; If you press C-g in the minibuffer, intercept the 'quit' signal
                    ;; and safely close the whole frame instead of throwing an error.
                    (condition-case nil
                        (call-interactively 'my-kde-send-sms)
                      (quit (my-mako-sms-abort)))
                  (message "Warning: my-kde-send-sms is not defined yet!"))))))
      (message "No SMS found in the last 3 Mako notifications"))))

(provide 'my-mako-last-sms)
;;; my-mako-last-sms.el ends here
