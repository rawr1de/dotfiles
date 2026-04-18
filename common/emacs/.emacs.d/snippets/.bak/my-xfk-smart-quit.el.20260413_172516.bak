;; close help/info/apropos/man 'mode' windows while in XFK command-mode with 'q'

(defun my-xfk-smart-quit ()
  "Close window in help buffers, otherwise do standard XFK 'q' action"
  (interactive)
  (if (derived-mode-p 'help-mode 'Info-mode 'apropos-mode 'Man-mode)
      (quit-window)
    (xah-reformat-lines))) ; This is the default 'q' command in XFK QWERTY

;; Bind it directly to the XFK Command Map
(define-key xah-fly-command-map (kbd "q") 'my-xfk-smart-quit)


(provide 'my-xfk-smart-quit)
;; my-xfk-smart-quit.el <--- END OF FILE
