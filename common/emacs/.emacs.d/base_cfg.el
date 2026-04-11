(add-to-list 'load-path "~/.emacs.d/modules/")
(add-to-list 'load-path "~/.emacs.d/snippets/")
;; Fix for Arch Linux: exiftool is in /usr/bin/vendor_perl
(add-to-list 'exec-path "/usr/bin/vendor_perl")
(setenv "PATH" (concat "/usr/bin/vendor_perl:" (getenv "PATH")))
(with-eval-after-load 'custom
  (custom-set-faces '(default ((t (:background unspecified))))))

(require 'system)
(require 'ui)
(require 'completion)
(require 'file-manager)
(require 'musk)
(require 'tools)
(require 'my-scratchpad)
(require 'my-kde-sms)
(require 'my-force-fullscreen-toggle)

(autoload 'my-dired-ripdrag "my-ripdrag" nil t)
(autoload 'my-dired-copy-file-to-clipboard "my-dired-copy-file-to-clipboard" nil t)

;; Colored Jump Marks
(autoload 'my-set-cycle-mark "my-colored-jump-marks" nil t)
(autoload 'my-jump-cycle-mark "my-colored-jump-marks" nil t)
(autoload 'my-clear-all-cycle-marks "my-colored-jump-marks" nil t)
;; screen scrolling
(autoload 'my-scroll-one-line-down "my-screen-scrolling" nil t)
(autoload 'my-scroll-one-line-up "my-screen-scrolling" nil t)

(autoload 'my-mini-calc "my-mini-calc" nil t)
(autoload 'my-org-column-sum "my-org-column-sum" nil t)
(autoload 'my-increment-number-decimal "my-increment-number-decimal" nil t)
(autoload 'my-eval-replace "my-eval-replace" nil t)

(autoload 'my-package-menu-find-marks "my-package-filter" nil t)
(autoload 'my-package-menu-filter-by-status "my-package-filter" nil t)
(autoload 'my-format-lyrics-current-buffer "my-lyrics-formatter" nil t)
(autoload 'my-emms-mpd-refresh "my-emms-mpd-refresh" nil t)
(autoload 'my-convert-md-to-org "my-convert-md-to-org" nil t)
(autoload 'my-org-tables-align "my-org-tables-align" nil t)

;; kitty popup artwork
(autoload 'my-emms-now-playing-popup "my-emms-now-playing-popup" nil t)
;; artwork scan folder
(autoload 'my-musk-show-album-art    "my-musk-show-album-art"    nil t)

(autoload 'my-dired-kdeconnect-share "my-dired-kdeconnect-share" nil t)
(autoload 'my-dired-wormhole-send "my-dired-wormhole-send" nil t)
(autoload 'my-dired-syncthing-transfer "my-dired-syncthing-transfer" nil t)

(autoload 'my-backup-file "my-backup-file" nil t)

(autoload 'my-batt-conserv-change "my-batt-conserv-change" nil t)

(autoload 'my-browse-url-and-focus "my-browse-url-and-focus" nil t)

(autoload 'my-tab-or-frame-close "my-tab-or-frame-close" nil t)

;; (use-package my-xfk-help-info-snap
  ;; :hook ((window-selection-change-functions . my-xfk-snap-command-mode)
         ;; (help-mode . my-xfk-help-override-mode)
         ;; (Info-mode . my-xfk-help-override-mode)))

(use-package xah-fly-keys
  :load-path "~/.emacs.d/lisp/"
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
  ;; org-mode  kill-line
  (define-key org-mode-map (kbd "C-k") nil)
  ;; org-mode  org-cycle ;; org-mode  org-cycle
  (define-key org-mode-map (kbd "C-i") nil)


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
  ;; (setq emms-playlist-mode-map (make-sparse-keymap)))
  (define-key emms-playlist-mode-map (kbd "a") nil)
  ;; insert single track (emms)
  (define-key emms-playlist-mode-map (kbd "i") nil)
  (define-key emms-playlist-mode-map (kbd "S-i") nil)
  (define-key emms-playlist-mode-map (kbd "S-k") nil))

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

(define-key xah-fly-leader-key-map (kbd "0") 'my-set-cycle-mark)
(define-key xah-fly-command-map    (kbd "0") 'my-jump-cycle-mark)
(define-key xah-fly-leader-key-map (kbd "9") 'my-clear-all-cycle-marks)
(define-key xah-fly-leader-key-map (kbd "c") 'my-mini-calc)
(define-key xah-fly-leader-key-map (kbd ", b") 'my-backup-file)
(define-key xah-fly-leader-key-map (kbd "+") 'my-kde-send-sms)
(define-key xah-fly-leader-key-map (kbd ", s") 'save-buffer)
(define-key xah-fly-leader-key-map (kbd "u") 'consult-buffer)
(define-key xah-fly-leader-key-map (kbd "s") 'consult-line)
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

;; org-mode  org-cycle | restore TAB explicitly
(define-key org-mode-map (kbd "TAB") #'org-cycle)

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
(set-register ?s (cons 'file "~/Docs/09.notes/trading-study-tracker.org"))
(set-register ?t (cons 'file "~/Docs/Org/trade_kbase.org"))
(set-register ?p (cons 'file "~/Docs/Org/perso_search.org"))
(set-register ?f (cons 'file "~/Docs/11.git_docs/03.system/FIXES_LOG.org"))

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
(define-key emms-playlist-mode-map (kbd "S-k")   'end-of-buffer)
(define-key emms-playlist-mode-map (kbd "S-i")   'beginning-of-buffer)
(define-key emms-playlist-mode-map (kbd "y") 'emms-playlist-mode-center-current)
;; disable 'p' ASDF
(define-key emms-playlist-mode-map (kbd "p")    nil)

;; volume (MPV internal)
(define-key emms-playlist-mode-map (kbd "u") (lambda () (interactive) (musk-volume-change -5)))
(define-key emms-playlist-mode-map (kbd "o") (lambda () (interactive) (musk-volume-change  5)))
(define-key emms-playlist-mode-map (kbd "U") (lambda () (interactive) (musk-volume-change -1)))
(define-key emms-playlist-mode-map (kbd "O") (lambda () (interactive) (musk-volume-change  1)))

;; seek 5sec
(define-key emms-playlist-mode-map (kbd "j") (lambda () (interactive) (emms-seek -5)))
(define-key emms-playlist-mode-map (kbd "l") (lambda () (interactive) (emms-seek  5)))

;; shift tracks
(define-key emms-playlist-mode-map (kbd "w") 'emms-playlist-mode-shift-track-up)
(define-key emms-playlist-mode-map (kbd "s") 'emms-playlist-mode-shift-track-down)


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
                      ;; (expand-file-name "test_new.org"     user-emacs-directory)
                      (expand-file-name "modules/completion.org"   user-emacs-directory)
                      (expand-file-name "modules/file-manager.org" user-emacs-directory)
                      (expand-file-name "modules/system.org"   user-emacs-directory)
                      (expand-file-name "modules/musk.org"     user-emacs-directory)
                      (expand-file-name "modules/tools.org"    user-emacs-directory)))

    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook
        (lambda ()
          (add-hook 'after-save-hook #'my-org-babel-tangle-config nil 'make-it-local)))
