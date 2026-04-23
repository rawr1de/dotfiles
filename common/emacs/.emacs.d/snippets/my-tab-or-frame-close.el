;; combined close-tab to delete-frame

(defun my-tab-or-frame-close ()
 "Close tab if multiple tabs exist, otherwise close frame"
 (interactive)
  (if (> (length (tab-bar-tabs)) 1)
   (tab-close)
   (delete-frame)))


(provide 'my-tab-or-frame-close)
;; my-tab-or-frame-close.el --> END OF FILE
