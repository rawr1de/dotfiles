(defun my-dirvish-enqueue-emms ()
  "Instantly add marked/point file(s) or dir(s) in Dirvish to EMMS."
  (interactive)
  (let ((files (dired-get-marked-files)))
    (if (not files)
        (message "No files marked!")
      (dolist (file files)
        (if (file-directory-p file)
            (emms-add-directory-tree file)
          (emms-add-file file)))
      (message "Added %d item(s) to EMMS queue!" (length files)))))

(provide 'my-dirvish-enqueue-emms)
