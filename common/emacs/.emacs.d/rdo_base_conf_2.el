;; -*- lexical-binding: t; -*-

;;; --- PERFORMANCE ENGINE ---
(setq gc-cons-threshold 100000000)
(add-hook 'after-init-hook (lambda () (setq gc-cons-threshold 800000)))


;; PREVENT UI FLICKERING, DISABLE BARS BEFORE FRAME EVEN OPENS
(setq default-frame-alist '((tool-bar-lines . 0)
                            (menu-bar-lines . 0)
                            (vertical-scroll-bars . nil)))



;;; --- THE MODAL CORE (Xah Fly Keys) ---
(use-package xah-fly-keys
  :load-path "~/.emacs.d/lisp/"
  :config
  (setq xah-fly-use-control-key t)
  (setq xah-fly-command-mode-cursor-color nil)
  (setq xah-fly-insert-mode-cursor-color nil)
  (xah-fly-keys-set-layout "qwerty")
  (xah-fly-keys 1)
  (setq xah-fly-use-control-key t))

;;;; --- CUSTOM BINDS/KEYS ---

;;  FIX: CAPSLOCK (HOME) ACTIVATION
  (global-set-key (kbd "<home>") 'xah-fly-command-mode-activate)


;;;; --- FIX: ESC = SWITCH MODE + CANCEL SELECTION
;; This ensures the mark is gone when you escape back to command mode
  ;; (define-key global-map (kbd "<escape>")
              ;; (lambda () (interactive)
                ;; (deactivate-mark)
                ;; (xah-fly-command-mode-activate)))

;; (define-key xah-fly-insert-map (kbd "<escape>")
  ;; (lambda () (interactive)
    ;; (keyboard-quit)
    ;; (xah-fly-command-mode-activate)))

;; (global-set-key (kbd "<escape>") 'keyboard-quit)


;;;; --- KEY OVERRIDES & EXTRA BINDINGS
  (global-set-key (kbd "C-s") 'save-buffer)
  (define-key xah-fly-leader-key-map (kbd "s") 'consult-line)
  (define-key xah-fly-leader-key-map (kbd "r") 'replace-string)
  (define-key xah-fly-leader-key-map (kbd "R") 'query-replace)
  (define-key xah-fly-leader-key-map (kbd "f") 'ibuffer)


;; VERT/HORIZ ENLARG
  (global-set-key (kbd "C-S-i") 'enlarge-window)
  (global-set-key (kbd "C-S-k") 'shrink-window)
  (global-set-key (kbd "C-S-l") 'enlarge-window-horizontally)
  (global-set-key (kbd "C-S-j") 'shrink-window-horizontally)
  (define-key xah-fly-leader-key-map (kbd "f") 'balance-windows)


;; NUMBERS ROW
  (define-key xah-fly-key-map (kbd "5") 'delete-char)
  (define-key xah-fly-key-map (kbd "6") 'xah-select-block)
  (define-key xah-fly-key-map (kbd "7") 'xah-select-line)
  (define-key xah-fly-key-map (kbd "8") 'xah-extend-selection)
  (define-key xah-fly-key-map (kbd "9") 'xah-select-text-in-quote)
  (define-key xah-fly-key-map (kbd "0") 'xah-pop-local-mark-ring)


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


;;;; --- OPEN/RELOAD CONFIG FILE [C-c 9 / C-c 0]
(defun config-visit ()
  (interactive)
  (find-file "~/.emacs.d/rdo_base_conf.el"))
(global-set-key (kbd "C-c 9") 'config-visit)

(defun config-reload ()
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/rdo_base_conf.el")))
(global-set-key (kbd "C-c 0") 'config-reload)


;;; --- COMPLETION STACK  (Vertico/Consult/Embar/Marginalia/Orderless) ---
(use-package vertico :ensure t :init (vertico-mode))
(use-package orderless :ensure t :custom (completion-styles '(orderless basic)))
(use-package marginalia :ensure t :init (marginalia-mode))
(use-package consult :ensure t)
(use-package embark :ensure t :bind (("C-." . embark-act) ("M-." . embark-dwim)))
(use-package embark-consult :ensure t :after (embark consult) :hook (embark-collect-mode . consult-preview-at-point-mode))


;;; --- EDITING POWER TOOLS ---
(use-package multiple-cursors
  :ensure t
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this))
  :config (setq mc/always-run-for-all t))

(use-package iedit :ensure t :bind ("C-;" . iedit-mode))
(use-package avy :ensure t :bind ("M-s" . avy-goto-char-2))
(use-package which-key :ensure t :init (which-key-mode))
(use-package sudo-edit :ensure t :commands (sudo-edit))
(use-package beacon :ensure t :defer 1 :init (beacon-mode 1))



;;; --- BUILT-IN CONFIGS & SYSTEM ---
(use-package savehist
  :init
  (setq savehist-file "~/.emacs.d/history"
        history-length 1000
        history-delete-duplicates t)
  (savehist-mode 1))
  (add-to-list 'savehist-additional-variables 'query-replace-history)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq inhibit-startup-message t
      ring-bell-function 'ignore
      scroll-conservatively 100
      scroll-preserve-screen-position t
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      case-fold-search t
      read-quoted-char-radix 10)
;; controls number system (base) numerical code
;; Default (8): Octal (0-7) type C-q 141, get "a"
;; Value (10): Decimal type C-q 97 get "a"
;; Value (16): Hexadecimal type C-q 61 get "a"

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)



;;; --- UI ELEMENTS ---
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(column-number-mode 1)
(show-paren-mode 1)
(save-place-mode 1)
(delete-selection-mode t)
(global-subword-mode 1)
(when window-system (global-hl-line-mode t))
(display-time)
(setq display-time-24hr-format t display-time-load-average nil)
(when window-system (global-prettify-symbols-mode t))


;; BRACKET MANAGEMENT
(electric-pair-mode 1)
(setq electric-pair-pairs '((?\{ . ?\}) (?\( . ?\)) (?\[ . ?\]) (?\" . ?\")))


;; 80-Col DELIMITER
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)



;;; --- APPEARANCE & THEMES ---
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t doom-themes-enable-italic t)
  (load-theme 'doom-tomorrow-night t)

  ;; Apply Org faces ONLY after Org is loaded to prevent "Invalid Face" error
  (with-eval-after-load 'org
    (set-face-attribute 'org-level-1 nil :height 1.3)
    (set-face-attribute 'org-level-2 nil :height 1.2)
    (set-face-attribute 'org-level-3 nil :height 1.1)
    (set-face-attribute 'org-level-4 nil :height 1.0)))

(use-package doom-modeline
  :ensure t
  :init (add-hook 'after-init-hook #'doom-modeline-mode)
  :config (setq doom-modeline-icon nil doom-modeline-minor-modes nil))



;;; --- ORG MODE (Lazy Loaded) ---
(use-package org
  :ensure nil
  :defer t
  :config
  (setq org-dir "~/Docs/Org/"
        dropbox-orgriz "~/Desk/Dropbox/orgriz/"
        dropbox-configs "~/Desk/Dropbox/configs/"
        org-hide-leading-stars t
        org-startup-folded t
        org-src-window-setup 'current-window
        org-support-shift-select t
        org-hide-emphasis-markers t)
  (setq org-emphasis-alist
        '(("*" (bold :weight black))
          ("/" (italic :foreground "dark salmon"))
          ("_" (:underline t :foreground "cyan"))
          ("=" (verbatim :foreground "tomato"))
          ("~" (:background "PaleGreen1" :foreground "dim gray"))
          ("+" (:strike-through t :foreground "dark orange")))))


;;;; --- ORG-CAPTURE + BULLETS
(use-package org-capture
  :bind ("C-c c" . org-capture)
  :config
  (setq org-export-coding-system 'utf-8)
  (setq org-capture-templates
        '(("r" "relatorio tcc" entry
           (file+headline "~/Desk/TCC_rdo/textos_tcc/relat_tcc.org" "March")
           "* %<%d/%m/%Y>\nAtividade: %^{qual atividade?}"
           :empty-lines 1 :append t))))

(use-package org-bullets :ensure t :hook (org-mode . org-bullets-mode))



;;; --- REGISTERS ---
(set-register ?a (cons 'file "~/Desk/Dropbox/orgriz/[PERSO]_agenda_2026.org"))
(set-register ?h (cons 'file "~/Desk/Dropbox/orgriz/health.org"))
(set-register ?s (cons 'file "~/Desk/Dropbox/configs/[BIZ]_sys_config.org"))
(set-register ?t (cons 'file "~/Docs/Org/trade_kbase.org"))
(set-register ?p (cons 'file "~/Docs/Org/perso_search.org"))



;;; --- DIRED ---
(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t
        dired-listing-switches "-lH")
  (add-hook 'dired-mode-hook 'dired-hide-details-mode)
  :bind (:map dired-mode-map
              ("i" . dired-previous-line)
              ("k" . dired-next-line)
              ("j" . dired-up-directory)
              ("l" . dired-open-file)
              ("/" . dired-goto-file)))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind (:map dired-mode-map ("<tab>" . dired-subtree-cycle)))

(use-package dired-open
  :ensure t
  :config
  (setq dired-open-extensions
        '(("png"  . "nsxiv")
          ("jpg"  . "nsxiv")
          ("jpeg" . "nsxiv")
          ("gif"  . "nsxiv")
          ("bmp"  . "nsxiv")
          ("mkv"  . "mpv")
          ("avi"  . "mpv")
          ("mp4"  . "mpv")
          ("mp3"  . "mpv")
          ("pdf"  . "zathura"))))

(use-package async
  :ensure t
  :init (dired-async-mode 1))



;;; --- CUSTOM FUNCTIONS (Calc, Sum, Inc) ---

;;;; --- MINI-CALCULATOR  [C-x a]
(defun mini-calc (expr &optional arg)
  "Sum region or eval expr, copied to clipboard."
  (interactive
   (let ((input nil))
     (cond ((use-region-p)
            (let ((text (buffer-substring-no-properties (region-beginning) (region-end)))
                  (nums nil) (start 0))
              (while (string-match "-?[0-9]+\\.?[0-9]*" text start)
                (push (match-string 0 text) nums)
                (setq start (match-end 0)))
              (setq input (mapconcat #'identity (nreverse nums) " + "))))
           ((and (derived-mode-p 'org-mode) (org-at-table-p))
            (setq input (org-trim (org-table-get-field)))))
     (list (read-from-minibuffer "Enter expression: " input) current-prefix-arg)))
  (require 'calc)
  (let ((result (calc-eval expr)))
    (kill-new result)
    (if arg (insert result) (message "Result: %s (copied)" result))))

(global-set-key (kbd "C-x a") 'mini-calc)  ;; KEYBIND


;;;; ---- ORG COLUMN SUM  [C-x s]
(defun org-column-sum (col-num &optional arg)
  "Sum values in a specific column within highlighted rows.

1. Asks for COLUMN NUMBER.
2. Iterates through the highlighted region.
3. Extracts the value from that specific column in every row.
4. Pre-fills the calculator with the sum."
  (interactive "nColumn Number to Sum: \nP")
  (require 'org)
  (require 'org-table)
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

(global-set-key (kbd "C-x s") 'org-column-sum)  ;; KEYBIND


;;;; --- INCREMENT-NUMBER-DECIMAL  [C-c +]
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
(global-set-key (kbd "C-c +") 'increment-number-decimal)


;;;; --- EVALUATE & REPLACE SEXP  [C-c e]
(defun eval-replace ()
  "Replace sexp before point by result of its evaluation."
  (interactive)
  (let ((result (pp-to-string (eval (pp-last-sexp) lexical-binding))))
    (delete-region (save-excursion (backward-sexp) (point)) (point))
    (insert result)))

(global-set-key (kbd "C-c e") 'eval-replace)


;;;; --- PACKAGE FILTER
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


;;;; --- COLORED JUMP MARKS (CUSTOM:CJM) ---

(defvar-local my-cycle-marks nil "List of active markers for this buffer.")
(defvar-local my-cycle-overlays nil "List of active overlays for this buffer.")
(defvar-local my-cycle-index 0 "Current position in the cycle.")

(defun my-set-cycle-mark ()
  "Set a persistent colored mark at point. Replaces oldest if over 3."
  (interactive)
  (let* ((max-marks 3)
         (colors '("green" "yellow" "hot pink"))
         (new-marker (point-marker))
         (new-ov (make-overlay (point) (1+ (point)))))

    ;; Apply the color based on the current number of marks
    (overlay-put new-ov 'face `(:background ,(nth (length my-cycle-marks) colors) :foreground "white"))

    ;; Add to the front of our lists
    (push new-marker my-cycle-marks)
    (push new-ov my-cycle-overlays)

    ;; If we hit 4 marks, remove the oldest (the last one in the list)
    (when (> (length my-cycle-marks) max-marks)
      (let ((old-m (car (last my-cycle-marks)))
            (old-ov (car (last my-cycle-overlays))))
        (set-marker old-m nil)
        (delete-overlay old-ov)
        (setq my-cycle-marks (butlast my-cycle-marks))
        (setq my-cycle-overlays (butlast my-cycle-overlays))))

    (message "Mark %d set (Total: %d)" (length my-cycle-marks) (length my-cycle-marks))))

(defun my-jump-cycle-mark ()
  "Jump to the next mark in the cycle."
  (interactive)
  (if (not my-cycle-marks)
      (message "No marks set in this buffer.")
    (let ((target (nth my-cycle-index my-cycle-marks)))
      (goto-char (marker-position target))
      (message "Jumped to mark %d" (1+ my-cycle-index))
      ;; Increment index for next press, wrap around if at the end
      (setq my-cycle-index (% (1+ my-cycle-index) (length my-cycle-marks))))))

(defun my-clear-all-cycle-marks ()
  "Remove all colored jump marks from the current buffer."
  (interactive)
  (mapc 'delete-overlay my-cycle-overlays)
  (dolist (m my-cycle-marks) (set-marker m nil))
  (setq my-cycle-marks nil
        my-cycle-overlays nil
        my-cycle-index 0)
  (message "Buffer marks cleared."))

;; -----> BINDINGS (CUSTOM:CJM)
(with-eval-after-load 'xah-fly-keys
  ;; Set Mark: SPC 0
  (define-key xah-fly-key-map (kbd "SPC 0") 'my-set-cycle-mark)

  ;; Jump/Cycle: 0 (Command Mode)
  (define-key xah-fly-key-map (kbd "0") 'my-jump-cycle-mark)

  ;; Erase All: SPC 9
  (define-key xah-fly-key-map (kbd "SPC 9") 'my-clear-all-cycle-marks))



;;; --- SYNTAX HIGHLIGHTER ---
;;kdl tree siter mode
;(use-package kdl-ts-mode
;  :ensure t
;  :mode "\\.kdl\\'"
;  :config
;  ;; If the grammar isn't installed automatically:
;  (unless (treesit-language-available-p 'kdl)
;    (add-to-list 'treesit-language-source-alist
;                 '(kdl "https://github.com/kdl-org/tree-sitter-kdl"))
;    (treesit-install-language-grammar 'kdl)))


;; Local Variables:
;; eval: (outline-minor-mode 1)
;; eval: (local-set-key (kbd "<tab>") 'outline-cycle)
;; outline-regexp: ";;;+ ?---"
;; End:
