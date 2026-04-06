;; KDE CONNECT SHARE FILE in DIRED/DIRVISH

(defun my-dired-kdeconnect-share ()
  "Send marked files (or file at point) to phone via KDE Connect."
  (interactive)
  (let* ((files (dired-get-marked-files))
         (phone-id (string-trim (shell-command-to-string
                                 "kdeconnect-cli -l --id-only | head -1"))))
    (if (string-empty-p phone-id)
        (message "KDE Connect: no device found")
      (dolist (file files)
        (let ((base (file-name-nondirectory file)))
          (if (= 0 (call-process "kdeconnect-cli" nil nil nil
                                 "--device" phone-id
                                 "--share" file))
              (start-process "notify" nil "notify-send"
                             "--urgency=normal"
                             "kdeconnect-share"
                             (format "File sent: %s" base))
            (start-process "notify" nil "notify-send"
                           "--urgency=critical"
                           "kdeconnect-share"
                           (format "Failed to send: %s" base))))))))


(provide 'my-dired-kdeconnect-share)
;;; my-dired-kdeconnect-share.el ends here
