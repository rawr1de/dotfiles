;;;; --- ZIP AND SHARE FILES ---
;; Compresses marked Dired files into a sequentially named archive (share_01.zip)
;; and immediately prompts the user to share the resulting archive via either
;; KDE Connect or Magic Wormhole. Operates locally in the current directory.

(defun my-dired--next-share-zip ()
  "Find the next available sequential share zip filename"
  (let ((i 1)
        (name ""))
    (while (progn
             (setq name (format "share_%02d.zip" i))
             (file-exists-p name))
      (setq i (1+ i)))
    name))

(defun my-dired-zip-and-share ()
  "Zip marked files and prompt to share via KDE Connect or Wormhole"
  (interactive)
  ;; Get relative paths of marked files so the zip doesn't recreate absolute tree
  (let ((files (dired-get-marked-files t)))
    (if (not files)
        (message "No files marked")

      ;; 1. Prompt FIRST. Enforce a valid match (t). C-g aborts entirely.
      (let ((choice (completing-read "Share archive via: " '("KDE Connect" "Magic Wormhole") nil t)))
        (when (not (string-empty-p choice))
          (let ((zip-name (my-dired--next-share-zip)))

            ;; 2. Compress the files ONLY after a sharing choice is confirmed
            (message "Compressing to %s..." zip-name)
            (apply 'call-process "zip" nil nil nil "-r" zip-name files)

            ;; 3. Refresh the Dired buffer to show the new archive
            (revert-buffer)

            ;; 4. Execute the sharing method
            (pcase choice
              ("KDE Connect"
               (let ((phone-id (string-trim (shell-command-to-string "kdeconnect-cli -l --id-only | head -1"))))
                 (if (string-empty-p phone-id)
                     (message "KDE Connect: no device found")
                   ;; Pass absolute path to kdeconnect-cli
                   (if (= 0 (call-process "kdeconnect-cli" nil nil nil "--device" phone-id "--share" (expand-file-name zip-name)))
                       (start-process "notify" nil "notify-send" "--urgency=normal" "kdeconnect-share" (format "Sent: %s" zip-name))
                     (start-process "notify" nil "notify-send" "--urgency=critical" "kdeconnect-share" (format "Failed: %s" zip-name))))))

              ("Magic Wormhole"
               (let ((bash-cmd
                      (format "
                        clear
                        export WAYLAND_DISPLAY=\"${WAYLAND_DISPLAY:-wayland-1}\"
                        export XDG_RUNTIME_DIR=\"${XDG_RUNTIME_DIR:-/run/user/$(id -u)}\"

                        echo -e '\\e[1;36mGenerating Wormhole-rs for %s...\\e[0m\\n'

                        script -q -c \"wormhole-rs send '%s'\" /dev/null | tee /dev/stderr | {
                            CODE=$(grep -m 1 'Wormhole code is:' | sed 's/.*Wormhole code is: \\([^ ]*\\).*/\\1/')
                            echo -n \"$CODE\" | wl-copy > /dev/null 2>&1
                            echo -e \"\\n\\e[1;32m[ Code '$CODE' copied to Wayland Clipboard! ]\\e[0m\" > /dev/stderr
                            cat > /dev/null
                        }

                        echo ''
                        read -s -n 1 -p 'Press ANY KEY to close window...' < /dev/tty
                        " zip-name (expand-file-name zip-name))))

                 (start-process "wormhole-kitty" nil "kitty"
                                "--class" "wormhole-popup"
                                "--title" "Magic Wormhole"
                                "bash" "-c" bash-cmd))))))))))

(provide 'my-dired-zip-and-share)
;; my-dired-zip-and-share.el --> END OF FILE
