(message "test_new.el FILE HAS BEEN LOADED!")

;; CODE 1 - WATCHING...
;; dump emacs keys into a file
;; (with-temp-file "~/emacs-dump.txt"
  ;; (insert "// ORG MODE\n// ──────────────────────\n")
  ;; (insert (substitute-command-keys "\\{org-mode-map}"))
  ;; (insert "\n\n// ORG ROAM\n// ──────────────────────\n")
  ;; (insert (substitute-command-keys "\\{org-roam-mode-map}")))
;; END OF CODE 1




;; CODE 2 - WATCHING...
(use-package whisper
  :vc (:url "https://github.com/natrys/whisper.el" :branch "master")
  :bind ("C-c u" . whisper-run) ;; Change this bind to whatever you prefer
  :config
  ;; Use the optimized Arch binary
  (setq whisper-command "whisper-cpp")

  ;; Use sox for reliable microphone capture
  (setq whisper-recording-engine "sox")

  ;; Use the multilingual "small" model (approx. 466MB)
  (setq whisper-model "small")

  ;; Auto-detect language so it switches between English and Portuguese seamlessly
  (setq whisper-language "auto"
        whisper-translate nil)

  ;; Use half your CPU cores to process it blazingly fast
  (setq whisper-use-threads (/ (num-processors) 2)))
;; END OF CODE 2
