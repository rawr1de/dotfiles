;; Kill all buffers except the current one and those with unsaved changes

(defun my-clean-unused-buffers ()
  "Kill all buffers except the current one and those with unsaved changes"
  (interactive)
  (let ((count 0))
    (dolist (buf (buffer-list))
      (let ((name (buffer-name buf)))
        (unless (or (eq buf (current-buffer))
                    (buffer-modified-p buf)
                    (get-buffer-process buf)
                    (string-prefix-p " " name)   ;; Hidden
                    (string-prefix-p "*" name)   ;; Messages/Scratch
                    (member name '(".emacs.d" "init.el"))) ;; Protected
          (kill-buffer buf)
          (setq count (1+ count)))))
    (message "Janitor: %d buffers swept." count)))

(provide 'my-clean-unused-buffers)
;; my-clean-unused-buffers.el --> END OF FILE
