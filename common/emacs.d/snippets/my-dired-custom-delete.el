;; This file defines two custom Dired deletion commands that override the
;; default trash behavior on a per-command basis. `D` is rebound to always
;; send files to the system trash regardless of the global
;; `delete-by-moving-to-trash' setting, while `x' is rebound to always
;; permanently delete files flagged with `d', bypassing the trash entirely.
;; This allows a single Dired session to support both safe (trash) and
;; permanent deletion workflows without having to toggle the global
;; variable manually.

(defun my-dired-do-delete-to-trash ()
  "Delete marked or current file via system trash"
  (interactive)
  (let ((delete-by-moving-to-trash t))
    (dired-do-delete)))

(defun my-dired-do-flagged-delete-permanently ()
  "Permanently delete files flagged with d"
  (interactive)
  (let ((delete-by-moving-to-trash nil))
    (dired-do-flagged-delete)))

(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "D") #'my-dired-do-delete-to-trash)
  (define-key dired-mode-map (kbd "x") #'my-dired-do-flagged-delete-permanently))

(provide 'my-dired-custom-delete)
;; my-dired-custom-delete.el --> END OF FILE
