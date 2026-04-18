;; F11: Brute-force fullscreen toggle
;; (because the native Emacs one is broken on Linux WMs).

  (defun my-force-fullscreen-toggle ()
    "Brute-force toggle the fullscreen frame parameter, bypassing native tracking bugs."
    (interactive)
    ;; Check the exact state of the current frame
    (if (memq (frame-parameter nil 'fullscreen) '(fullscreen fullboth))
        ;; If it is fullscreen in any way, explicitly strip the parameter (revert to window)
        (set-frame-parameter nil 'fullscreen nil)
      ;; Otherwise, force it to absolute fullscreen
      (set-frame-parameter nil 'fullscreen 'fullboth)))

  ;; Bind our custom brute-force function to F11
  (global-set-key (kbd "<f11>") #'my-force-fullscreen-toggle)


(provide 'my-force-fullscreen-toggle)
;; my-force-fullscreen-toggle.el  <---  END OF FILE
