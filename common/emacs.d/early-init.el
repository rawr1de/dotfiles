;; early-init.el — runs before frame creation and package init  -*- lexical-binding: t; -*-
;; 1. Força o diretório do usuário antes de tudo
(setq user-emacs-directory "/home/rdo/.dotfiles/common/emacs.d/")

;; 2. Redireciona a criação do auto-save-list para dentro dos seus dotfiles
(setq auto-save-list-file-prefix "/home/rdo/.dotfiles/common/emacs.d/auto-saves/.saves-")

;; 3. Configurações visuais iniciais
(set-face-attribute 'default nil
  :family "JetBrainsMonoNL Nerd Font"
  :weight 'medium
  :height 160)
