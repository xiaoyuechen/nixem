;;; mu4e.el --- Mu4e configurations                  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Xiaoyue Chen

;; Author: Xiaoyue Chen <xchen@vvvu.org>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(use-package mu4e
  :ensure t
  :bind
  (("C-c m" . mu4e)
   :map mu4e-main-mode-map
   ("q" . (lambda ()
            (interactive)
            (mu4e-context-switch nil "vvvu")
            (bury-buffer))))

  :config
  (setq mu4e-update-interval 300)
  (setq mail-user-agent 'mu4e-user-agent)
  (setq gnus-dired-mail-mode 'mu4e-user-agent)
  (setq read-mail-command 'mu4e)
  (setq mu4e-headers-fields '((:human-date . 11)
                              (:flags . 4)
                              (:mailing-list . 10)
                              (:from-or-to . 22)
                              (:thread-subject)))
  (setq mu4e-completing-read-function 'completing-read)
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-change-filenames-when-moving t)
  (setq mu4e-index-cleanup nil      ;; don't do a full cleanup check
        mu4e-index-lazy-check t)    ;; don't consider up-to-date dirs
  (setq mu4e-hide-index-messages t)
  (setq mu4e-change-filenames-when-moving t)
  (setq message-send-mail-function 'smtpmail-send-it)
  (setq message-kill-buffer-on-exit t)
  (setq mu4e-context-policy 'pick-first)
  (setq mu4e-compose-dont-reply-to-self t)
  (setq mu4e-attachment-dir "~/Downloads")
  (setq mu4e-headers-date-format "%F")
  (setq mu4e-maildir-shortcuts
        '((:maildir "/uu/Inbox" :key ?u)
          (:maildir "/vvvu/Inbox" :key ?v)))
  (setq mu4e-contexts
        `(,(make-mu4e-context
            :name "vvvu"
            :match-func
            (lambda (msg)
              (when msg
                (string-match-p "^/vvvu"
                                (mu4e-message-field msg :maildir))))
            :vars
            '((user-mail-address . "xchen@vvvu.org")
              (mu4e-sent-folder . "/vvvu/Sent")
              (mu4e-drafts-folder . "/vvvu/Drafts")
              (mu4e-trash-folder . "/vvvu/Trash")
              (mu4e-refile-folder . "/vvvu/Archive")
              (mu4e-sent-messages-behavior . sent)
              (smtpmail-smtp-server . "smtp.sendgrid.net")
              (smtpmail-servers-requiring-authorization . "smtp.sendgrid.net")
              (smtpmail-smtp-service . 587)
              (smtpmail-stream-type . starttls)
              (mu4e-compose-signature
               . (concat "Xiaoyue Chen\n"
                         "VVVU: Workers, Unite!"))))
          ,(make-mu4e-context
            :name "uu"
            :match-func
            (lambda (msg)
              (when msg
                (string-match-p "^/uu"
                                (mu4e-message-field msg :maildir))))
            :vars
            '((user-mail-address . "xiaoyue.chen@it.uu.se")
              (mu4e-sent-folder . "/uu/Sent Items")
              (mu4e-drafts-folder . "/uu/Drafts")
              (mu4e-trash-folder . "/uu/Deleted Items")
              (mu4e-refile-folder . "/uu/Archive")
              (mu4e-sent-messages-behavior . sent)
              (smtpmail-smtp-server . "mail.uu.se")
              (smtpmail-servers-requiring-authorization . "mail.uu.se")
              (smtpmail-smtp-service . 587)
              (smtpmail-stream-type . starttls)
              (mu4e-compose-signature
               . (concat "Xiaoyue Chen, PhD Student\n"
                         "Division of Computer Systems\n"
                         "Department of Information Technology\n"
                         "Uppsala University"))))))

  :hook
  (mu4e-compose-mode . turn-on-orgtbl)
  (after-init . (lambda () (mu4e-update-mail-and-index t))))

(use-package mu4e-alert
  :ensure t
  :config
  (mu4e-alert-set-default-style 'notifications)
  (setq mu4e-alert-email-notification-types '(count subjects))
  :hook
  (after-init . mu4e-alert-enable-notifications)
  (after-init . mu4e-alert-enable-mode-line-display))

(use-package mu4e-icalendar
  :after (mu4e)
  :config
  (mu4e-icalendar-setup)
  (setq gnus-icalendar-org-capture-file "~/Org/ical/mail.org")
  (setq gnus-icalendar-org-capture-headline '("Calendar"))
  (gnus-icalendar-org-setup))

(use-package gnus
  :hook
  (mu4e-compose-mode . sign-mail)
  (dired-mode . turn-on-gnus-dired-mode)
  :config
  (defun sign-mail ()
    (let* ((ctx (mu4e-context-current))
           (name (if ctx (mu4e-context-name ctx))))
      (when name
        (cond
         ((member name '("uu" "vvvu"))
          (mml-secure-sign))))))

  (setq mml-secure-openpgp-sign-with-sender t))

;;; mu4e.el ends here
