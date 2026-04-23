;;;; --- QUICK FILE BACKUP (Dired / Dirvish / Buffer)
;; Automatically creates a timestamped snapshot of the current file(s)
;; inside a hidden `.bak` subdirectory. It also sweeps up any stray
;; `.bak` files lying around in the current folder and moves them inside.
;;
;; Behavior:
;;   - In Dired/Dirvish: Backs up all actively marked files.
;;   - In Dired/Dirvish (no marks): Backs up the file under the cursor.
;;   - In standard buffers: Backs up the currently visited file.
;; Output Format: .bak/filename.ext.YYYYMMDD_HHMMSS.bak

(defun my-backup-file ()
  "Create a timestamped .bak file(s) at file root dir .bak/"
  (interactive)
  (let ((timestamp (format-time-string "%Y%m%d_%H%M%S"))
        (files (cond
                ((derived-mode-p 'dired-mode) (dired-get-marked-files))
                ((buffer-file-name) (list (buffer-file-name)))
                (t nil))))

    (if (not files)
        (message "No file associated with this buffer or point to backup.")
      (dolist (file files)
        (if (file-directory-p file)
            (message "Skipping directory: %s (use a tar/zip command instead)" (file-name-nondirectory file))
          (if (file-exists-p file)
              (let* ((dir (file-name-directory file))
                     (bak-dir (concat (file-name-as-directory dir) ".bak/"))
                     (filename (file-name-nondirectory file))
                     (backup-name (concat bak-dir filename "." timestamp ".bak")))

                ;; 1. Create the .bak/ directory if it doesn't exist
                (unless (file-exists-p bak-dir)
                  (make-directory bak-dir t))

                ;; 2. Sweep the current directory for any existing .bak files and move them
                (dolist (old-bak (directory-files dir t "\\.bak\\'"))
                  (when (file-regular-p old-bak)
                    (rename-file old-bak (concat bak-dir (file-name-nondirectory old-bak)) t)))

                ;; 3. Create the new backup directly inside .bak/
                (copy-file file backup-name nil t t t)
                (message "Backup created inside .bak/: %s" (file-name-nondirectory backup-name)))
            (message "File does not exist: %s" file)))))))

(provide 'my-backup-file)
;; my-backup-file.el --> END OF FILE
