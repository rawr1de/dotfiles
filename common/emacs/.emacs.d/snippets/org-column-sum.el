;;;; ---- ORG COLUMN SUM  [C-x s]
;; Sums a specific column in highlighted Org table rows, ignoring h-lines.
;; Extracts numbers, builds an equation, and evals via calc to the clipboard.
;; Use prefix argument (C-u C-x s) to insert the result instead of copying.

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

(provide 'org-column-sum)
;;; org-column-sum.el <-- ENDS HERE
