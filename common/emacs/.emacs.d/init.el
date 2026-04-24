;;;;;;;;;;  NEW LIGHTWEIGHT INIT.EL  ;;;;;;;;;;

;; Load your ACTUAL configuration file (the one you just uploaded!)
(load (expand-file-name "init.el" user-emacs-directory))

;; Move customization variables outside of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Setup Package Repositories
(require 'package)
(setq package-archives '(("ELPA"   . "https://tromey.com/elpa/")
			 ("gnu"    . "https://elpa.gnu.org/packages/")
			 ("melpa"  . "https://melpa.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")
			 ("org"    . "https://orgmode.org/elpa/")))
(package-initialize)

;; THE BOOTSTRAP
;; This automatically tangles base_cfg.org into base_cfg.el
;; if there are changes, and then loads it
(org-babel-load-file (expand-file-name "base_cfg.org" user-emacs-directory))

;; load experimental config second
(load (expand-file-name "test_new.el" user-emacs-directory) t)

(put 'emms-browser-delete-files 'disabled nil)
;; END OF FILE
