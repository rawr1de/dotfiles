;; Dynamically build the path based on the proxy redirect!
(add-to-list 'load-path (expand-file-name "modules/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "snippets/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))
(setq tempel-path (expand-file-name "tempel-templates" user-emacs-directory))

;; Fix for Arch Linux: exiftool is in /usr/bin/vendor_perl
(add-to-list 'exec-path "/usr/bin/vendor_perl")
(setenv "PATH" (concat "/usr/bin/vendor_perl:" (getenv "PATH")))
(with-eval-after-load 'custom
  (custom-set-faces '(default ((t (:background unspecified))))))

;; modules
(require 'system)
(require 'ui)
(require 'file-manager)
(require 'musk)
(require 'tools)

;; functions (snippets)
(require 'my-scratchpad)
(require 'my-termux-sms)
(require 'my-force-fullscreen-toggle)
(require 'my-colored-jump-marks)
(require 'my-ripdrag)
(require 'my-dired-copy-file-to-clipboard)
(require 'my-mini-calc)
(require 'my-org-column-sum)
(require 'my-increment-number-decimal)
(require 'my-eval-replace)
(require 'my-package-filter)
(require 'my-lyrics-formatter)
(require 'my-emms-mpd-refresh)
(require 'my-convert-md-to-org)
(require 'my-org-tables-align)
(require 'my-emms-now-playing-popup)
(require 'my-musk-show-album-art)
(require 'my-dired-kdeconnect-share)
(require 'my-dired-wormhole-send)
(require 'my-dired-syncthing-transfer)
(require 'my-backup-file)
(require 'my-batt-conserv-change)
(require 'my-browse-url-and-focus)
(require 'my-tab-or-frame-close)
(require 'my-screen-scrolling)
(require 'my-org-table-enclose)

;; download xah-fly-keys if dir/files do not exist
(defvar my-xfk-dir (expand-file-name "lisp/" user-emacs-directory))
(defvar my-xfk-file (expand-file-name "xah-fly-keys.el" my-xfk-dir))

;; 1. Check if the file is missing
(unless (file-exists-p my-xfk-file)
  (message "xah-fly-keys not found. Cloning directly into lisp/...")

  ;; 2. Ensure the directory exists
  (make-directory my-xfk-dir t)

  ;; 3. Clone straight into the lisp directory
  (let ((clone-status
         (call-process "git" nil "*git-clone-xfk*" nil
                       "clone" "https://github.com/xahlee/xah-fly-keys" my-xfk-dir)))
    (if (eq clone-status 0)
        (message "xah-fly-keys cloned successfully!")
      (error "Failed to clone xah-fly-keys. Check the *git-clone-xfk* buffer for errors."))))

  (use-package xah-fly-keys
    :config
    (setq xah-fly-use-control-key t)
    (setq xah-fly-command-mode-cursor-color nil)
    (setq xah-fly-insert-mode-cursor-color nil)
    (xah-fly-keys-set-layout "qwerty")
    (xah-fly-keys 1))
    (add-hook 'server-after-make-frame-hook 'xah-fly-command-mode-activate)
    (global-set-key (kbd "<home>") 'xah-fly-command-mode-activate)

     ;; COMMAND MODE EVERYWHERE!
     (add-hook 'find-file-hook #'xah-fly-command-mode-activate)
     (add-hook 'after-change-major-mode-hook #'xah-fly-command-mode-activate)

;; ORG-MODE
(with-eval-after-load 'org
  ;; Force C-k to be a dead-end (does absolutely nothing)
  (define-key org-mode-map (kbd "C-k") #'ignore)

  ;; Force C-i to be a dead-end
  (define-key org-mode-map (kbd "C-i") #'ignore)
)

;; ==============================================
;; TERMINAL COLLISION (DAEMON & STANDALONE SAFE)
;; ==============================================

(defun my-apply-terminal-key-decodes (&optional frame)
  "Apply input-decode-map to the current frame. Mandatory for emacsclient."
  (with-selected-frame (or frame (selected-frame))
    ;; We must check if we are in a GUI or a terminal, because TTYs handle this differently
    (when (display-graphic-p)
      (define-key input-decode-map (kbd "C-i") (kbd "<C-i>"))
      (define-key input-decode-map (kbd "C-m") (kbd "<C-m>")))))

;; 1. Run it immediately for standalone Emacs (if you aren't using the daemon)
(my-apply-terminal-key-decodes)

;; 2. Force the Daemon to run it every time you connect a new emacsclient frame
(add-hook 'after-make-frame-functions #'my-apply-terminal-key-decodes)


;; XFK MODAL
  ;; [SPC a]
  (define-key xah-fly-leader-key-map (kbd "a") nil)
;; OTHER
  ;; dired-jump
  (define-key ctl-x-map (kbd "C-j") nil)
  ;; mark-paragraph
  (define-key global-map (kbd "M-h") nil)



;; EMMS BROWSER MAP NUKE!
;; (with-eval-after-load 'emms-browser
  ;; (setq emms-browser-mode-map (make-sparse-keymap)))

;; EMMS PLAYLIST MAP NUKE!
(with-eval-after-load 'emms-playlist-mode
  ;; (setq emms-playlist-mode-map (make-sparse-keymap))
  (define-key emms-playlist-mode-map (kbd "a") nil)
  ;; insert single track (emms)
  (define-key emms-playlist-mode-map (kbd "i") nil)
  (define-key emms-playlist-mode-map (kbd "p") nil)
  (define-key emms-playlist-mode-map (kbd "g") nil)
  (define-key emms-playlist-mode-map (kbd "w") nil)
  ;; (define-key emms-playlist-mode-map (kbd "S-i") nil)
  ;; (define-key emms-playlist-mode-map (kbd "S-k") nil)
)

;; kill buffer with no confirmation (!)
(global-set-key (kbd "C-w") 'my-kill-buffer-no-confirm)
;; toggle XFK modal
(global-set-key (kbd "<f12>") 'xah-fly-keys)

;; toggle corfu GLOBALLY
(global-set-key (kbd "<C-f12>") #'global-corfu-mode)
;; toggle corfu LOCALLY
;; (global-set-key (kbd "<C-f12>") #'corfu-mode)

;; Explicitly bind the GUI <f11> key to the native toggle command
;; (global-set-key (kbd "<f11>") #'toggle-frame-fullscreen)

;; custom functions skel template, auto save in:
;; "~/.dotfiles/common/emacs/.emacs.d/snippets/"
(global-set-key (kbd "C-c e") #'my-generate-elisp-file)

(global-set-key (kbd "C-S-i") 'enlarge-window)
(global-set-key (kbd "C-S-k") 'shrink-window)
(global-set-key (kbd "C-S-l") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-j") 'shrink-window-horizontally)
(define-key xah-fly-leader-key-map (kbd "=") 'balance-windows)

;; cycle through tabs
(global-set-key (kbd "C-S-o") 'tab-next)
;; close tab & frame
(global-set-key (kbd "C-S-w") 'my-tab-or-frame-close)
;; open/jump to new tab
(define-key xah-fly-key-map (kbd "SPC t") 'tab-new)
;; disable (hide) tabs
(define-key xah-fly-key-map (kbd "SPC T") 'tab-bar-mode)

(global-set-key (kbd "M-i") 'my-scroll-one-line-down)
(global-set-key (kbd "M-k") 'my-scroll-one-line-up)

(defun config-visit ()
  (interactive)
  (find-file (expand-file-name "base_cfg.org" user-emacs-directory)))
(global-set-key (kbd "C-c 9") 'config-visit)

(defun config-visit-dots ()
  (interactive)
  (find-file (expand-file-name "~/.dotfiles/common/rdo_dots.org")))
(global-set-key (kbd "C-c 0") 'config-visit-dots)

(defun my-tangle-and-load ()
  (when (string= (buffer-file-name)
                 (expand-file-name "~/.emacs.d/base_cfg.org"))
    (org-babel-tangle)
    (load-file (expand-file-name "~/.emacs.d/base_cfg.el"))))
(add-hook 'after-save-hook #'my-tangle-and-load)

(define-key xah-fly-leader-key-map (kbd "0") 'my-set-cycle-mark)
(define-key xah-fly-command-map    (kbd "0") 'my-jump-cycle-mark)
(define-key xah-fly-leader-key-map (kbd "9") 'my-clear-all-cycle-marks)
(define-key xah-fly-leader-key-map (kbd "c") 'my-mini-calc)
(define-key xah-fly-leader-key-map (kbd ", b") 'my-backup-file)
(define-key xah-fly-leader-key-map (kbd "+") 'my-termux-send-sms)
(define-key xah-fly-leader-key-map (kbd ", s") 'save-buffer)
(define-key xah-fly-leader-key-map (kbd "u") 'consult-buffer)
(define-key xah-fly-leader-key-map (kbd "s") 'consult-line)
(define-key xah-fly-leader-key-map (kbd "S") 'isearch-forward-word)
(define-key xah-fly-leader-key-map (kbd "r") 'replace-string)
(define-key xah-fly-leader-key-map (kbd "R") 'query-replace)
(define-key xah-fly-leader-key-map (kbd "f") 'ibuffer)
(define-key xah-fly-leader-key-map (kbd "SPC") 'kill-line)
(define-key xah-fly-leader-key-map (kbd ";") 'consult-ripgrep)
(define-key xah-fly-key-map (kbd "n") 'consult-line)

(define-key xah-fly-key-map (kbd "5") 'delete-char)
(define-key xah-fly-key-map (kbd "6") 'xah-select-block)
(define-key xah-fly-key-map (kbd "7") 'xah-select-line)
(define-key xah-fly-key-map (kbd "8") 'xah-select-text-in-quote)

;; close help/info/apropos/man 'mode' windows
;; while in XFK command-mode with 'q'
(with-eval-after-load 'xah-fly-keys
  (require 'my-xfk-smart-quit)
  (define-key xah-fly-command-map (kbd "q") 'my-xfk-smart-quit))

;; submap definition
(defvar my-xah-org-prefix-map (make-sparse-keymap) "Org-mode sub-menu for XFK")

;; add submap keys here...
(define-key my-xah-org-prefix-map (kbd "s") 'my-org-column-sum)
(define-key my-xah-org-prefix-map (kbd "t") 'org-todo)

;; sub-map contextual logic for XFK
;; "SPC 1" ripdrag in Dired, other in Org-mode
;; ripdrag marked/pointer file(s)
(define-key xah-fly-leader-key-map (kbd "1")
  '(menu-item "Contextual 1" nil
              :filter (lambda (_)
                        (cond
                         ((derived-mode-p 'dired-mode) 'my-dired-ripdrag)
                         ((derived-mode-p 'org-mode) my-xah-org-prefix-map)
                         (t nil)))))

;; "SPC 2" copy ripdrag in Dired, other in Org-mode
;; copy marked/pointer file(s) to memory (easy Ctrl+v drop in web sites)
(define-key xah-fly-leader-key-map (kbd "2")
  '(menu-item "Contextual 2" nil
     :filter (lambda (_)
               (cond
                ((derived-mode-p 'dired-mode) 'my-dired-copy-file-to-clipboard)
                ((derived-mode-p 'org-mode) my-xah-org-prefix-map)
                (t nil)))))

(with-eval-after-load 'org
    ;; 1. The custom function to check for snippets before Org folds trees
    (defun my-org-try-tempel-expand ()
      "Try expanding Tempel snippet. Return t if expanded, stopping org-cycle."
      (require 'tempel)
      ;; tempel-expand without arguments acts as a silent checker.
      ;; It returns data ONLY if there is an exact match (like <s).
      (let ((exact-match (tempel-expand)))
        (when exact-match
          (tempel-expand t) ;; Force the actual expansion!
          t)))              ;; Return t to tell Org-mode: "I handled this, stop!"

    ;; 2. Attach it to Org's native TAB interceptor hook
    (add-hook 'org-tab-first-hook #'my-org-try-tempel-expand)

    ;; 3. Ensure TAB is mapped to org-cycle normally so the hook can do its job
    (define-key org-mode-map (kbd "<tab>") #'org-cycle)
    (define-key org-mode-map (kbd "TAB") #'org-cycle))

;; dired/dirvish keys
(with-eval-after-load 'dired
  ;; Bind a key in all Dired/Dirvish buffers
  (define-key dired-mode-map (kbd "\\")    #'dired-narrow-fuzzy)
  (define-key dired-mode-map (kbd "n")     #'consult-line)
  (define-key dired-mode-map (kbd "h")     #'dired-maybe-insert-subdir))

(with-eval-after-load 'dirvish
  ;; 1. This catches your physical Ctrl+I (because input-decode-map saved it)
  (define-key dirvish-mode-map (kbd "<C-i>") #'dired-prev-subdir)

  ;; 2. This catches your physical Tab key (Emacs' fallback for <tab>)
  (define-key dirvish-mode-map (kbd "TAB") #'dirvish-subtree-toggle)

  ;; 3. Your other bindings
  (define-key dirvish-mode-map (kbd "C-k") #'dired-next-subdir)
  (define-key dirvish-mode-map (kbd "z")   #'describe-mode)
  (define-key dirvish-mode-map (kbd "b")   #'xah-pop-local-mark-ring))

;; 1. create a brand new keymap
(defvar my-dired-spc-map (make-sparse-keymap)
  "Custom SPC leader map for Dired/Dirvish in Insert Mode")

;; 2. nuke the useless 'dired-next-line' binding
(define-key dired-mode-map (kbd "SPC") nil)

;; 3. bind SPC to our new map
(define-key dired-mode-map (kbd "SPC") my-dired-spc-map)

;; 4. tell which-key what this menu is called
(with-eval-after-load 'which-key
  (which-key-add-major-mode-key-based-replacements 'dired-mode
    "SPC" "Dirvish Menu"))

;; 5. menus items
(define-key my-dired-spc-map (kbd "1") '("drag/drop"       . my-dired-ripdrag))
(define-key my-dired-spc-map (kbd "2") '("wl-copy"         . my-dired-copy-file-to-clipboard))
(define-key my-dired-spc-map (kbd "m") '("dired-jump"      . dired-jump))
(define-key my-dired-spc-map (kbd "u") '("consult-buffer"  . consult-buffer))
(define-key my-dired-spc-map (kbd ";") '("consult-ripgrep" . consult-ripgrep))
(define-key my-dired-spc-map (kbd "f") '("iBuffer"         . ibuffer))
(define-key my-dired-spc-map (kbd "r") '("ranger-rename"   . my-ranger-renaming))
(define-key my-dired-spc-map (kbd "z") '("zip/share > phone" . my-dired-zip-and-share))
(define-key my-dired-spc-map (kbd "b") '("backup files"    . my-backup-file))

(defvar my-dired-rename-map (make-sparse-keymap) "Ranger Renaming Map")
(define-key my-dired-spc-map (kbd "r") my-dired-rename-map)
(with-eval-after-load 'which-key
  (which-key-add-keymap-based-replacements my-dired-spc-map "r" "Rename Menu"))

;; Bind the Ranger functions
(define-key my-dired-rename-map (kbd "r") '("rm standard" . my-ranger-rename-standard))
(define-key my-dired-rename-map (kbd "a") '("append" . my-ranger-rename-append))
(define-key my-dired-rename-map (kbd "A") '("Appen/Absolute" . my-ranger-rename-append-end))
(define-key my-dired-rename-map (kbd "i") '("Insert" . my-ranger-rename-prepend))
(define-key my-dired-rename-map (kbd "e") '("Extension" . my-ranger-rename-extension))
(define-key my-dired-rename-map (kbd "u") '("spc → _" . dirvish-rename-space-to-underscore))
(define-key my-dired-rename-map (kbd "w") '("wDired" . dired-toggle-read-only))

;; 1. Create the new Share Sub-Map
(defvar my-dired-share-map (make-sparse-keymap) "Share to Phone Map")

;; 2. Attach the Share map to 'p' INSIDE your main SPC map
(define-key my-dired-spc-map (kbd "p") my-dired-share-map)

;; 3. Tell which-key what to call this menu
(with-eval-after-load 'which-key
  (which-key-add-keymap-based-replacements my-dired-spc-map "p" "Share Menu"))

;; 4. Bind the share functions INTO THE SHARE MAP (not the spc map!)
(define-key my-dired-share-map (kbd "k") '("to phone > KDE"   . my-dired-kdeconnect-share))
(define-key my-dired-share-map (kbd "w") '("to phone > worm"  . my-dired-wormhole-send))
(define-key my-dired-share-map (kbd "s") '("syncthing folder" . my-dired-syncthing-transfer))

(with-eval-after-load 'ibuffer
  ;; 1. Create a brand new keymap
  (defvar my-ibuffer-spc-map (make-sparse-keymap)
    "Custom SPC leader map for Ibuffer in Insert Mode.")

  ;; 2. Nuke the default SPC binding in Ibuffer
  (define-key ibuffer-mode-map (kbd "SPC") nil)

  ;; 3. Bind SPC to our new map
  (define-key ibuffer-mode-map (kbd "SPC") my-ibuffer-spc-map)

  ;; 4. Tell which-key what this menu is called
  (with-eval-after-load 'which-key
    (which-key-add-major-mode-key-based-replacements 'ibuffer-mode
      "SPC" "Ibuffer Menu"))

  ;; 5. Populate the menu
  (define-key my-ibuffer-spc-map (kbd "m") '("dired-jump" . dired-jump))
  (define-key my-ibuffer-spc-map (kbd "f") '("Filter by Mode" . ibuffer-filter-by-mode))
  (define-key my-ibuffer-spc-map (kbd "c") '("Clear Filters" . ibuffer-filter-disable))
  (define-key my-ibuffer-spc-map (kbd "u") '("consult-buffer" . consult-buffer))
  (define-key my-ibuffer-spc-map (kbd "k") '("kill-lines" . ibuffer-do-kill-lines))
  (define-key my-ibuffer-spc-map (kbd "s") '("Save (Write)" . ibuffer-do-save)))
  (define-key my-ibuffer-spc-map (kbd "a") '("Clean Unused" . my-clean-unused-buffers))

  ;; iBuffer navigation
  (define-key ibuffer-mode-map  (kbd "k") '("next line " . ibuffer-forward-line))
  (define-key ibuffer-mode-map  (kbd "i") '("prev line" . ibuffer-backward-line))

(set-register ?a (cons 'file "~/Desk/Dropbox/orgriz/[PERSO]_agenda_2026.org"))
(set-register ?h (cons 'file "~/Desk/Dropbox/orgriz/health.org"))
(set-register ?s (cons 'file "~/Docs/10.Org/trading-study-tracker.org"))
(set-register ?t (cons 'file "~/Docs/10.Org/trading-log.org"))
(set-register ?p (cons 'file "~/Docs/10.Org/personal-searches.org"))
(set-register ?f (cons 'file "~/Docs/10.Org/system-tickets.org"))
(set-register ?i (cons 'file "~/Docs/10.Org/roam/life/20260421170118-life_hub_index.org"))
(set-register ?l (cons 'file "~/Docs/10.Org/roam/tech/20260417193707-tech_hub_index.org"))
(set-register ?e (cons 'file "~/Docs/10.Org/roam/tech/20260421144405-emacs_journey.org"))

(defvar z-emms-map (make-sparse-keymap))
(define-key xah-fly-leader-key-map (kbd "z") z-emms-map)

;; --- RIGHT HAND: Playback (Home Row Cluster) ---
(define-key z-emms-map (kbd "j") '("previous song" . emms-previous))
(define-key z-emms-map (kbd "k") '("next song" . emms-next))
(define-key z-emms-map (kbd ";") '("playing popup" . my-emms-now-playing-popup))
(define-key z-emms-map (kbd "h") '("show artwork" . my-musk-show-album-art))
(define-key z-emms-map (kbd "l") '("stop" . emms-stop))
(define-key z-emms-map (kbd "SPC") #'("pause" . emms-pause))
(define-key z-emms-map (kbd "RET") #'("add to emms" . my-dirvish-enqueue-emms))

;; --- LEFT HAND: Management ---
(define-key z-emms-map (kbd "a") '("add/jump to emms" . my-dirvish-enqueue-emms-go))
(define-key z-emms-map (kbd "s") '("save playlist" . my-emms-save-last-playlist))
(define-key z-emms-map (kbd "f") '("jump to playlist" . emms-playlist-mode-go))
(define-key z-emms-map (kbd "z") '("smart-browse" . emms-smart-browse))
;; "d" load/jump to emms last playlist saved
(define-key z-emms-map (kbd "d")
  (lambda () (interactive)
    (emms-add-playlist "~/Musk/_plts/last.m3u")
    (emms-playlist-mode-go)))

;; --- UTILITY ---
(define-key z-emms-map (kbd "u") '("sync metadata" . musk-sync-music-metadata))
(define-key z-emms-map (kbd "e") '("toggle mark-mode" . my-emms-mark-mode-toggle))

;; descriptions for which-key z-emms-map
(which-key-add-keymap-based-replacements z-emms-map
  "d"   "load last plist")

(add-hook 'emms-playlist-mode-hook
      (lambda ()
        ;; 1. Turn on the current-line highlight
        (hl-line-mode 1)

        ;; 2. Override the color locally (only in this buffer)
        (face-remap-add-relative 'hl-line
                                 :background "#3e4451"
                                 :foreground "#61afef"
                                 :weight 'bold)))

;; my 'blank slate' keybinds
(define-key emms-playlist-mode-map (kbd "i")   'previous-line)
(define-key emms-playlist-mode-map (kbd "k")   'next-line)
(define-key emms-playlist-mode-map (kbd "K")   'end-of-buffer)
(define-key emms-playlist-mode-map (kbd "I")   'beginning-of-buffer)
(define-key emms-playlist-mode-map (kbd "RET") 'emms-playlist-mode-play-current-track)
(define-key emms-playlist-mode-map (kbd "SPC") 'emms-pause)
(define-key emms-playlist-mode-map (kbd "v")   'emms-stop)
(define-key emms-playlist-mode-map (kbd "m")   'emms-next)
(define-key emms-playlist-mode-map (kbd "n")   'emms-previous)
(define-key emms-playlist-mode-map (kbd ",")   'xah-next-window-or-frame)
(define-key emms-playlist-mode-map (kbd ";")   'my-emms-now-playing-popup)
(define-key emms-playlist-mode-map (kbd "h")   'my-musk-show-album-art)
(define-key emms-playlist-mode-map (kbd "d")   'emms-playlist-mode-goto-dired-at-point)
(define-key emms-playlist-mode-map (kbd "q")   'emms-playlist-mode-bury-buffer)
(define-key emms-playlist-mode-map (kbd "D")   'emms-playlist-mode-kill-track)
(define-key emms-playlist-mode-map (kbd "C")   'emms-playlist-clear)
(define-key emms-playlist-mode-map (kbd "'")   'delete-other-windows)
(define-key emms-playlist-mode-map (kbd "y")   'emms-playlist-mode-center-current)

;; shift tracks
(define-key emms-playlist-mode-map (kbd "<C-i>") 'emms-playlist-mode-shift-track-up)
(define-key emms-playlist-mode-map (kbd "C-k")   'emms-playlist-mode-shift-track-down)

;; volume (MPV internal)
(define-key emms-playlist-mode-map (kbd "u") (lambda () (interactive) (musk-volume-change -5)))
(define-key emms-playlist-mode-map (kbd "o") (lambda () (interactive) (musk-volume-change  5)))
(define-key emms-playlist-mode-map (kbd "U") (lambda () (interactive) (musk-volume-change -1)))
(define-key emms-playlist-mode-map (kbd "O") (lambda () (interactive) (musk-volume-change  1)))

;; seek 5sec
(define-key emms-playlist-mode-map (kbd "j") (lambda () (interactive) (emms-seek -5)))
(define-key emms-playlist-mode-map (kbd "l") (lambda () (interactive) (emms-seek  5)))

;; set this AFTER the keybinds
;; (set-face-attribute 'emms-playlist-selected-face nil
                    ;; :background "#3e4451" ; A subtle grey-blue
                    ;; :foreground "#61afef" ; Blue text
;; :weight 'bold)

;; my 'blank slate' keybinds
(define-key emms-browser-mode-map (kbd "i")     #'previous-line)
(define-key emms-browser-mode-map (kbd "k")     #'next-line)
(define-key emms-browser-mode-map (kbd "SPC")   #'emms-browser-toggle-subitems-recursively)
(define-key emms-browser-mode-map (kbd "<tab>") #'emms-playlist-mode-go)
(define-key emms-browser-mode-map (kbd "a")     #'emms-browser-add-tracks)
(define-key emms-browser-mode-map (kbd "RET")   #'emms-browser-add-tracks-and-play)
(define-key emms-browser-mode-map (kbd ",")     #'xah-next-window-or-frame)
;; (define-key emms-browser-mode-map (kbd "1")     #'emms-browser-collapse-all)
;; (define-key emms-browser-mode-map (kbd "2")     #'emms-browser-expand-level-2)
;; (define-key emms-browser-mode-map (kbd "3")     #'emms-browser-expand-level-3)
;; (define-key emms-browser-mode-map (kbd "4")     #'emms-browser-expand-all)

(with-eval-after-load 'emms-tag-editor
  (define-key emms-tag-editor-mode-map (kbd "C-c C-c") 'emms-tag-editor-submit))

(global-set-key (kbd "C-c c") 'org-capture)

(global-set-key (kbd "C-c n l") 'org-roam-buffer-toggle)
(global-set-key (kbd "C-c n f") 'org-roam-node-find)
(global-set-key (kbd "C-c n g") 'org-roam-graph)
(global-set-key (kbd "C-c n i") 'org-roam-node-insert)
(global-set-key (kbd "C-c n c") 'org-roam-capture)

;; Bind the map to 'SPC q'
(define-key xah-fly-leader-key-map (kbd "\\") my-embrace-map)

;; The Core 3 Commands
(define-key my-embrace-map (kbd "a") #'embrace-add)
(define-key my-embrace-map (kbd "c") #'embrace-change)
(define-key my-embrace-map (kbd "d") #'embrace-delete)

(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this))
  :config (setq mc/always-run-for-all t))

;; toggle US/BR dictionaries
(global-set-key (kbd "C-c <f11>") 'my-toggle-spell-language)
;; toggle on-the-fly spell checking
(global-set-key (kbd "C-c <f12>") 'flyspell-mode)

(global-set-key (kbd  "C-c u") 'whisper-run)

(with-eval-after-load 'vertico
  (define-key vertico-map (kbd "C-j") #'vertico-exit-input))

;; tangle multiple org files, why this?
;; main config (base_cfg.org) is read-only
;; experimental changes will be tested out in a sandbox called 'test_new.el'
;; after approval, changes will migrate to main config
;; the idea is protect the core config file from breakage

(defun my-org-babel-tangle-config ()
  "Automatically tangle our Org config files when we save them"
  (when (member (buffer-file-name)
                (list (expand-file-name "base_cfg.org"     user-emacs-directory)
                      (expand-file-name "modules/completion.org"   user-emacs-directory)
                      (expand-file-name "modules/file-manager.org" user-emacs-directory)
                      (expand-file-name "modules/system.org"   user-emacs-directory)
                      (expand-file-name "modules/musk.org"     user-emacs-directory)
                      (expand-file-name "modules/tools.org"    user-emacs-directory)))

;; >>> ADD THIS LINE TO TEST <<<
      (message "SUCCESS! Auto-tangling %s..." (buffer-name))

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook
        (lambda ()
          (add-hook 'after-save-hook #'my-org-babel-tangle-config nil 'make-it-local)))
