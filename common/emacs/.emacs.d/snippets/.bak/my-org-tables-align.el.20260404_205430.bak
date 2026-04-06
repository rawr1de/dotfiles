;;;; ---- ORG TABLES ALIGN
;;; Scans the current buffer for Org tables (lines starting with '|')
;;; and triggers a visual realignment to ensure columns match Org-mode's spacing.
;;; Now supports marking multiple .org files in Dired!

(defun my-org-tables-align ()
  "Realign Org tables in the current buffer, or marked .org files in Dired."
  (interactive)
  (if (derived-mode-p 'dired-mode)
      ;; --- DIRED BEHAVIOR ---
      (let ((files (dired-get-marked-files)))
        (dolist (file files)
          (when (string-suffix-p ".org" file) ; Only touch Org files
            (with-current-buffer (find-file-noselect file)
              (org-mode) ; Ensure Org features are loaded
              (save-excursion
                (goto-char (point-min))
                (while (search-forward-regexp "^| " nil t)
                  (org-table-align)
                  (forward-line 1)))
              (save-buffer)
              (kill-buffer (current-buffer))))) ; Clean up the background buffer
        (message "Aligned tables in marked Org files."))

    ;; --- STANDARD BUFFER BEHAVIOR ---
    (save-excursion
      (goto-char (point-min))
      (while (search-forward-regexp "^| " nil t)
        (org-table-align)
        (forward-line 1)))
    (message "All tables aligned in current buffer!")))

(provide 'my-org-tables-align)
;;; org-tables-align.el <-- ENDS HERE
