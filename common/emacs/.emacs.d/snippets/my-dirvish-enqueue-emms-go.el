(defun my-dirvish-enqueue-emms-go ()
  "Instantly add marked files or directories in Dirvish directly to EMMS"
  (interactive)
  (let ((files (dired-get-marked-files)))
    (if (not files)
        (message "No files marked!")
      (dolist (file files)
        (if (file-directory-p file)
            (emms-add-directory-tree file)
          (emms-add-file file)))
      (message "Added %d item(s) to EMMS queue!" (length files))
      (emms-playlist-mode-go)))) ;; Jumps you straight to the playlist

(provide 'my-dirvish-enqueue-emms-go)
