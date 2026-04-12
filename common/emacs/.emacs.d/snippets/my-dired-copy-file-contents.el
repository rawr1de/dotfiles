(defun my-dired-copy-file-contents ()
  "Copy the contents of marked Dired/Dirvish files to the clipboard"
  (interactive)
  (let ((files (dired-get-marked-files))
        (contents ""))
    (dolist (file files)
      (when (file-regular-p file) ;; Silently ignore directories
        (with-temp-buffer
          (insert-file-contents file)
          ;; Add clear separators if multiple files are selected
          (if (> (length files) 1)
              (setq contents (concat contents
                                     (format "=== FILE: %s ===\n" (file-name-nondirectory file))
                                     (buffer-string)
                                     "\n=== END FILE ===\n\n"))
            ;; If only one file is selected/hovered, just grab the raw text
            (setq contents (buffer-string))))))

    (if (string-empty-p contents)
        (message "No valid text files selected.")
      (progn
        (kill-new contents)
        (message "Copied contents of %d file(s) to clipboard." (length files))))))


(provide 'my-dired-copy-file-contents)
;; my-dired-copy-file-contents.el  <--- END OF FILE
