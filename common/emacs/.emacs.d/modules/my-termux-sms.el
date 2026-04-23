;;; my-termux-sms.el --- Unified Termux SMS Integration for Emacs
;;
;; This script provides a complete, 2-way SMS integration using an Android
;; phone running Termux. It bypasses GUI daemons completely by using SSH
;; to pull the latest unread message and push outgoing replies directly to
;; the cellular network.

;; =====================================================================
;; SECTION 1: CONFIGURATION
;; Define your SSH credentials and hardcoded contacts here.
;; =====================================================================

(defvar my-termux-ssh-ip "192.168.1.71"
  "The local IP address of the Android phone running Termux.")

(defvar my-termux-ssh-user "u0_a563"
  "The Termux sandboxed username (found by typing 'whoami' in Termux).")

(defvar my-termux-ssh-port "8022"
  "The SSH port Termux is listening on (default is usually 8022).")

(defvar my-termux-contacts
  '(("rdo USA"     . "+14709277960")
    ("rdo GOOGLE"  . "+14703773021")
    ("Esther Anjim". "+14709277980")
    ("mama"        . "+15612523516")
    ("rich"        . "+15618469261")
    ("kali"        . "+14704489201")
    ("teresa gigi" . "+14048843554")
    ("brooke"      . "+14704489027")
    ("nega dri"    . "+5562")
    ("beto"        . "+5562")
    ("osvaldo"     . "+5562"))
  "An alist linking contact names to their raw phone numbers.")


;; =====================================================================
;; SECTION 2: UTILITY / PARSING FUNCTIONS
;; Tools to clean strings and look up contact numbers.
;; =====================================================================

(defun my-clean-phone-number (num-str)
  "Strips absolutely everything except raw digits. Preserves leading plus sign."
  (let ((clean (replace-regexp-in-string "[^0-9]" "" (or num-str ""))))
    (if (string-prefix-p "+" (or num-str ""))
        (concat "+" clean)
      clean)))

