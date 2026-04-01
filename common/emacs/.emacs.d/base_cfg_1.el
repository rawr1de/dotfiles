;; -*- lexical-binding: t; -*-
;;
;; BASE CONFIG FILE
;;
;;; --- LOADOUT FOLDERS
(add-to-list 'load-path "~/.emacs.d/modules/")
(add-to-list 'load-path "~/.emacs.d/snippets/")
;; Fix for Arch Linux: exiftool is in /usr/bin/vendor_perl
(add-to-list 'exec-path "/usr/bin/vendor_perl")
(setenv "PATH" (concat "/usr/bin/vendor_perl:" (getenv "PATH")))

;;; --- AUTOLOADS (LAZY LOADING)

;; drag and drop files in dired/dirvish
(autoload 'my-dired-ripdrag "ripdrag" nil t)

;; Colored Jump Marks
(autoload 'my-set-cycle-mark "colored-jump-marks" nil t)
(autoload 'my-jump-cycle-mark "colored-jump-marks" nil t)
(autoload 'my-clear-all-cycle-marks "colored-jump-marks" nil t)

;; Math & Logic
(autoload 'mini-calc "mini-calc" nil t)
(autoload 'org-column-sum "org-column-sum" nil t)
(autoload 'increment-number-decimal "increment-number-decimal" nil t)
(autoload 'eval-replace "eval-replace" nil t)

;; Package & Formatting
(autoload 'package-menu-find-marks "package-filter" nil t)
(autoload 'package-menu-filter-by-status "package-filter" nil t)
(autoload 'format-lyrics-current-buffer "lyrics-formatter" nil t)
(autoload 'my-emms-mpd-refresh "emms-mpd-refresh" nil t)
(autoload 'my-convert-md-to-org "convert-md-to-org" nil t)
(autoload 'my-org-tables-align "org-tables-align" nil t)



;;; --- LOAD MODULES
(require 'system)
(require 'ui)
(require 'completion)
(require 'file-manager)
(require 'music-emms-mpv)
(require 'tools)
(require 'org-config)


;;; --- THE MODAL CORE (Xah Fly Keys)
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


;; XFK COLORED CURSOR (VISUAL INDICATOR)
;; (setq xah-fly-insert-state-q nil)
;; (add-hook 'xah-fly-command-mode-activate-hook
          ;; (lambda () (set-cursor-color "#c678dd")))
;; (add-hook 'xah-fly-insert-mode-activate-hook
          ;; (lambda () (set-cursor-color "#98c379")))


;; XFK CURSOR SHAPE INDICATOR
;; (add-hook 'xah-fly-command-mode-activate-hook
          ;; (lambda () (setq cursor-type 'box)))
;; (add-hook 'xah-fly-insert-mode-activate-hook
          ;; (lambda () (setq cursor-type 'bar)))


;; XFK MODELINE INDICATOR
;; (setq-default mode-line-format
  ;; '((:eval (if xah-fly-insert-state-q
               ;; (propertize " INS " 'face '(:foreground "#98c379"))
             ;; (propertize " CMD " 'face '(:foreground "#c678dd"))))
    ;; rest of your mode-line
    ;; ))


;;; --- (MY) KEY OVERRIDES / BINDINGS / MINOR-MODES

;;;; --- ORG-MODE SUB-MAP
(defvar my-xah-org-prefix-map (make-sparse-keymap) "My Org-mode sub-menu for XFK")

;;;;; --- SUB-MAP KEYBINDS
(define-key my-xah-org-prefix-map (kbd "s") 'org-column-sum)
(define-key my-xah-org-prefix-map (kbd "t") 'org-todo)
;; Add as many as you want here...

;;;;; --- SUB-MAP CONTEXTUAL LOGIC (SPC 1)
(define-key xah-fly-leader-key-map (kbd "1")
  '(menu-item "Contextual 1" nil
              :filter (lambda (_)
                        (cond
                         ((derived-mode-p 'dired-mode) 'my-dired-ripdrag)
                         ((derived-mode-p 'org-mode) my-xah-org-prefix-map)
                         (t nil)))))



;;;; --- (MY) CUSTOM FUNCTIONS KEYBINDINGS (GLOBAL)
  (define-key xah-fly-leader-key-map (kbd "0") 'my-set-cycle-mark)
  (define-key xah-fly-command-map    (kbd "0") 'my-jump-cycle-mark)
  (define-key xah-fly-leader-key-map (kbd "9") 'my-clear-all-cycle-marks)
  (define-key xah-fly-leader-key-map (kbd "c") 'mini-calc)


;;;; --- OTHER BINDINGS
  ;; toggle XFK modal
  (global-set-key (kbd "<f12>") 'xah-fly-keys)

  ;; assorted keys
  (define-key xah-fly-leader-key-map (kbd ", s") 'save-buffer)
  (define-key xah-fly-leader-key-map (kbd "u") 'consult-buffer)
  (define-key xah-fly-leader-key-map (kbd "s") 'consult-line)
  (define-key xah-fly-leader-key-map (kbd "r") 'replace-string)
  (define-key xah-fly-leader-key-map (kbd "R") 'query-replace)
  (define-key xah-fly-leader-key-map (kbd "f") 'ibuffer)
  (define-key xah-fly-key-map (kbd "n") 'consult-line)


  ;; NEW KEYS TO DEFINE
  (define-key xah-fly-leader-key-map (kbd "a") nil)

  ;; dired-jump DISABLED bind
  (define-key ctl-x-map (kbd "C-j") nil)

  ;; second brain, root dir notes search
  (define-key xah-fly-leader-key-map (kbd ";") 'rdo/search-menu)

  ;; dired/dirvish keys
  (with-eval-after-load 'dired
  ;; Bind a key in all Dired/Dirvish buffers
  (define-key dired-mode-map (kbd "\\") 'dired-narrow-fuzzy))

  ;; kill buffer with no confirmation (!)
  (global-set-key (kbd "C-w") 'my-kill-buffer-no-confirm)


;;;; --- EMMS

;;;;; --- Z MAP PREFIX for EMMS (XFK)
  ;; prefix menu entry
  (defvar z-emms-map (make-sparse-keymap)
  "Keymap for EMMS commands under 'SPC z'")

  (define-key xah-fly-leader-key-map (kbd "z") z-emms-map)
  (advice-add 'emms-playlist-mode-go :after
            (lambda (&rest _) (xah-fly-insert-mode-activate)))

  ;; sub-commands
  (define-key z-emms-map (kbd "z") #'emms-smart-browse)
  (define-key z-emms-map (kbd "p") #'emms-playlist-mode-go)
  (define-key z-emms-map (kbd "v") #'emms-stop)
  (define-key z-emms-map (kbd "SPC") #'emms-pause)
  (define-key z-emms-map (kbd "e") #'my-emms-mark-mode-toggle)

  (defvar my-emms-mark-mode-active nil)
  (defun my-emms-mark-mode-toggle ()
    "Toggle `emms-mark-mode` on and off."
    (interactive)
    (if my-emms-mark-mode-active
        (progn
          (emms-mark-mode-disable)
          (setq my-emms-mark-mode-active nil))
      (progn
        (emms-mark-mode)
        (setq my-emms-mark-mode-active t))))


  ;; bind 'l' to: load m3u playlist and fire emms (playlist)
  (define-key z-emms-map (kbd "l")
    (lambda () (interactive)
      (emms-add-playlist "~/Musk/_plts/last.m3u")
      (emms-playlist-mode-go)))


  ;; descriptions for which-key z-emms-map
  (which-key-add-keymap-based-replacements z-emms-map
    "z"   "smart-browse"
    "p"   "playlist"
    "v"   "stop"
    "SPC" "pause"
    "l"   "load last .m3u"
    "e"   "toggle mark-mode")


;;;;; --- EMMS PLAYLIST BINDS
  (with-eval-after-load 'emms-playlist-mode
    (define-key emms-playlist-mode-map (kbd "i")   'previous-line)
    (define-key emms-playlist-mode-map (kbd "k")   'next-line)
    (define-key emms-playlist-mode-map (kbd "RET") 'emms-playlist-mode-play-current-track)
    (define-key emms-playlist-mode-map (kbd "SPC") 'emms-pause)
    (define-key emms-playlist-mode-map (kbd "v")   'emms-stop)
    ;; (define-key emms-playlist-mode-map (kbd "m")   'emms-next)
    ;; (define-key emms-playlist-mode-map (kbd "n")   'emms-previous)
    (define-key emms-playlist-mode-map (kbd ",")   'xah-next-window-or-frame)
    (define-key emms-playlist-mode-map (kbd "p")    nil)

  ;; VOLUME
  (defun rdo/emms-mpv-volume-change (amount)
  "Change system volume via wpctl by AMOUNT percent."
  (let ((sign (if (< amount 0) "-" "+")))
    (call-process "wpctl" nil nil nil
                  "set-volume" "@DEFAULT_AUDIO_SINK@"
                  (format "%d%%%s" (abs amount) sign))
    (emms-player-mpv-cmd '(get_property volume)
      (lambda (data _err)
        (message "MPV vol: %.0f%% | sys: %s%d%%"
                 data sign (abs amount))))))

  ;; volume 5% steps
  (define-key emms-playlist-mode-map (kbd "u") (lambda () (interactive) (rdo/emms-mpv-volume-change -5)))
  (define-key emms-playlist-mode-map (kbd "o") (lambda () (interactive) (rdo/emms-mpv-volume-change  5)))
  ;; volume 1% steps
  (define-key emms-playlist-mode-map (kbd "U") (lambda () (interactive) (rdo/emms-mpv-volume-change -1)))
  (define-key emms-playlist-mode-map (kbd "O") (lambda () (interactive) (rdo/emms-mpv-volume-change  1)))
  ;; seek 5sec
  (define-key emms-playlist-mode-map (kbd "j") (lambda () (interactive) (emms-seek -5)))
  (define-key emms-playlist-mode-map (kbd "l") (lambda () (interactive) (emms-seek  5))))


;;;;; --- EMMS BROWSER KEYBINDS
  (with-eval-after-load 'emms-browser
    (define-key emms-browser-mode-map (kbd "i")     'previous-line)
    (define-key emms-browser-mode-map (kbd "k")     'next-line)
    (define-key emms-browser-mode-map (kbd "SPC")   'emms-browser-toggle-subitems-recursively)
    (define-key emms-browser-mode-map (kbd "<tab>") 'emms-playlist-mode-go)
    (define-key emms-browser-mode-map (kbd "a")     'emms-browser-add-tracks)
    (define-key emms-browser-mode-map (kbd ",")     'xah-next-window-or-frame))


;;;;; --- TAG EDITOR BINDS
  (with-eval-after-load 'emms-tag-editor
    (define-key emms-tag-editor-mode-map (kbd "C-c C-c") 'emms-tag-editor-submit)
    (define-key emms-tag-editor-mode-map (kbd "C-c C-q") 'emms-tag-editor-quit))


;;;; --- VERT/HORIZ SPLIT CONTROL
  (global-set-key (kbd "C-S-i") 'enlarge-window)
  (global-set-key (kbd "C-S-k") 'shrink-window)
  (global-set-key (kbd "C-S-l") 'enlarge-window-horizontally)
  (global-set-key (kbd "C-S-j") 'shrink-window-horizontally)
  (define-key xah-fly-leader-key-map (kbd "=") 'balance-windows)


;;;; --- NUMBERS ROW
  (define-key xah-fly-key-map (kbd "5") 'delete-char)
  (define-key xah-fly-key-map (kbd "6") 'xah-select-block)
  (define-key xah-fly-key-map (kbd "7") 'xah-select-line)
  (define-key xah-fly-key-map (kbd "8") 'xah-select-text-in-quote)


;;;; --- TAB NAVIGATION
  (global-set-key (kbd "C-S-o") 'tab-next)
  ;; (global-set-key (kbd "C-S-w") 'tab-close)

  ;; combined close-tab to delete-frame
(defun rdo/tab-or-frame-close ()
  "Close tab if multiple tabs exist, otherwise close frame"
  (interactive)
  (if (> (length (tab-bar-tabs)) 1)
      (tab-close)
    (delete-frame)))
  (global-set-key (kbd "C-S-w") 'rdo/tab-or-frame-close)
  ;; open new tab
  (define-key xah-fly-key-map (kbd "SPC t") 'tab-new)
  ;; disable (hide) tabs
  (define-key xah-fly-key-map (kbd "SPC T") 'tab-bar-mode)


;;;; --- SCREEN SCROLLING  [M-i / M-k]
(defun scroll-one-line-down ()
  "Scroll down one line."
  (interactive)
  (scroll-down 1))

(defun scroll-one-line-up ()
  "Scroll up one line."
  (interactive)
  (scroll-up 1))

(global-set-key (kbd "M-i") 'scroll-one-line-down)
(global-set-key (kbd "M-k") 'scroll-one-line-up)


;;;; --- MULTIPLE CURSORS
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this))
  :config (setq mc/always-run-for-all t))


;;;; --- REGISTERS
(set-register ?a (cons 'file "~/Desk/Dropbox/orgriz/[PERSO]_agenda_2026.org"))
(set-register ?h (cons 'file "~/Desk/Dropbox/orgriz/health.org"))
(set-register ?s (cons 'file "~/Desk/Dropbox/configs/[BIZ]_sys_config.org"))
(set-register ?t (cons 'file "~/Docs/Org/trade_kbase.org"))
(set-register ?p (cons 'file "~/Docs/Org/perso_search.org"))
(set-register ?f (cons 'file "~/Docs/11.git_docs/03.system/FIXES_LOG.org"))


;;;; --- BOOKMARKS




;;; --- END OF FILE !!!
;;
;; M-x package-delete (delete installed files)
;; M-x package-autoremove (remove package dependencies)
;;
;; Local Variables:
;; eval: (outline-minor-mode 1)
;; eval: (local-set-key (kbd "<tab>") 'outline-cycle)
;; outline-regexp: ";;;+ ?---"
;; End:
