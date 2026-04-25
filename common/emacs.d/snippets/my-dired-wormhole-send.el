;;; --- MAGIC WORMHOLE (TERMINAL + WAYLAND CLIPBOARD) ---
;; Send file via wormhole-rs in a popup Kitty terminal, trick it into rendering
;; its native QR code, and simultaneously hijack the text code to Wayland clipboard.
(defun my-dired-wormhole-send ()
  "Send file via wormhole-rs in Kitty, show native QR, and auto-copy code."
  (interactive)
  (let ((file (dired-get-filename nil t)))
    (if (not file)
        (message "No file under cursor!")
      (let ((bash-cmd
             (format "
               clear
               export WAYLAND_DISPLAY=\"${WAYLAND_DISPLAY:-wayland-1}\"
               export XDG_RUNTIME_DIR=\"${XDG_RUNTIME_DIR:-/run/user/$(id -u)}\"

               echo -e '\\e[1;36mGenerating Wormhole-rs...\\e[0m\\n'

               script -q -c \"wormhole-rs send '%s'\" /dev/null | tee /dev/stderr | {
                   CODE=$(grep -m 1 'Wormhole code is:' | sed 's/.*Wormhole code is: \\([^ ]*\\).*/\\1/')

                   # wl-copy stays alive in the background. We MUST redirect its
                   # output to /dev/null, otherwise it holds the pipe hostage forever!
                   echo -n \"$CODE\" | wl-copy > /dev/null 2>&1

                   echo -e \"\\n\\e[1;32m[ Code '$CODE' copied to Wayland Clipboard! ]\\e[0m\" > /dev/stderr
                   cat > /dev/null
               }

               echo ''
               read -s -n 1 -p 'Press ANY KEY to close window...' < /dev/tty
               " file)))

        (start-process "wormhole-kitty" nil "kitty"
                       "--class" "wormhole-popup"
                       "--title" "Magic Wormhole"
                       "bash" "-c" bash-cmd)))))

(provide 'my-dired-wormhole-send)
;;; my-dired-wormhole-send.el  <--- ENDS HERE
