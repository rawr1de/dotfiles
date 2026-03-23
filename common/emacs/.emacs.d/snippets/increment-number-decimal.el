;;;; --- INCREMENT-NUMBER-DECIMAL  [C-c +]
;; Increments number at point or all numbers in a region by a set amount.
;; Smartly preserves zero-padding (009 -> 010) and handles negative results.
;; Use C-c + for +1, or C-u <num> C-c + to increment by a specific value.

(defun increment-number-decimal (&optional arg)
  "Increment all numbers in region or number at point by ARG.
Preserves zero-padding (e.g. 00 -> 01, 000 -> 001)."
  (interactive "p*")
  (let ((inc-by (if arg arg 1)))
    (if (use-region-p)
        ;; Region: increment every number found, preserving padding
        (let ((text (buffer-substring (region-beginning) (region-end)))
              (offset 0)
              (start (region-beginning)))
          (deactivate-mark)
          (with-temp-buffer
            (insert text)
            (goto-char (point-min))
            (while (re-search-forward "[0-9]+" nil t)
              (let* ((field-width (- (match-end 0) (match-beginning 0)))
                     (answer (+ (string-to-number (match-string 0) 10)
                                inc-by))
                     (answer (if (< answer 0)
                                 (+ (expt 10 field-width) answer)
                               answer))
                     (replacement (format (concat "%0"
                                                  (int-to-string field-width)
                                                  "d")
                                          answer)))
                (replace-match replacement)))
            (let ((new-text (buffer-string)))
              (delete-region start (+ start (length text)))
              (goto-char start)
              (insert new-text))))
      ;; No region: increment number at point
      (save-excursion
        (save-match-data
          (skip-chars-backward "0123456789")
          (when (re-search-forward "[0-9]+" nil t)
            (let* ((field-width (- (match-end 0) (match-beginning 0)))
                   (answer (+ (string-to-number (match-string 0) 10)
                              inc-by))
                   (answer (if (< answer 0)
                               (+ (expt 10 field-width) answer)
                             answer)))
              (replace-match
               (format (concat "%0" (int-to-string field-width) "d")
                       answer)))))))))
(provide 'increment-number-decimal)
;;; increment-number-decimal.el <-- ENDS HERE
