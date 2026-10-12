;; -*- lexical-binding: t; -*-

;; =========================================================
;; 1. INICIALIZAÇÃO BÁSICA E PACOTES
;; =========================================================
(setq user-emacs-directory "/home/rdo/.dotfiles/common/emacs.d/")
(setq package-user-dir (concat user-emacs-directory "elpa/"))

;; Habilita o repositório MELPA para o Emacs conseguir achar o XFK
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq gc-cons-threshold (* 50 1000 1000))
(setq native-comp-async-report-warnings-errors nil)
(setq warning-minimum-level :error)

;; =========================================================
;; 2. HERANÇA DO TEMA (custom.el)
;; =========================================================
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; =========================================================
;; 3. OTIMIZAÇÕES VISUAIS
;; =========================================================
(menu-bar-mode -1)
(require 'hl-line)
(set-face-attribute 'hl-line nil 
                    :inherit 'secondary-selection 
                    :background 'unspecified 
                    :foreground 'unspecified 
                    :weight 'unspecified 
                    :extend t)

;; =========================================================
;; 4. XAH-FLY-KEYS E TECLAS PERSONALIZADAS
;; =========================================================
(let ((xfk-paths (directory-files-recursively user-emacs-directory "xah-fly-keys\\.el$")))
  (when xfk-paths
    (add-to-list 'load-path (file-name-directory (car xfk-paths)))
    
    (when (require 'xah-fly-keys nil t)
      (xah-fly-keys-set-layout "qwerty")
      (xah-fly-keys 1)
      
      (setq xah-fly-insert-mode-activate-hook nil)
      (setq xah-fly-command-mode-activate-hook nil)
      (add-hook 'xah-fly-command-mode-activate-hook (lambda () (global-hl-line-mode 1)))
      (add-hook 'xah-fly-insert-mode-activate-hook (lambda () (global-hl-line-mode -1)))
      
      ;; --- GATILHOS DE ATIVAÇÃO FORÇADA (A Correção!) ---
      (global-set-key (kbd "<home>") 'xah-fly-command-mode-activate)
      (add-hook 'after-change-major-mode-hook #'xah-fly-command-mode-activate)
      
      ;; --- ATALHOS CUSTOMIZADOS DO XFK ---
      (define-key xah-fly-leader-key-map (kbd "a") nil)
      (define-key xah-fly-leader-key-map (kbd "=") 'balance-windows)
      (define-key xah-fly-key-map (kbd "SPC t") 'tab-new)
      (define-key xah-fly-key-map (kbd "SPC T") 'tab-bar-mode)

      (define-key xah-fly-leader-key-map (kbd ", s") 'save-buffer)
      (define-key xah-fly-leader-key-map (kbd "r") 'replace-string)
      (define-key xah-fly-leader-key-map (kbd "R") 'query-replace)
      (define-key xah-fly-leader-key-map (kbd "f") 'ibuffer)
      (define-key xah-fly-leader-key-map (kbd "SPC") 'kill-line)

      (define-key xah-fly-leader-key-map (kbd "u") 'switch-to-buffer)
      (define-key xah-fly-leader-key-map (kbd "s") 'isearch-forward)
      (define-key xah-fly-key-map (kbd "n") 'isearch-forward)
      (define-key xah-fly-leader-key-map (kbd "S") 'isearch-forward-word)

      (define-key xah-fly-key-map (kbd "5") 'delete-char)
      (define-key xah-fly-key-map (kbd "6") 'xah-select-block)
      (define-key xah-fly-key-map (kbd "7") 'xah-select-line)
      (define-key xah-fly-key-map (kbd "8") 'xah-select-text-in-quote))))

;; =========================================================
;; 5. ATALHOS DO SCRATCHPAD (Copiar/Fechar e Histórico)
;; =========================================================
(defun my-spad-copy-and-close ()
  "Copia todo o conteúdo para a área de transferência e fecha a janela."
  (interactive)
  (kill-new (buffer-string))
  (delete-frame))

(global-set-key (kbd "C-c v") #'my-spad-copy-and-close)

(global-set-key (kbd "C-c h") #'my-scratchpad-open-history)

;; =========================================================
;; 6. SCRATCHPAD E GATILHO
;; =========================================================
(load (concat user-emacs-directory "modules/my-scratchpad.el") nil t)

;; A ORDEM AQUI É VITAL!
;; 1. Primeiro, ele desenha e abre a janela do scratchpad
(add-hook 'server-after-make-frame-hook #'my-spawn-scratchpad)
;; 2. Segundos depois, ele FORÇA essa janela a entrar no Modo de Comando!
(add-hook 'server-after-make-frame-hook #'xah-fly-command-mode-activate)

;;; --- HISTORY VIEWER ---
(defun my-scratchpad-open-history ()
  "Abre o arquivo de histórico do scratchpad numa janela dedicada."
  (interactive)
  (let ((hist-file (expand-file-name ".spad_hist" user-emacs-directory)))
    (if (file-exists-p hist-file)
        (find-file-other-window hist-file)
      (message "Ainda não existem registos no histórico do scratchpad."))))
