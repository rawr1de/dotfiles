;;;; --- CONVERT .MD TO .ORG
;;; Converts Markdown files to Org-mode using Pandoc. If in a buffer,
;;; it also automatically triggers 'org-tables-align' to fix table formatting

(defun my-convert-md-to-org ()
  "Convert MD to Org. Works on current buffer or Dired/Dirvish marked files."
  (interactive)
  ;; Store whether we started in Dired to control behavior later
  (let* ((in-dired-p (derived-mode-p 'dired-mode))
         (files (if in-dired-p
                    (dired-get-marked-files)
                  (list (buffer-file-name)))))
    (dolist (file files)
      (if (and file (string-suffix-p ".md" file))
          (let ((new-file (concat (file-name-sans-extension file) ".org")))
            ;; 1. Run the external conversion
            (shell-command (format "pandoc -f markdown -t org -o %s %s"
                                   (shell-quote-argument new-file)
                                   (shell-quote-argument file)))

            ;; 2. Logic for opening and aligning
            (if in-dired-p
                ;; DIRED BEHAVIOR: Do it silently in the background and clean up
                (with-current-buffer (find-file-noselect new-file)
                  (org-mode)
                  (my-org-tables-align)
                  (save-buffer)
                  (kill-buffer (current-buffer))) ; Close it so we don't clutter your buffers

              ;; BUFFER BEHAVIOR: Switch to the new file, align, and leave it open for you
              (progn
                (find-file new-file)
                (org-mode)
                (my-org-tables-align)
                (save-buffer)))

            (message "Converted: %s" (file-name-nondirectory new-file)))
        (unless in-dired-p
          (error "Not a Markdown file!"))))

    ;; 3. Refresh Dired view at the very end if we started there
    (when in-dired-p
      (revert-buffer))))

(provide 'convert-md-to-org)
;;; convert-md-to-org.el <-- ENDS HERE
