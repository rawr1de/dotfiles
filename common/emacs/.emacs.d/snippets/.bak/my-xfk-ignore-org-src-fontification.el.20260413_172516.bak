;; strange bug on rdo_dots.org that won't let me type over the src_code block line
;; it kept snapping back to xfk command-mode after the first letter
;; Prevent XFK from resetting state ONLY during Org-mode native fontification
(defun my-xfk-ignore-org-src-fontification (orig-fun &rest args)
  "Only block XFK if Org-mode is doing background syntax highlighting."
  (let ((buf-name (buffer-name)))
    (if (and buf-name (string-prefix-p " *org-src-fontification" buf-name))
        ;; Do nothing (ignore it)
        nil
      ;; Otherwise, run XFK normally
      (apply orig-fun args))))

(advice-add 'xah-fly-command-mode-activate :around #'my-xfk-ignore-org-src-fontification)

(provide 'my-xfk-ignore-org-src-fontification)
;; my-xfk-ignore-org-src-fontification.el <--- END OF FILE
