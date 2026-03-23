;;;; --- PACKAGE-FILTER
;; Adds status filtering (s) and mark searching (a) to the Package Menu.
;; Filter list by status: new, installed, dependency, or obsolete.
;; Quickly find all packages currently marked for install/delete/upgrade.

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

(with-eval-after-load 'package
  (define-key package-menu-mode-map "s" #'package-menu-filter-by-status)
  (define-key package-menu-mode-map "a" #'package-menu-find-marks))

(provide 'package-filter)
;;; package-filter.el <-- ENDS HERE
