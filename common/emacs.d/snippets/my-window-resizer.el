;; Smart directional window resizing for Emacs -*- lexical-binding: t -*-
;;
;; Provides functions to resize window splits directionally
;; regardless of which window in the split is currently active.

(defun my-resize-window-up ()
  "Resize the current window split upwards"
  (interactive)
  (if (window-in-direction 'below) (shrink-window 3) (enlarge-window 3)))

(defun my-resize-window-down ()
  "Resize the current window split downwards"
  (interactive)
  (if (window-in-direction 'below) (enlarge-window 3) (shrink-window 3)))

(defun my-resize-window-left ()
  "Resize the current window split to the left"
  (interactive)
  (if (window-in-direction 'right) (shrink-window-horizontally 3) (enlarge-window-horizontally 3)))

(defun my-resize-window-right ()
  "Resize the current window split to the right"
  (interactive)
  (if (window-in-direction 'right) (enlarge-window-horizontally 3) (shrink-window-horizontally 3)))

;; 1. Global directional mapping (i=Up, k=Down, j=Left, l=Right)
(global-set-key (kbd "C-S-i") 'my-resize-window-up)
(global-set-key (kbd "C-S-k") 'my-resize-window-down)
(global-set-key (kbd "C-S-j") 'my-resize-window-left)
(global-set-key (kbd "C-S-l") 'my-resize-window-right)

(with-eval-after-load 'xah-fly-keys
  (define-key xah-fly-leader-key-map (kbd "=") 'balance-windows))

;; 2. Prevent Org-mode from overriding C-S-i (as it confuses it with S-TAB)
(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-S-i") 'my-resize-window-up))

(provide 'my-window-resizer)
;; my-window-resizer.el --> END OF FILE
