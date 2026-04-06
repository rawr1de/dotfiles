;;; --- SYNCTHING NATIVE TRANSFER ---
;; Instantly copy marked files to the Syncthing folder natively (bypassing
;; Dired prompts) and automatically open the Web UI to monitor the transfer.

(defvar my-syncthing-folder "/home/rdo/DLs/0.syncthing_share" "Path to your default Syncthing folder.")

(defun my-dired-syncthing-transfer ()
  "Instantly COPY marked files to the Syncthing folder and open the Web UI.
This strictly COPIES the files. It will never move or delete them."
  (interactive)
  (let ((files (dired-get-marked-files)))
    (if (not (file-directory-p my-syncthing-folder))
        (message "Syncthing folder '%s' does not exist!" my-syncthing-folder)

      ;; Loop through and strictly COPY each marked file natively
      (dolist (file files)
        (let* ((base (file-name-nondirectory file))
               (dest (expand-file-name base my-syncthing-folder)))
          ;; copy-file safely duplicates the data. 't' allows silent overwriting if it already exists there.
          (copy-file file dest t)))

      (message "Successfully COPIED %d file(s) to Syncthing." (length files))

      ;; Pop open the local Web UI to watch the sync status
      (browse-url "http://localhost:8384"))))

(provide 'my-dired-syncthing-transfer)
;;; my-dired-syncthing-transfer.el  <--- ENDS HERE
