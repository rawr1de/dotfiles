;;; my-musk-show-album-art.el --- Dedicated Album Art Viewer using swayimg

(require 'emms)

;;; --- ALBUM ART VIEWER (swayimg)
(defun my-musk-show-album-art ()
  "Launch swayimg, searching recursively for artwork inside the track's directory."
  (interactive)
  (let* ((track (emms-playlist-current-selected-track))
         (file-path (when track (emms-track-get track 'name)))
         (dir (when file-path (file-name-directory file-path))))

    (if (and dir (file-exists-p dir))
        ;; Recursively find all image files in the album's folder
        (let ((images (directory-files-recursively
                       dir "\\.\\(jpg\\|jpeg\\|png\\|bmp\\|webp\\|gif\\)$")))
          (if images
              (progn
                (message "Opening album art in swayimg...")
                ;; Pass the FIRST found image to swayimg. Because we enabled 'adjacent files' 
                ;; earlier, it will natively group the rest of the images in that subfolder!
                (start-process "emms-art-viewer" nil "swayimg" "--class" "emms-art" (car images)))
            (message "No artwork images found in %s or its subfolders." dir)))
      (message "No track selected or directory not found."))))

(provide 'my-musk-show-album-art)
