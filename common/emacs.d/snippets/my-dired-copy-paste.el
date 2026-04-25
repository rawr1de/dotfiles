;;; my-dired-copy-paste.el --- cut/copy/paste files and directories in dired mode

;; Copyrigth (C) 2011 Hidaka Uchida

;; Author: Hidaka Uchida <hidaka.uchida@gmail.com>
;; Version: 0.1
;; Created: Jan 8 2011
;; Keywords; dired, cut, copy, paste

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING. If not, write to the
;; Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:
;;
;; my-dired-copy-paste.el enables you to cut/copy/paste files and directries in dired-mode.

;;; Install:
;;
;; Put this file into your load-path and add the
;; following expression to your ~/.emacs.
;;
;; (require 'my-dired-copy-paste)

;;; Usage:
;;
;; In dired-mode,
;;
;;  M-x my-dired-copy-paste-do-cut   <C-c C-w>: Cut a file/dir on current line or all marked file/dir(s).
;;  M-x my-dired-copy-paste-do-copy  <C-c C-c>: Copy a file/dir on current line or all marked file/dir(s).
;;  M-x my-dired-copy-paste-do-paste <C-c C-y>: Paste cut/copied file/dir(s) into current directory.

;;; Code:

(require 'dired)

(defvar my-dired-copy-paste-func nil)
(defvar my-dired-copy-paste-stored-file-list nil)


(defun my-dired-copy-paste-do-cut ()
  "In dired-mode, cut a file/dir on current line or all marked file/dir(s)"
  (interactive)
  (setq my-dired-copy-paste-stored-file-list (dired-get-marked-files)
        my-dired-copy-paste-func 'rename-file)
  (message
   (format "%S is/are cut." my-dired-copy-paste-stored-file-list)))


(defun my-dired-copy-paste-do-copy ()
  "In dired-mode, copy a file/dir on current line or all marked file/dir(s)"
  (interactive)
  (setq my-dired-copy-paste-stored-file-list (dired-get-marked-files)
        my-dired-copy-paste-func 'copy-file)
  (message
   (format "%S is/are copied." my-dired-copy-paste-stored-file-list)))


(defun my-dired-copy-paste-do-paste ()
  "In dired-mode, paste cut/copied file/dir(s) into current directory."
  (interactive)
  (let ((stored-file-list nil))
    (dolist (stored-file my-dired-copy-paste-stored-file-list)
      (condition-case nil
          (progn
            (funcall my-dired-copy-paste-func stored-file (dired-current-directory) 1)
            (push stored-file stored-file-list))
        (error nil)))
    (if (eq my-dired-copy-paste-func 'rename-file)
        (setq my-dired-copy-paste-stored-file-list nil
              my-dired-copy-paste-func nil))
    (revert-buffer)
    (message
     (format "%d file/dir(s) pasted into current directory." (length stored-file-list)))))


(provide 'my-dired-copy-paste)
