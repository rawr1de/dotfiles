;;;; --- SCREEN LINE SCROLLING

(defun my-scroll-one-line-down ()
  "scroll down one line"
  (interactive)
  (scroll-down 1))

(defun my-scroll-one-line-up ()
  "Scroll up one line"
  (interactive)
  (scroll-up 1))

(provide 'my-screen-scrolling)
;; my-screen-scrolling.el --> END OF FILE