(defun my-find-contact-by-number (clean-num)
  "Searches `my-termux-contacts' for a matching number. Returns the name or nil.
It uses fuzzy matching so even if the country code is missing, it still matches."
  (let ((matched-name nil))
    (catch 'found
      (dolist (contact my-termux-contacts)
        (let ((stored-num (my-clean-phone-number (cdr contact))))
          (when (and (> (length stored-num) 5)
                     (> (length clean-num) 5)
                     (or (string-match-p stored-num clean-num)
                         (string-match-p clean-num stored-num)))
            (setq matched-name (car contact))
            (throw 'found t)))))
    matched-name))


;; =====================================================================
;; SECTION 3: WINDOW ISOLATION & ABORT LOGIC
;; Handles the temporary floating frame so it doesn't mess up your layout.
;; =====================================================================

(defun my-termux-sms-abort ()
  "Safely kill the temporary SMS buffer and close the isolated frame"
  (interactive)
  (let ((frame (selected-frame)))
    (when (get-buffer "*Last SMS*")
      (kill-buffer "*Last SMS*"))
    (delete-frame frame)))

(define-minor-mode my-termux-sms-mode
  "Minor mode for the isolated Termux SMS buffer to handle clean exits"
  :init-value nil
  :lighter " TermuxSMS"
  :keymap (let ((map (make-sparse-keymap)))
            ;; Map standard cancel commands AND the Escape key to our abort function
            (define-key map (kbd "C-c C-x") #'my-termux-sms-abort)
            (define-key map (kbd "C-c C-k") #'my-termux-sms-abort)
            (define-key map (kbd "<escape>") #'my-termux-sms-abort)
            map))


;; =====================================================================
;; SECTION 4: THE 'SEND' COMMAND
;; Prompts for a message and pushes it out via SSH in the background.
;; =====================================================================

(defun my-termux-send-sms ()
  "Prompt for a contact (or raw number) and send an SMS via Termux SSH"
  (interactive)
  (let* ((name (completing-read "Text who? (Choose or type number): "
                                (mapcar #'car my-termux-contacts)))
         (number (cdr (assoc name my-termux-contacts)))
         (target (my-clean-phone-number (or number name)))
         (ssh-target (concat my-termux-ssh-user "@" my-termux-ssh-ip)))

    ;; Safety Catch: Prevent silent failures if the user types a bad name
    (if (or (string-empty-p target) (equal target "+"))
        (error "Aborted: '%s' is not a valid phone number!" name))

    (let ((msg (read-string (format "Message to %s: " name))))
      ;; Execute the SSH command in a background process
      (start-process "termux-sms-proc" nil
                     "ssh" "-p" my-termux-ssh-port ssh-target
                     "termux-sms-send" "-n" target msg)

      ;; Visual Confirmation (Green highlighting in the echo area)
      (message "%s"
               (propertize (format " ✔ SMS sent to %s via Termux: %s " name msg)
                           'face '(:background "#98c379" :foreground "#282c34" :weight bold)))

      ;; Auto-close the floating frame exactly 1 second after sending
      (run-at-time "1 sec" nil
                   (lambda (f)
                     (when (frame-live-p f)
                       (delete-frame f)))
                   (selected-frame)))))


;; =====================================================================
;; SECTION 5: THE 'PULL' COMMAND (UPGRADED - THREAD VIEW)
;; Fetches 50 messages, groups them to find the last 3 unique contacts,
;; displays up to 3 messages per contact, and prompts to reply.
;; =====================================================================

(defun my-termux-last-sms ()
  "Fetch SMS via Termux API, display up to 3 threads (3 msgs each), and prompt"
  (interactive)
  (message "Fetching latest SMS threads from phone...")

  (let* ((ssh-target (concat my-termux-ssh-user "@" my-termux-ssh-ip))
         ;; Bumped the limit to 50 so we have enough data to pull deeper history
         (cmd (format "ssh -p %s %s 'termux-sms-list -l 50 -t inbox'" my-termux-ssh-port ssh-target))
         (json-str (shell-command-to-string cmd))
         (data (condition-case nil
                   (json-parse-string json-str :object-type 'alist :array-type 'list)
                 (error nil))))

    (if (and data (listp data))
        (let ((contact-order nil)
              (threads (make-hash-table :test 'equal)))

          ;; 1. Loop through the JSON and group messages by contact
          (dolist (entry data)
            (let* ((raw-num (alist-get 'number entry))
                   (clean-num (my-clean-phone-number raw-num)))

              ;; Track up to 3 unique contacts
              (unless (member clean-num contact-order)
                (when (< (length contact-order) 3)
                  (push clean-num contact-order)))

              ;; If this contact is one of our top 3, save up to 3 messages for them
              (when (member clean-num contact-order)
                (let ((msgs (gethash clean-num threads)))
                  (when (< (length msgs) 3)
                    ;; Consing naturally builds the list backwards, which is perfect.
                    ;; It means the oldest of the 3 will print first, reading top-to-bottom.
                    (puthash clean-num (cons entry msgs) threads))))))

          ;; Reverse contact order so the absolute most recent person is at the top of the list
          (setq contact-order (nreverse contact-order))

          (when contact-order
            ;; 2. Spawn the new isolated frame
            (let ((new-frame (make-frame)))
              (select-frame new-frame)
              (set-frame-parameter new-frame 'buffer-predicate (lambda (buf) (eq buf (current-buffer))))

              (let ((buf (get-buffer-create "*Last SMS*")))
                (with-current-buffer buf
                  (erase-buffer)
                  (insert "--- LATEST SMS THREADS ---\n\n")

                  ;; 3. Print the chat logs
                  (dolist (clean-num contact-order)
                    (let* ((msgs (gethash clean-num threads))
                           (contact-name (my-find-contact-by-number clean-num))
                           ;; Fallback to the raw number from the first message if no name found
                           (raw-num (alist-get 'number (car msgs)))
                           (display-name (or contact-name raw-num)))

                      ;; Header for the person
                      (insert (format "=== %s ===\n" display-name))

                      ;; Print their messages
                      (dolist (msg msgs)
                        (let ((body (alist-get 'body msg)))
                          (insert (format ">  %s\n" body))))

                      ;; Space between contacts
                      (insert "\n")))

                  (visual-line-mode 1)
                  (my-termux-sms-mode 1))
                (switch-to-buffer buf))

              (split-window-below)
              (other-window 1)

              ;; 4. Pre-fill the prompt with the absolute most recent contact
              (let* ((mr-clean-num (car contact-order))
                     (mr-contact (my-find-contact-by-number mr-clean-num))
                     (prefill-val (or mr-contact mr-clean-num)))

                (minibuffer-with-setup-hook
                    (lambda () (insert prefill-val))
                  (condition-case nil
                      (call-interactively 'my-termux-send-sms)
                    (quit (my-termux-sms-abort))))))))

      (message "Failed to fetch SMS. Is the phone awake and on Wi-Fi?"))))

(provide 'my-termux-sms)
;;; my-termux-sms.el <--- ENDS HERE
