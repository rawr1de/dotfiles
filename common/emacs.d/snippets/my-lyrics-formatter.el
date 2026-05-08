;;; lyrics-formatter.el --- Format lyrics files -*- lexical-binding: t -*-

(eval-when-compile (require 'subr-x))
(require 'dired)

(defun my-format-lyrics-buffer (&optional blank-lines)
  "Format lyrics in the current buffer.
BLANK-LINES specifies the number of blank lines between songs (default 3)."
  (interactive "P") ; Capital P passes nil if no prefix is given
  
  ;; Safely extract the number of lines, defaulting to 3
  (let ((blank-lines (cond
                      ((numberp blank-lines) blank-lines)
                      ((consp blank-lines) (prefix-numeric-value blank-lines))
                      (t 3)))
        (song-num 0)
        (first-song t)
        (in-lyrics nil)
        (temp-buf (generate-new-buffer " *lyrics-temp*")))
    
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (let ((line (buffer-substring-no-properties
                     (line-beginning-position)
                     (line-end-position))))
          
          ;; 1. Identify: Does it start with a number, punctuation, and space?
          (if (string-match "^[0-9]+[.)]+[[:space:]]+\\(.*\\)$" line)
              (let ((raw-title (match-string 1 line)))
                
                ;; 2. Extract & Scrub: Chop off timestamps and "Hide lyrics" from the end
                (setq raw-title (replace-regexp-in-string "[[:space:]]+[0-9]+:[0-9]+.*$" "" raw-title))
                (setq raw-title (replace-regexp-in-string "[[:space:]]*Hide lyrics.*$" "" raw-title))
                (setq raw-title (string-trim raw-title))

                (setq song-num (1+ song-num))
                (setq in-lyrics t)

                (with-current-buffer temp-buf
                  ;; Add blank lines BEFORE the new song (except the very first one)
                  (unless first-song
                    (insert (make-string blank-lines ?\n)))
                  (setq first-song nil)

                  ;; Print the formatted header, followed by a double line break
                  (insert (format "%02d.)  %s\n\n" song-num raw-title))))
            
            ;; 3. Process Lyrics
            (when in-lyrics
              ;; Skip standalone "Hide lyrics" lines
              (unless (string-match-p "Hide lyrics" line)
                (with-current-buffer temp-buf
                  ;; Strip leading whitespace and insert the line
                  (insert (string-trim-left line) "\n"))))))
        
        (forward-line 1)))

    ;; Swap the active buffer's content with our perfectly formatted output
    (erase-buffer)
    (insert-buffer-substring temp-buf)
    (kill-buffer temp-buf)
    (goto-char (point-min))
    (message "Formatted %d songs." song-num)))

;; Interactive command for Dired/Dirvish
(defun my-format-lyrics-dired-marked (&optional blank-lines)
  "Format marked lyrics files in Dired and save as sequential files.
Does not prompt. Generates files like original_01.txt, original_02.txt."
  (interactive "P")
  
  (let ((files (dired-get-marked-files nil nil nil nil t))
        ;; Apply the same robust prefix parsing here
        (bl (cond ((numberp blank-lines) blank-lines)
                  ((consp blank-lines) (prefix-numeric-value blank-lines))
                  (t 3))))
    
    (unless files
      (user-error "No files marked for formatting"))
    
    (dolist (file files)
      (let* ((dir (file-name-directory file))
             (base (file-name-sans-extension (file-name-nondirectory file)))
             (ext (or (file-name-extension file t) "")) 
             (counter 1)
             (new-file (format "%s%s_%02d%s" dir base counter ext)))
        
        ;; Iterate until we find a free sequential filename
        (while (file-exists-p new-file)
          (setq counter (1+ counter))
          (setq new-file (format "%s%s_%02d%s" dir base counter ext)))
        
        ;; Process the file silently in the background
        (with-temp-buffer
          (insert-file-contents file)
          ;; Run the exact same engine over the file contents
          (my-format-lyrics-buffer bl)
          (write-region (point-min) (point-max) new-file nil 'silent))
        
        (message "Saved formatted lyrics to: %s" (file-name-nondirectory new-file))))))

(provide 'my-lyrics-formatter)
;;; lyrics-formatter.el ends here
