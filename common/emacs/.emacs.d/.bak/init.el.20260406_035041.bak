;;;;;;;;;;  NEW LIGHTWEIGHT INIT.EL  ;;;;;;;;;;

;; 0. Move customization variables outside of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; 1. Setup Package Repositories
(require 'package)
(setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
			 ("gnu"   . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("org"   . "https://orgmode.org/elpa/")))
(package-initialize)

;; 2. THE BOOTSTRAP
;; This automatically tangles base_cfg_1.org into base_cfg_1.el if there are changes, 
;; and then loads it.
(org-babel-load-file (expand-file-name "base_cfg_1.org" user-emacs-directory))

(put 'emms-browser-delete-files 'disabled nil)
