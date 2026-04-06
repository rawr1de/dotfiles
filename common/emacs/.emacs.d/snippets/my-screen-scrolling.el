;;;; --- SCREEN LINE SCROLLING
;; scroll down one line
(defun my-scroll-one-line-down ()
  "scroll down one line"
  (interactive)
  (scroll-down 1))

;; scroll up one line
(defun my-scroll-one-line-up ()
  "Scroll up one line"
  (interactive)
  (scroll-up 1))

(provide 'my-screen-scrolling)
