;;; my-man-to-org.el --- Render man pages to Org via Pandoc -*- lexical-binding: t; -*-

;; Provides an interactive interface for querying the system manual pages
;; and rendering them dynamically as Org-mode documents. This module leverages
;; the system's native man-db to populate completion candidates in the minibuffer,
;; which integrates seamlessly with Vertico. Once a selection is made, it resolves
;; the raw groff source path and executes a synchronous Pandoc subprocess. The
;; resulting transpiled Abstract Syntax Tree is piped directly into an ephemeral,
;; read-only Emacs buffer, bypassing disk I/O entirely.

(require 'subr-x)
(require 'man)

(defun my-man-to-org ()
  "Render man page as Org-mode using Pandoc directly into a buffer."
  (interactive)

  (unless (executable-find "pandoc")
    (user-error "Pandoc is not installed or not found in `exec-path`"))

  (let* ((raw-page (completing-read "man > " 'Man-completion-table))
         (page-name raw-page)
         (section "")
         (man-cmd ""))

    (save-match-data
      (when (string-match "\\`\\(.*?\\)\\s-*(\\([^)]+\\))\\'" raw-page)
        (setq page-name (match-string 1 raw-page)
              section (match-string 2 raw-page))))

    (setq man-cmd (if (string-empty-p section)
                      (format "man -w %s 2>/dev/null" (shell-quote-argument page-name))
                    (format "man -w %s %s 2>/dev/null"
                            (shell-quote-argument section)
                            (shell-quote-argument page-name))))

    (let* ((man-output (string-trim (shell-command-to-string man-cmd)))
           (man-path (car (split-string man-output "\n" t))))

      (if (or (not (stringp man-path))
              (not (file-exists-p man-path)))
          (error "System Error: Could not locate source file for man page: %s" raw-page)

        (let ((buf (get-buffer-create (format "*Org-Man: %s*" raw-page))))
          (with-current-buffer buf
            (let ((inhibit-read-only t))
              (erase-buffer)

              ;; Emacs handles the decompression seamlessly
              (insert-file-contents man-path)

              ;; Process the decompressed region with Pandoc
              (call-process-region (point-min) (point-max)
                                   "pandoc" t t nil
                                   "-f" "man" "-t" "org")

              (org-mode)
              (goto-char (point-min))
              (read-only-mode 1)))
          (pop-to-buffer buf))))))

(provide 'my-man-to-org)
;;; my-man-to-org.el ends here
