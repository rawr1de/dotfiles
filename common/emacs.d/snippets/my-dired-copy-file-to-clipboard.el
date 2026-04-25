(require 'url-util) ;; Ensure URL encoding functions are loaded

(defun my-dired-copy-file-to-clipboard ()
  "Copy marked file(s) perfectly to Wayland clipboard as actual files (text/uri-list)."
  (interactive)
  (let* ((files (dired-get-marked-files))
         ;; Use LF ("\n") – this is what Wayland apps actually expect
         (uri-list (mapconcat (lambda (f)
                                (url-encode-url (concat "file://" (expand-file-name f))))
                              files "\n")))

    (with-temp-buffer
      ;; Insert the list + trailing newline (standard for text/uri-list)
      (insert uri-list "\n")

      ;; No need for 'no-conversion' any more – we are using plain LF
      (call-process-region (point-min) (point-max)
                           "wl-copy" nil nil nil "-t" "text/uri-list"))

    (message "Copied %d file(s) to Wayland clipboard." (length files))))

(provide 'my-dired-copy-file-to-clipboard)
