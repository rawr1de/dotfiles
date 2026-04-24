;;;; --- ENCLOSE ORG TABLE ---
;; Automatically adds a top and bottom horizontal rule to an open Org mode table.

(defun my-org-table-enclose ()
  "Add top/bottom borders (enclosing) the current Org table"
  (interactive)
  (if (not (org-at-table-p))
      (message "Not inside an Org table!")
    (save-excursion
      ;; 1. Jump to the absolute top of the table and insert a line ABOVE (t)
      (goto-char (org-table-begin))
      (org-table-insert-hline t)

      ;; 2. Jump to the absolute bottom, step back onto the last row, and insert BELOW
      (goto-char (org-table-end))
      (forward-line -1)
      (org-table-insert-hline)

      ;; 3. Re-align the table so everything sits flush
      (org-table-align))
    (message "Table enclosed!")))

(provide 'my-org-table-enclose)
;; my-org-table-enclose.el --> END OF FILE
