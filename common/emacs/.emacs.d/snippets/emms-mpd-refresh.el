;;;; --- EMMS REFRESH CACHE AND UPDATE DB

(defun my-emms-mpd-refresh ()
  "Fully refresh MPD + EMMS cache when files change."
  (interactive)
  (message "Updating MPD database...")
  (emms-player-mpd-update-all)
  (sleep-for 0.5)                    ; small pause so MPD can finish
  (emms-cache-reset)
  (emms-cache-set-from-mpd-all)
  (message "EMMS + MPD refresh completed."))


(provide 'emms-mpd-refresh)
;;; emms-mpd-refresh.el <-- ENDS HERE
