;;; --- EMMS NOW PLAYING POPUP (Pixel-Perfect Kitty Dashboard with MPV IPC) ---

(defun my-emms-now-playing-popup ()
  "Spawn a floating Kitty terminal displaying EMMS track info, high-res album art, and live MPV progress."
  (interactive)
  (let* ((track (emms-playlist-current-selected-track))
         (path (when track (emms-track-get track 'name)))
         (artist (if track (emms-track-get track 'info-artist "Unknown Artist") "No Track"))
         (album (if track (emms-track-get track 'info-album "Unknown Album") "No Track"))
         (title (if track (emms-track-get track 'info-title (file-name-nondirectory (or path "Unknown Track"))) "No Track"))
         (dir (when path (file-name-directory path)))
         (cover (when (and dir (file-exists-p dir))
                  (car (directory-files-recursively dir "\\.\\(jpg\\|jpeg\\|png\\|bmp\\|webp\\|gif\\)$"))))

         ;; Fetch track times natively from Emacs
         (total-sec (if track (emms-track-get track 'info-playing-time 0) 0))
         (current-sec (if (boundp 'emms-playing-time) emms-playing-time 0))

         ;; Grab the actual IPC socket path that EMMS is using to talk to MPV
         (mpv-sock (if (bound-and-true-p emms-player-mpv-ipc-socket)
                       (expand-file-name emms-player-mpv-ipc-socket)
                     ""))

         ;; Assemble the Bash script that Kitty will execute
         (bash-script
          (format "
            clear
            echo -ne '\\e[?25l' # Hide the blinking terminal cursor

            COLS=$(tput cols)
            LINES=$(tput lines)
            IMG_LINES=$((LINES - 6))

            # Draw the image
            %s

            # Print static metadata
            tput cup $IMG_LINES 0
            echo -e '  \\e[1;37m Title:\\e[0m  \\e[1;32m%s\\e[0m'
            echo -e '  \\e[1;37mArtist:\\e[0m  \\e[1;36m%s\\e[0m'
            echo -e '  \\e[1;37m Album:\\e[0m  \\e[1;33m%s\\e[0m'

            # Variables
            CUR_SEC=%d
            TOT_SEC=%d
            MPV_SOCK='%s'
            PROG_LINE=$((LINES - 2))

            while true; do
              # Clamp current time
              if [ $CUR_SEC -gt $TOT_SEC ] && [ $TOT_SEC -gt 0 ]; then CUR_SEC=$TOT_SEC; fi

              # Calculate Minutes and Seconds
              CUR_MIN=$((CUR_SEC / 60))
              CUR_S=$((CUR_SEC %% 60))
              TOT_MIN=$((TOT_SEC / 60))
              TOT_S=$((TOT_SEC %% 60))
              TIME_STR=$(printf \"%%02d:%%02d/%%02d:%%02d\" $CUR_MIN $CUR_S $TOT_MIN $TOT_S)

              # Calculate Bar Widths
              BAR_WIDTH=$((COLS - 18))
              if [ $BAR_WIDTH -lt 10 ]; then BAR_WIDTH=10; fi

              if [ $TOT_SEC -gt 0 ]; then
                FILLED=$(( CUR_SEC * BAR_WIDTH / TOT_SEC ))
              else
                FILLED=0
              fi
              EMPTY=$(( BAR_WIDTH - FILLED ))

              # Generate Bar
              BAR_FILLED=$(printf '%%*s' \"$FILLED\" | tr ' ' '=')
              BAR_EMPTY=$(printf '%%*s' \"$EMPTY\" | tr ' ' '.')

              # Print UI
              tput cup $PROG_LINE 0
              echo -ne \"\\033[2K\"
              echo -ne \"  \\e[1;34m${BAR_FILLED}\\e[0m\\e[1;30m${BAR_EMPTY}\\e[0m \\e[1;37m${TIME_STR}\\e[0m\"

              # Wait 1 second. Exit if key pressed.
              if read -n 1 -s -t 1; then
                break
              fi

              # ---> FALLBACK: Always tick the clock forward 1 second
              if [ $TOT_SEC -gt 0 ]; then
                CUR_SEC=$((CUR_SEC + 1))
              fi

              # ---> SYNC: Attempt to fetch precise time from MPV to correct drift/pauses
              if [ -n \"$MPV_SOCK\" ] && [ -S \"$MPV_SOCK\" ] && command -v socat &> /dev/null; then
                # Ask MPV for time, use UNIX-CONNECT, and parse instantly to avoid hanging
                SYNC_TIME=$(echo '{\"command\": [\"get_property\", \"time-pos\"]}' | socat -t 0.1 - UNIX-CONNECT:\"$MPV_SOCK\" 2>/dev/null | grep -m 1 '\"data\":' | sed 's/.*\"data\":\\([0-9]*\\).*/\\1/')

                # If we successfully extracted a number, sync the clock!
                if [ -n \"$SYNC_TIME\" ] && [ \"$SYNC_TIME\" -eq \"$SYNC_TIME\" ] 2>/dev/null; then
                  CUR_SEC=$SYNC_TIME
                fi
              fi
            done

            echo -ne '\\e[?25h' # Restore cursor
            exit"
            (if cover (format "kitty +kitten icat --align center --place ${COLS}x${IMG_LINES}@0x0 '%s'" cover) "")
            title artist album
            current-sec total-sec mpv-sock)))

    ;; Spawn Kitty
    (start-process "emms-kitty-popup" nil "kitty"
                   "--class" "emms-popup"
                   "--title" "emms-popup"
                   "-o" "tab_bar_style=hidden"
                   "-o" "hide_window_decorations=yes"
                   "bash" "-c" bash-script)))


(provide 'my-emms-now-playing-popup)
