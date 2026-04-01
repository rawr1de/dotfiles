;;;; --- EVALUATE & REPLACE SEXP
;; Evaluates the Lisp expression immediately before the cursor (the sexp).
;; Deletes the original code and replaces it with the evaluated result.
;; Useful for doing math, generating strings, or testing Elisp logic in-place.

(defun eval-replace ()
  "Replace sexp before point by result of its evaluation."
  (interactive)
  (let ((result (pp-to-string (eval (pp-last-sexp) lexical-binding))))
    (delete-region (save-excursion (backward-sexp) (point))
                   (point))
    (insert result)))

(provide 'eval-replace)
;;; eval-replace.el <-- ENDS HERE
