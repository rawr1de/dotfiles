;;;; --- GLOBAL XFK UNIVERSAL SNAP (my-xfk-universal-snap.el)

(defun my-xfk-universal-snap (&optional _)
  "Globally force XFK states based on the major-mode we land in"
  (run-at-time 0.01 nil
               (lambda ()
                 (cond
                  ;; --- 1. FORCE INSERT MODE ---
                  ;; For management buffers: Dired, Dirvish, and EMMS Playlist
                  ((derived-mode-p 'dired-mode 'dirvish-directory-view-mode 'emms-playlist-mode 'my-scratchpad-mode)

                   (when (not xah-fly-insert-state-p)
                     (xah-fly-insert-mode-activate)))

                  ;; --- 2. FORCE COMMAND MODE ---
                  ;; For coding, config, and text editing buffers
                  ((derived-mode-p 'prog-mode 'conf-mode 'text-mode)
                   (when xah-fly-insert-state-p
                     (xah-fly-command-mode-activate)))))))


;; Attach to window and buffer changes
(add-hook 'window-selection-change-functions #'my-xfk-universal-snap)
(add-hook 'buffer-list-update-hook #'my-xfk-universal-snap)

(provide 'my-xfk-universal-snap)
;; my-xfk-universal-snap.el --> END OF FILE
