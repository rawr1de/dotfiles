;;; ~/.emacs.d/snippets/ripdrag.el
;; ripdrag integration for Dired/Dirvish
;; files marked (or with cursor at point) will be passed asynchronously to
;; ripdrag command-line tool

(defun my-dired-ripdrag ()
  "Drag marked files (or file under point) using ripdrag.
Only works if the current buffer is a Dired or Dirvish buffer."
  (interactive)
  (if (derived-mode-p 'dired-mode)
      (let ((files (dired-get-marked-files)))
        (if files
            (progn
              (message "Dragging %d file(s) with ripdrag..." (length files))
              ;; Use "-a" to enable the "Drag All" window handle
              ;; (apply #'start-process "ripdrag-process" nil "ripdrag" "-a" "-x" files))
	      (apply #'start-process "ripdrag-process" nil
       (append (list "env"
                     (concat "WAYLAND_DISPLAY=" (or (getenv "WAYLAND_DISPLAY") "wayland-1"))
                     (concat "XDG_RUNTIME_DIR=" (or (getenv "XDG_RUNTIME_DIR") (format "/run/user/%d" (user-uid))))
                     "ripdrag" "-a" "-x")
               files))
          (message "No files to drag!")))
    (message "Not in a Dired or Dirvish buffer!"))))


(provide 'ripdrag)
;;; ripdrag.el ends here
