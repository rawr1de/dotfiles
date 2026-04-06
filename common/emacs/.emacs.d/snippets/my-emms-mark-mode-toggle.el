  ;; "SPC z e" toggle 'emms-mark-mode' on and off
  (defvar my-emms-mark-mode-active nil)
  (defun my-emms-mark-mode-toggle ()
    "Toggle `emms-mark-mode` on and off."
    (interactive)
    (if my-emms-mark-mode-active
        (progn
          (emms-mark-mode-disable)
          (setq my-emms-mark-mode-active nil))
      (progn
        (emms-mark-mode)
        (setq my-emms-mark-mode-active t))))

(provide 'my-emms-mark-mode-toggle)
