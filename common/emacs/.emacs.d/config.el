(setq savehist-file "~/.emacs.d/history")
(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'query-replace-history)
(setq history-length 10000)
(setq history-delete-duplicates t)

(defalias 'yes-or-no-p 'y-or-n-p)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode)
(column-number-mode)
(setq inhibit-startup-message t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(global-visual-line-mode 1)

(display-time)
(setq display-time-24hr-format t)
(setq display-time-load-average nil)

(setq scroll-conservatively 100)
(setq scroll-preserve-screen-position t)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

(setq ring-bell-function 'ignore)

(when window-system (global-hl-line-mode t))

(when window-system (global-prettify-symbols-mode t))

(show-paren-mode 1)

(save-place-mode 1)

(delete-selection-mode t)

(global-subword-mode 1)

(setq electric-pair-pairs '((?\{ . ?\})
                             (?\( . ?\))
                             (?\[ . ?\])
                             (?\" . ?\")))
(electric-pair-mode t)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup)
(defun my-minibuffer-setup ()
  (set (make-local-variable 'face-remapping-alist)
       '((default :height 1.0))))

(define-key minibuffer-local-map (kbd "<home>") 'abort-recursive-edit)

(setq read-quoted-char-radix 10)

(setq case-fold-search t)

(setq mark-ring-max 6)
(setq global-mark-ring-max 6)

(defvar my-term-shell "/bin/bash")
(defadvice ansi-term (before force-bash)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

(setq org-dir "~/Docs/Org/")
(setq dropbox-orgriz "~/Desk/Dropbox/orgriz/")
(setq dropbox-configs "~/Desk/Dropbox/configs/")

(setq org-hide-leading-stars t)
(setq org-startup-folded t)
(setq org-src-window-setup 'current-window)

(setq org-support-shift-select t)

(setq org-emphasis-alist
  '(("*" (bold :weight black))
    ("/" (italic :foreground "dark salmon"))
    ("_" (:underline t :foreground "cyan"))
    ("=" (verbatim :foreground "tomato"))
    ("~" (:background "PaleGreen1" :foreground "dim gray"))
    ("+" (:strike-through t :foreground "dark orange"))))
(setq org-hide-emphasis-markers t)

(use-package org-capture
  :config
  (global-set-key (kbd "C-c c") 'org-capture)
  (setq org-export-coding-system 'utf-8)
  (setq org-capture-templates
    '(("r" "relatorio tcc" entry
       (file+headline "~/Desk/TCC_rdo/textos_tcc/relat_tcc.org" "March")
       "* %<%d/%m/%Y>\nAtividade: %^{qual atividade?}"
       :empty-lines 1 :append t))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t)))
(setq org-ditaa-jar-path "/usr/share/java/ditaa/ditaa-0.11.jar")

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode))))

(set-register ?a (cons 'file (concat dropbox-orgriz "/[PERSO]_agenda_2026.org")))
(set-register ?h (cons 'file (concat dropbox-orgriz "/health.org")))
(set-register ?s (cons 'file (concat dropbox-configs "/[BIZ]_sys_config.org")))
(set-register ?t (cons 'file "~/Docs/Org/trade_kbase.org"))
(set-register ?p (cons 'file "~/Docs/Org/perso_search.org"))

(defun my-mini-calc (expr &optional arg)
  "Calculate expression.

1. If Region Selected: Sums all numbers found in selection.
2. If Single Cursor in Table: Pre-fills with cell value.
3. Result is always copied to clipboard.
4. C-u C-x a inserts result into buffer."
  (interactive
   (let ((initial-input nil))
     (cond
      ((use-region-p)
       (let ((text (buffer-substring-no-properties (region-beginning) (region-end)))
             (numbers nil)
             (start 0))
         (while (string-match "-?[0-9]+\\.?[0-9]*" text start)
           (push (match-string 0 text) numbers)
           (setq start (match-end 0)))
         (if numbers
             (setq initial-input (mapconcat #'identity (nreverse numbers) " + ")))))
      ((and (derived-mode-p 'org-mode) (org-at-table-p))
       (setq initial-input (org-trim (org-table-get-field)))))
     (list (read-from-minibuffer "Enter expression: " initial-input)
           current-prefix-arg)))
  (let ((result (calc-eval expr)))
    (kill-new result)
    (if arg
        (insert result)
      (message "Result: [%s] = %s (copied)" expr result))))

(global-set-key (kbd "C-x a") 'my-mini-calc)

(defun my-org-column-sum (col-num &optional arg)
  "Sum values in a specific column within highlighted rows.

1. Asks for COLUMN NUMBER.
2. Iterates through the highlighted region.
3. Extracts the value from that specific column in every row.
4. Pre-fills the calculator with the sum."
  (interactive "nColumn Number to Sum: \nP")
  (let ((initial-input nil))
    (if (not (use-region-p))
        (message "Please highlight the table rows first.")
      (let ((region-start (region-beginning))
            (region-end (region-end))
            (values nil))
        (save-excursion
          (save-restriction
            (narrow-to-region region-start region-end)
            (goto-char (point-min))
            (while (< (point) (point-max))
              (when (and (org-at-table-p)
                         (not (org-at-table-hline-p)))
                (condition-case nil
                    (progn
                      (org-table-goto-column col-num)
                      (let ((val (org-trim (org-table-get-field))))
                        (when (string-match-p "-?[0-9]+\\.?[0-9]*" val)
                          (push val values))))
                  (error nil)))
              (forward-line 1))))
        (setq initial-input (mapconcat #'identity (nreverse values) " + "))))
    (let* ((expr (read-from-minibuffer "Calculate: " initial-input))
           (result (calc-eval expr)))
      (kill-new result)
      (if arg
          (insert result)
        (message "Result: [%s] = %s (copied)" expr result)))))

(global-set-key (kbd "C-x s") 'my-org-column-sum)

(defun increment-number-decimal (&optional arg)
  "Increment all numbers in region or number at point by ARG.
Preserves zero-padding (e.g. 00 -> 01, 000 -> 001)."
  (interactive "p*")
  (let ((inc-by (if arg arg 1)))
    (if (use-region-p)
        ;; Region: increment every number found, preserving padding
        (let ((text (buffer-substring (region-beginning) (region-end)))
              (offset 0)
              (start (region-beginning)))
          (deactivate-mark)
          (with-temp-buffer
            (insert text)
            (goto-char (point-min))
            (while (re-search-forward "[0-9]+" nil t)
              (let* ((field-width (- (match-end 0) (match-beginning 0)))
                     (answer (+ (string-to-number (match-string 0) 10) inc-by))
                     (answer (if (< answer 0)
                                 (+ (expt 10 field-width) answer)
                               answer))
                     (replacement (format (concat "%0" (int-to-string field-width) "d") answer)))
                (replace-match replacement)))
            (let ((new-text (buffer-string)))
              (delete-region start (+ start (length text)))
              (goto-char start)
              (insert new-text))))
      ;; No region: increment number at point
      (save-excursion
        (save-match-data
          (skip-chars-backward "0123456789")
          (when (re-search-forward "[0-9]+" nil t)
            (let* ((field-width (- (match-end 0) (match-beginning 0)))
                   (answer (+ (string-to-number (match-string 0) 10) inc-by))
                   (answer (if (< answer 0)
                               (+ (expt 10 field-width) answer)
                             answer)))
              (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                     answer)))))))))

(defun eval-replace ()
  "Replace sexp before point by result of its evaluation."
  (interactive)
  (let ((result (pp-to-string (eval (pp-last-sexp) lexical-binding))))
    (delete-region (save-excursion (backward-sexp) (point)) (point))
    (insert result)))

(global-set-key (kbd "C-c e") 'eval-replace)

(defun package-menu-find-marks ()
  "Find packages marked for action in *Packages*."
  (interactive)
  (occur "^[A-Z]"))

(defun package-menu-filter-by-status (status)
  "Filter the *Packages* buffer by status."
  (interactive
   (list (completing-read
          "Status: " '("new" "installed" "dependency" "obsolete"))))
  (package-menu-filter (concat "status:" status)))

(define-key package-menu-mode-map "s" #'package-menu-filter-by-status)
(define-key package-menu-mode-map "a" #'package-menu-find-marks)

;; (require 'whitespace)
;; (setq whitespace-style '(face empty tabs lines-tail trailing))
;; (global-whitespace-mode t)

(setq frame-inhibit-implied-resize t)

(defun set-font-size-by-context (&optional frame)
  "Set Emacs font height explicitly for the current or new frame."
  (interactive)
  ;; Identify the exact frame being created by emacsclient
  (let ((target-frame (or frame (selected-frame))))
    (with-selected-frame target-frame
      (when (display-graphic-p target-frame)
        (condition-case err
            (progn
              ;; Notice we replaced 'nil' with 'target-frame'
              ;; This forces the change on the NEW window, overriding the daemon's memory
              (set-face-attribute 'default target-frame :family "JetBrainsMono Nerd Font Mono")
              
              (let* ((hostname (system-name))
                     (monitor-attrs (car (display-monitor-attributes-list target-frame)))
                     (geometry (assoc 'geometry monitor-attrs))
                     (width (if geometry (nth 3 geometry) 0)))

                (cond
                 ((and (string= hostname "legion") (>= width 2560))
                  (set-face-attribute 'default target-frame :height 130))

                 ((string= hostname "legion")
                  (set-face-attribute 'default target-frame :height 120))

                 ((string= hostname "templar")
                  (set-face-attribute 'default target-frame :height 120))

                 (t
                  (set-face-attribute 'default target-frame :height 130)))
                
                (message "Font forced for %s (Width: %s)" hostname width)))
          (error (message "Font setup failed: %s" err)))))))

;; Trigger on regular GUI startup
(add-hook 'window-setup-hook #'set-font-size-by-context)

;; Trigger every time emacsclient creates a new frame
(add-hook 'after-make-frame-functions #'set-font-size-by-context)

(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/config.org"))
(global-set-key (kbd "C-c 1") 'config-visit)

(defun config-reload ()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/config.org")))
(global-set-key (kbd "C-c 2") 'config-reload)

(defvar RDO-mode-map (make-sparse-keymap)
  "Keymap for `RDO-mode'.")

;;;###autoload
(define-minor-mode RDO-mode
  "Minor mode to give personal keybindings highest priority over major modes."
  :init-value t
  :lighter " RDO"
  :keymap RDO-mode-map)

;;;###autoload
(define-globalized-minor-mode global-RDO-mode RDO-mode RDO-mode)

;; emulation-mode-map-alists has highest keymap priority
(add-to-list 'emulation-mode-map-alists `((RDO-mode . ,RDO-mode-map)))

;; Disable in minibuffer
(defun turn-off-RDO-mode ()
  "Turn off RDO-mode."
  (RDO-mode -1))
(add-hook 'minibuffer-setup-hook #'turn-off-RDO-mode)

;; --- Window resizing ---
(define-key RDO-mode-map (kbd "C-S-k") #'shrink-window)
(define-key RDO-mode-map (kbd "C-S-i") #'enlarge-window)
(define-key RDO-mode-map (kbd "C-S-l") #'enlarge-window-horizontally)
(define-key RDO-mode-map (kbd "C-S-j") #'shrink-window-horizontally)
(define-key RDO-mode-map (kbd "C-+")   #'balance-windows)

;; --- Capslock (remapped to <home> via xmodmap) → xah-fly command mode ---
(define-key RDO-mode-map (kbd "<home>") 'xah-fly-command-mode-activate)

;; --- C-w: kill buffer, prompt if unsaved, close split if open ---
(defun rdo/close-buffer-or-prompt ()
  "Kill current buffer. If modified, prompt once. If yes, discard and kill.
   If in a split, close the window after killing."
  (interactive)
  (if (and (buffer-modified-p) (buffer-file-name))
      (when (yes-or-no-p (format "Buffer '%s' is unsaved. Kill anyway? " (buffer-name)))
        (set-buffer-modified-p nil)
        (kill-buffer (current-buffer))
        (when (> (count-windows) 1) (delete-window)))
    (kill-buffer (current-buffer))
    (when (> (count-windows) 1) (delete-window))))

(define-key RDO-mode-map (kbd "C-w") #'rdo/close-buffer-or-prompt)

(provide 'RDO-mode)

;; Make ESC act exactly like C-g (cancel/unselect/quit) globally
(global-set-key (kbd "<escape>") 'keyboard-quit)

;; Force xah-fly-keys to let go of the ESC key
(with-eval-after-load 'xah-fly-keys
  (define-key xah-fly-key-map (kbd "<escape>") 'keyboard-quit)
  (define-key xah-fly-command-map (kbd "<escape>") 'keyboard-quit)
  (define-key xah-fly-insert-map (kbd "<escape>") 'keyboard-quit))

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

(defun hack-isearch-kill ()
  "Push current isearch match into kill ring."
  (interactive)
  (kill-new (buffer-substring (point) isearch-other-end))
  (isearch-done))

(define-key isearch-mode-map (kbd "M-w") 'hack-isearch-kill)

(defun toggle-asterisk-around-region (start end)
  "Toggle *asterisks* around the selected region."
  (interactive "r")
  (if (and (use-region-p)
           (string= (buffer-substring-no-properties start (1+ start)) "*")
           (string= (buffer-substring-no-properties (1- end) end) "*"))
      (progn
        (delete-region start (1+ start))
        (delete-region (1- end) end))
    (goto-char end)
    (insert "*")
    (goto-char start)
    (insert "*")))

(global-set-key (kbd "C-8") 'toggle-asterisk-around-region)

(global-set-key (kbd "C-x C-q") 'wdired-change-to-wdired-mode)

(global-set-key (kbd "C-c 3") 'prl_rename_mp3)

;; Must be set before loading xah-fly-keys
(setq xah-fly-use-control-key t)

;; Cursor colors — nil means let the theme control it
;; XFK defaults are "red" for command and "gray" for insert
(setq xah-fly-command-mode-cursor-color nil)
(setq xah-fly-insert-mode-cursor-color  nil)

;; cursor shape change terminal
;(add-hook 'after-make-frame-functions
;  (lambda (frame)
;    (unless (display-graphic-p frame)
;      (add-hook 'xah-fly-insert-mode-activate-hook
;                (lambda () (send-string-to-terminal "\e[5 q")))
;      (add-hook 'xah-fly-command-mode-activate-hook
;                (lambda () (send-string-to-terminal "\e[2 q"))))))

(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty")
(xah-fly-keys 1)

;; activate command mode automatically on new frames
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (xah-fly-command-mode-activate)))

;; Number row — command mode bindings (qwerty layout)
;; XFK does not auto-bind these; must be explicit
(define-key xah-fly-key-map (kbd "1") 'xah-extend-selection)
(define-key xah-fly-key-map (kbd "2") 'xah-select-line)
(define-key xah-fly-key-map (kbd "3") 'delete-other-windows)
(define-key xah-fly-key-map (kbd "4") 'split-window-below)
(define-key xah-fly-key-map (kbd "5") 'delete-char)
(define-key xah-fly-key-map (kbd "6") 'xah-select-block)
(define-key xah-fly-key-map (kbd "7") 'xah-select-line)
(define-key xah-fly-key-map (kbd "8") 'xah-extend-selection)
(define-key xah-fly-key-map (kbd "9") 'xah-select-text-in-quote)
(define-key xah-fly-key-map (kbd "0") 'xah-pop-local-mark-ring)

;; Meta key bindings
(define-key xah-fly-key-map (kbd "M-c") 'capitalize-word)
(define-key xah-fly-key-map (kbd "M-u") 'upcase-word)
(define-key xah-fly-key-map (kbd "M-l") 'downcase-word)

;; Leader key bindings  (SPC = leader)
(define-key xah-fly-leader-key-map (kbd "r") 'replace-string)
(define-key xah-fly-leader-key-map (kbd "R") 'query-replace)
(define-key xah-fly-leader-key-map (kbd "f") 'ibuffer)
(define-key xah-fly-leader-key-map (kbd "4") 'split-window-right)

;; Override C-x C-c to always save+quit
(define-key global-map (kbd "C-x C-c") 'save-buffers-kill-terminal)

;; Custom command-mode hook (add extra bindings here as needed)
(defun RDO-config-xah-fly-key ()
  "Extra bindings applied when command mode activates."
  (interactive))

(add-hook 'xah-fly-command-mode-activate-hook 'RDO-config-xah-fly-key)

(use-package which-key
  :ensure t
  :init
  (which-key-mode))

(use-package beacon
  :ensure t
  :init
  (beacon-mode 1))

(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char-2))

(use-package multiple-cursors
  :ensure t)

(setq mc/always-run-for-all t)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
;; exit mc: <return> or C-g
;; newline in mc: C-j

(use-package visual-regexp
  :ensure t)
;; (define-key global-map (kbd "C-c r") 'vr/replace)
;; (define-key global-map (kbd "C-c q") 'vr/query-replace)
;; (define-key global-map (kbd "C-c m") 'vr/mc-mark)

(use-package fzf
  :ensure t)

(use-package sudo-edit
  :ensure t
  :bind ("s-e" . sudo-edit))

(use-package diminish
  :ensure t
  :init
  (diminish 'which-key-mode)
  (diminish 'visual-line-mode)
  (diminish 'beacon-mode)
  (diminish 'page-break-lines-mode)
  (diminish 'subword-mode))

(use-package dimmer
  :ensure t
  :init
  (dimmer-configure-which-key)
  (dimmer-mode t)
  :custom
  (dimmer-fraction 0.5))

(use-package dashboard
  :ensure t
  :init
  (progn
    (setq dashboard-banner-logo-title "")
    (setq dashboard-startup-banner 'logo)
    (setq dashboard-set-navigator nil)
    (setq dashboard-center-content nil)
    (setq dashboard-show-shortcuts nil)
    (setq dashboard-items '((recents   . 5)
                            (bookmarks . 15)))
    (setq dashboard-set-heading-icons t)
    (setq dashboard-set-file-icons t)
    (setq dashboard-set-footer nil)
    (setq dashboard-set-init-info nil))
  :config
  (dashboard-setup-startup-hook))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  (setq doom-themes-treemacs-theme "doom-atom")
  (doom-themes-treemacs-config)
  (doom-themes-org-config)
  (load-theme 'doom-tomorrow-night t)
  ;; Set org header sizes after theme loads
  (set-face-attribute 'org-level-1 nil :height 1.3)
  (set-face-attribute 'org-level-2 nil :height 1.2)
  (set-face-attribute 'org-level-3 nil :height 1.1)
  (set-face-attribute 'org-level-4 nil :height 1.0))

;; hide file details on open
(defun xah-dired-mode-setup ()
  "Hide details in dired on open."
  (dired-hide-details-mode 1))
(add-hook 'dired-mode-hook 'xah-dired-mode-setup)

;; copy/move between two open dired buffers
(setq dired-dwim-target t)
(setq wdired-allow-to-change-permissions t)
(setq dired-listing-switches "-lH")

;; ibuffer groups
(setq-default ibuffer-saved-filter-groups
  `(("Default"
     ("Dired"     (mode . dired-mode))
     ("Temporary" (name . "\*.*\*")))))

(add-hook 'ibuffer-mode-hook
          #'(lambda ()
              (ibuffer-switch-to-saved-filter-groups "Default")))

(use-package async
  :ensure t
  :init (dired-async-mode 1))

(define-key dired-mode-map "/" 'dired-goto-file)
(define-key dired-mode-map "i" 'dired-previous-line)
(define-key dired-mode-map "k" 'dired-next-line)
(define-key dired-mode-map "j" 'dired-up-directory)
(define-key dired-mode-map "l" 'dired-open-file)

(use-package all-the-icons
  :ensure t)

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :ensure t
  :config
  (defun my-dired-mode-hook ()
    (dired-hide-dotfiles-mode))
  (define-key dired-mode-map "." #'dired-hide-dotfiles-mode)
  (add-hook 'dired-mode-hook #'my-dired-mode-hook))

(use-package dired-open
  :ensure t
  :config
  (setq dired-open-extensions
        '(("png"  . "sxiv")
          ("jpg"  . "sxiv")
          ("jpeg" . "sxiv")
          ("gif"  . "sxiv")
          ("bmp"  . "sxiv")
          ("mkv"  . "mpv")
          ("avi"  . "mpv")
          ("mp4"  . "mpv")
          ("mp3"  . "mpv")
          ("pdf"  . "zathura"))))

(use-package dired-narrow
  :ensure t
  :bind (:map dired-mode-map
              ("\\" . dired-narrow)
              ("|"  . dired-narrow-fuzzy)))

(use-package dired-rainbow
  :ensure t
  :config
  (defconst my-dired-media-files-extensions
    '("mp3" "mp4" "MP3" "MP4" "avi" "mpg" "flv" "ogg")
    "Media files."))

(use-package dired-subtree
  :ensure t
  :after dired
  :config
  (bind-key "<tab>"     #'dired-subtree-cycle  dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-remove dired-mode-map))

(use-package dired-ranger
  :ensure t
  :bind (:map dired-mode-map
              ("C" . dired-ranger-copy)
              ("X" . dired-ranger-move)
              ("V" . dired-ranger-paste)))

(use-package dired-quick-sort
  :ensure t)
(dired-quick-sort-setup)

;; --- Anki editor ---
;; (use-package anki-editor
;;   :after org
;;   :bind (:map org-mode-map
;;               ("<f12>" . anki-editor-cloze-region-auto-incr)
;;               ("<f11>" . anki-editor-cloze-region-dont-incr)
;;               ("<f10>" . anki-editor-reset-cloze-number)
;;               ("<f9>"  . anki-editor-push-tree))
;;   :hook (org-capture-after-finalize . anki-editor-reset-cloze-number)
;;   :config
;;   (setq anki-editor-create-decks t
;;         anki-editor-org-tags-as-anki-tags t))

;; --- Projectile ---
;; (use-package projectile)
;; (projectile-mode +1)
;; (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; --- auto-compile ---
;; (use-package auto-compile :ensure t)

;; --- fancy-battery ---
;; (use-package fancy-battery
;;   :ensure t
;;   :config
;;   (setq fancy-battery-show-percentage t)
;;   (setq battery-update-interval 15)
;;   (if window-system (fancy-battery-mode) (display-battery-mode)))

;; --- spaceline ---
;; (use-package spaceline
;;   :ensure t
;;   :config
;;   (require 'spaceline-config)
;;   (setq powerline-default-separator 'arrow)
;;   (spaceline-spacemacs-theme))

;; --- visible-mark ---
;; (use-package visible-mark
;;   :ensure t
;;   :init
;;   (defface visible-mark-active
;;     '((t (:background "magenta"))) "")
;;   (global-visible-mark-mode 1)
;;   (setq visible-mark-max 6)
;;   :custom-face
;;   (visible-mark-face1 ((t (:background "hot pink"))))
;;   (visible-mark-face2 ((t (:background "medium orchid")))))

;; --- ranger (dired alternative) ---
;; (use-package ranger
;;   :ensure t
;;   :after dired)

;; --- pdf-tools ---
;; (use-package pdf-tools :ensure t)
