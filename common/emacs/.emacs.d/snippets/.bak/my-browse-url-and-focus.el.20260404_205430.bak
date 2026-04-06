(defun my-browse-url-and-focus (url &optional new-window)
  "Open URL and explicitly command Niri to focus the web browser."
  (interactive "sURL: ")
  ;; 1. Open the URL using the default system handler
  (browse-url-default-browser url new-window)

  ;; 2. Wait 0.1s for the link to register, then find the specific window ID
  (run-at-time 0.1 nil
               (lambda ()
                 (let* ((json-string (shell-command-to-string "niri msg -j windows"))
                        ;; Parse Niri's JSON output natively in Emacs
                        (windows (condition-case nil
                                     (json-parse-string json-string :object-type 'alist :array-type 'list)
                                   (error nil)))
                        (browser-id nil))

                   ;; Loop through the windows to find Firefox
                   (catch 'found
                     (dolist (win windows)
                       (let ((app-id (alist-get 'app_id win)))
                         ;; Match "firefox" (handles standard, developer edition, etc.)
                         (when (and (stringp app-id) (string-match-p "firefox" app-id))
                           (setq browser-id (alist-get 'id win))
                           (throw 'found t)))))

                   ;; If we found the exact ID, tell Niri to focus it
                   (when browser-id
                     (start-process "niri-focus" nil "niri" "msg" "action" "focus-window" "--id" (format "%s" browser-id)))))))

;; Tell Emacs to use our new function for all web links
(setq browse-url-browser-function 'my-browse-url-and-focus)

(provide 'my-browse-url-and-focus)
