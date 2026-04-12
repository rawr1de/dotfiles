;;; my-mako-last-sms.el --- Mako SMS extraction and KDE Connect integration

;; reads mako history natively to find recent sms, formats the number,
;; matches to contacts, and triggers the kde reply sequence in a split frame

(defun my-clean-phone-number (num-str)
  "Strips everything except numbers and the plus sign from a phone string."
  (replace-regexp-in-string "[^0-9+]" "" num-str))

(defun my-find-contact-by-number (clean-num)
  "Searches `my-kde-contacts' for a matching number. Returns the name or nil."
  (let ((matched-name nil))
    ;; Make sure the contact list actually exists before searching
    (when (boundp 'my-kde-contacts)
      (catch 'found
        (dolist (contact my-kde-contacts)
          ;; contact is (name . "+1470...")
          ;; We check if the contact's number is inside the raw number we got, or vice-versa
          (let ((stored-num (my-clean-phone-number (cdr contact))))
            (when (or (string-match-p stored-num clean-num)
                      (string-match-p clean-num stored-num))
              (setq matched-name (car contact))
              (throw 'found t))))))
    matched-name))

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
            ;; Fallback if regex fails: just use the whole body
            (setq sms-sender-raw "Unknown"))

          (kill-new sms-body)

          ;; 3. Spawn the new frame and split it
          (select-frame (make-frame))
          (let ((buf (get-buffer-create "*Last SMS*")))
            (with-current-buffer buf
              (erase-buffer)
              (insert "--- RECEIVED MESSAGE ---\n\n"
                      "From: " sms-sender-raw "\n\n"
                      sms-body)
              (visual-line-mode 1))
            (switch-to-buffer buf))

          (split-window-below)
          (other-window 1)

          ;; 4. Figure out who sent this so we can pre-fill the prompt
          (let* ((clean-num (my-clean-phone-number sms-sender-raw))
                 (contact-name (my-find-contact-by-number clean-num))
                 ;; If we found a name, use it. Otherwise use the raw number.
                 (prefill-val (or contact-name sms-sender-raw)))

            ;; 5. We temporarily override `completing-read-default` to force
            ;; the initial-input to be our sender so you don't have to type it.
            (minibuffer-with-setup-hook
                (lambda () (insert prefill-val))
              (if (fboundp 'my-kde-send-sms)
                  (call-interactively 'my-kde-send-sms)
                (message "Warning: my-kde-send-sms is not defined yet!")))))
      (message "No SMS found in the last 3 Mako notifications"))))

(provide 'my-mako-last-sms)
;;; my-mako-last-sms.el ends here
