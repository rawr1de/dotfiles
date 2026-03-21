;;;;;;;;;;  NEW LIGHTWEIGHT INIT.EL  ;;;;;;;;;;

;; 0. Move customization variables outside of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; 1. Setup Package Repositories
(require 'package)
(setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")			 
			 ("org"   . "https://orgmode.org/elpa/")))
(package-initialize)

;; 2. THE SWITCHBOARD
;; Uncomment ONLY ONE line to choose your configuration:

;; --- Option 1: The Hybrid (MC + iEdit + Your 400 lines) ---
(load (expand-file-name "rdo_base_conf.el" user-emacs-directory))

;; --- Option 2: The MC Only version ---
;; (load (expand-file-name "config_-_FINAL_MERGED_MASTER_MC_only.el" user-emacs-directory))

;; --- Option 3: Your old base (if you exported it to .el) ---
;; (load (expand-file-name "config.el" user-emacs-directory))
