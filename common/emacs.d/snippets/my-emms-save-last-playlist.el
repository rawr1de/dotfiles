;; Auto-Save Playlist Function
;; my-emms-save-last-playlist.el

  (defun my-emms-save-last-playlist ()
    "Instantly save the current EMMS playlist to ~/Musk/_plts/last.m3u."
    (interactive)
    (let ((target "~/Musk/_plts/last.m3u"))
      (emms-playlist-save 'm3u target)
      (message "Playlist state saved to %s" target)))

(provide 'my-emms-save-last-playlist)
