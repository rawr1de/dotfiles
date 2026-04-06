(defun my-batt-conserv-change (state)
  "Toggle Lenovo Legion battery conservation mode without writing local files."
  (interactive "nConservation mode (0=off 1=on): ")
  (let ((path "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"))
    ;; We use a pipe to send the number directly to sudo tee
    (with-temp-buffer
      (insert (number-to-string state))
      (call-process-region (point-min) (point-max) "sudo" nil nil nil "tee" path))
    (message "Battery conservation mode set to %d" state)))

(provide 'my-batt-conserv-change)
