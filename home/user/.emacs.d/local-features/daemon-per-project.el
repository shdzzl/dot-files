;;; daemon-per-project.el

;;; Commentary:
;;
;; Use daemons to configure emacs per project. Creates a desktop
;; directory for the current daemon on startup, saves desktop on
;; auto-save and when emacs is killed.
;;

;;; Code:
(require 'misc-utils)

(defun resolve-daemon-name ()
  (or (daemonp) "no-daemon"))

(defun daemon-desktop-dir (daemon-name)
  (make-dir-path user-emacs-directory "desktops" daemon-name))

(defun load-project-settings ()
  (when-let ((daemon-name (resolve-daemon-name))
             (project-sym (intern (concat daemon-name "-project"))))
    (require project-sym nil t)))

;; Desktop hooks

(defun desktop-read-on-init ()
  (let* ((daemon-name (resolve-daemon-name))
         (desktop-dir (daemon-desktop-dir daemon-name))
         (lock-file (expand-file-name ".emacs.desktop.lock" desktop-dir)))
    (make-directory desktop-dir t)
    (when (and (file-exists-p lock-file)
               (file-writable-p lock-file))
      (delete-file lock-file))
    (desktop-read desktop-dir)))

(add-hook 'after-init-hook 'desktop-read-on-init)

(defun desktop-save-on-auto-save ()
  (let* ((daemon-name (resolve-daemon-name))
         (desktop-dir (daemon-desktop-dir daemon-name)))
    (make-directory desktop-dir t)
    (desktop-save desktop-dir)))

(add-hook 'auto-save-hook 'desktop-save-on-auto-save)

(defun desktop-save-on-kill ()
  (let* ((daemon-name (resolve-daemon-name))
         (desktop-dir (daemon-desktop-dir daemon-name)))
    (make-directory desktop-dir t)
    (desktop-save desktop-dir)
    (desktop-release-lock desktop-dir)))

(add-hook 'kill-emacs-hook 'desktop-save-on-kill)

(provide 'daemon-per-project)
;;; daemon-per-project.el ends here
