;;;; --- MINI-CALCULATOR  [C-x a]
;; Extracts numbers from highlighted text or org-tables to build an equation.
;; Evaluates the math via calc and copies the final result to your clipboard.
;; Call with a prefix argument (C-u C-x a) to insert the answer directly.

(defun my-mini-calc (expr &optional arg)
  "Sum region or eval expr, copied to clipboard."
  (interactive
   (let ((input nil))
     (cond ((use-region-p)
            (let ((text (buffer-substring-no-properties
                         (region-beginning) (region-end)))
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

(provide 'my-mini-calc)
;;; mini-calc.el <-- ENDS HERE
