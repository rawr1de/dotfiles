;;; --- KDE CONNECT SMS INTEGRATION ---
;; Send SMS messages entirely from the Emacs minibuffer, completely bypassing
;; the bright Qt GUI. Features a built-in contact list for fast fuzzy-finding.

(defvar my-kde-contacts
  '(("rdo eu"      . "+14709277960")
    ("tel"         . "+14709277980")
    ("mama"        . "+15612523516")
    ("rich"        . "+15618469261")
    ("kali"        . "+14704489201")
    ("teresa gigi" . "+14048843554")
    ("brooke"      . "+14704489027")
    ("nega dri"    . "+5562")
    ("beto"        . "+5562")
    ("osvaldo"     . "+5562"))
  "alist of frequent cons. phone numbers")

(defun my-kde-send-sms ()
  "Prompt for a contact (or raw number) and send an SMS via KDE Connect"
  (interactive)
  ;; 1. Ask who to text using your contacts list
  (let* ((name (completing-read "Text who? (Choose or type number): "
                                (mapcar #'car my-kde-contacts)))
         ;; 2. Look up the number. If you typed a raw number not in the list, use that.
         (number (cdr (assoc name my-kde-contacts)))
         (target (or number name))

         ;; 3. Ask for the message
         (msg (read-string (format "Message to %s: " name)))

         ;; 4. Grab the active phone ID
         (phone-id (string-trim (shell-command-to-string "kdeconnect-cli -l --id-only | head -1"))))

    ;; 5. Execute the background process
    (if (string-empty-p phone-id)
        (message "KDE Connect Error: No device found on the network!")
      (start-process "kde-sms-proc" nil "kdeconnect-cli"
                     "--device" phone-id
                     "--destination" target
                     "--send-sms" msg)

      ;; 6. The Green Visual Confirmation
      (message "%s"
               (propertize (format " ✔ SMS sent to %s: %s " name msg)
                           'face '(:background "#98c379" :foreground "#282c34" :weight bold))))))
(provide 'my-kde-sms)
;; my-kde-sms.el  <--- END OF FILE
