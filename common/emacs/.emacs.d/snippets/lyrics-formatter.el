;;;; --- LYRICS FORMATTER
;; Cleans scraped lyrics by extracting titles, re-numbering, and fixing spacing.
;; Removes "Hide lyrics" noise and trims whitespace for a clean reading layout.
;; Run via M-x format-lyrics-current-buffer to reformat the active document.

(defun format-lyrics-buffer (&optional blank-lines)
  "Format lyrics in current buffer.
BLANK-LINES specifies number of blank lines between songs (default 3)."
  (interactive "p")
  (unless blank-lines (setq blank-lines 3))

  (save-excursion
    (goto-char (point-min))
    (let ((song-num 0)
          (output "")
          (first-song t)
          (in-lyrics nil))

      ;; Process each line
      (while (not (eobp))
        (let ((line (buffer-substring-no-properties
                     (line-beginning-position)
                     (line-end-position))))

          ;; Check if line starts with number (song header)
          (if (string-match "^\\([0-9]+\\)\\.[[:space:]]" line)
              (progn
                (setq song-num (1+ song-num))
                (setq in-lyrics t)

                ;; Extract title (between number and timestamp)
                (string-match "^[0-9]+\\.[[:space:]]+\\([^[:space:]]+.*?\\)[[:space:]]+[0-9]+:[0-9]+" line)
                (let ((title (string-trim (match-string 1 line))))

                  ;; Add blank lines before song (except first)
                  (unless first-song
                    (dotimes (i blank-lines)
                      (setq output (concat output "\n"))))
                  (setq first-song nil)

                  ;; Add formatted song header
                  (setq output (concat output
                                       (format "%02d.)  %s\n\n" song-num title)))))

            ;; Not a song header - process lyrics
            (when in-lyrics
              ;; Skip "Hide lyrics" line
              (unless (string-match "Hide lyrics" line)
                ;; Add line with leading whitespace removed
                (let ((cleaned (string-trim-left line)))
                  (setq output (concat output cleaned "\n")))))))

        (forward-line 1))

      ;; Replace buffer content with formatted output
      (erase-buffer)
      (insert output)
      (goto-char (point-min))
      (message "Formatted %d songs with %d blank lines between" song-num blank-lines))))

(defun format-lyrics-file (input-file output-file &optional blank-lines)
  "Format lyrics from INPUT-FILE and save to OUTPUT-FILE.
BLANK-LINES specifies number of blank lines between songs (default 3)."
  (interactive
   (list (read-file-name "Input file: ")
         (read-file-name "Output file: ")
         (read-number "Blank lines between songs: " 3)))

  (with-temp-buffer
    (insert-file-contents input-file)
    (format-lyrics-buffer blank-lines)
    (write-region (point-min) (point-max) output-file)
    (message "Formatted lyrics saved to: %s" output-file)))

;; Interactive command to format current buffer
(defun format-lyrics-current-buffer ()
  "Format lyrics in current buffer with 3 blank lines between songs."
  (interactive)
  (format-lyrics-buffer 3))
(provide 'lyrics-formatter)
;;; lyrics-formatter.el <-- ENDS HERE
