;;; init.el --- My personal Emacs init file          -*- lexical-binding: t; -*-

;; Copyright (C) 2022, 2023, 2024, 2025  Xiaoyue Chen

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

(setq use-package-enable-imenu-support t)
(use-package use-package
  :init
  (setq use-package-always-defer t))

(use-package package
  :config
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

(use-package emacs
  :demand
  :bind
  ("C-c i" . scratch-buffer)

  :init
  (setq user-full-name "Xiaoyue Chen"
        user-mail-address "xchen@vvvu.org")

  (setq custom-file null-device)
  (set-face-attribute 'default nil :height 140)
  (load-theme 'leuven)
  (setq x-underline-at-descent-line t)
  (setq max-mini-window-height 0.6)
  (setq split-height-threshold nil)
  (setq enable-recursive-minibuffers t)
  (setq sentence-end-double-space nil)
  (setq auto-save-file-name-transforms nil)
  (setq delete-by-moving-to-trash t)
  (setq remote-file-name-inhibit-delete-by-moving-to-trash t)
  (setq require-final-newline t)
  (setq-default indent-tabs-mode nil)
  (setq tab-always-indent 'complete)
  (setq comment-empty-lines t)
  (setq async-shell-command-buffer 'new-buffer)
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (setq visual-line-fringe-indicators '(left-curly-arrow right-arrow))
  (setq set-mark-command-repeat-pop t)
  (setq initial-major-mode 'org-mode)
  (setq initial-scratch-message "#+title: Scratch\n\n")
  (setq completion-ignore-case t)

  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  (advice-add 'async-shell-command :after
              (lambda (command &optional output-buffer error-buffer)
                (unless output-buffer
                  (let ((output-buffer
                         (concat "*CMD " command "*")))
                    (with-current-buffer shell-command-buffer-name-async
                      (rename-buffer output-buffer t))))))

  (pixel-scroll-precision-mode)

  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)

  :hook
  (minibuffer-setup . cursor-intangible-mode)
  (before-save . delete-trailing-whitespace))

(use-package simple
  :hook
  (org-mode . auto-fill-mode))

(use-package project
  :config
  (setq project-vc-merge-submodules nil))

(use-package compile
  :config
  (setq compile-command "make -k -j $(nproc)"))

(use-package ispell
  :config
  (setq text-mode-ispell-word-completion nil)
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "sv_SE,en_GB"))

(use-package abbrev
  :delight)

(use-package comint
  :config
  (setq comint-prompt-read-only t
        comint-buffer-maximum-size 20000))

(use-package dired
  :config
  (defun xdg-open-from-dired ()
    (interactive)
    (call-process "xdg-open" nil 0 nil
                  (dired-get-filename nil t)))

  (setq dired-listing-switches "-alhv1")

  (put 'dired-find-alternate-file 'disabled nil)

  :bind
  ( :map dired-mode-map
    ("C-c o" . xdg-open-from-dired)
    ("C-c C-x a" . org-attach-dired-to-subtree)))

(use-package consult
  :ensure t
  :bind
  (;; C-c bindings (mode-specific-map)
   ("C-c h" . consult-history)
   ("C-c x" . consult-mode-command)
   ("C-c k" . consult-kmacro)

   ;; C-x bindings (ctl-x-map)
   ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
   ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
   ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
   ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
   ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
   ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer

   ;; Custom M-# bindings for fast register access
   ("M-#" . consult-register-load)
   ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
   ("C-M-#" . consult-register)

   ;; Other custom bindings
   ("M-y" . consult-yank-pop)                ;; orig. yank-pop

   ;; M-g bindings (goto-map)
   ("M-g e" . consult-compile-error)
   ("M-g f" . consult-make)
   ("M-g g" . consult-goto-line)             ;; orig. goto-line
   ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
   ("M-g o" . consult-outline)
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)

   ;; M-s bindings (search-map)
   ("M-s d" . consult-find)
   ("M-s D" . consult-locate)
   ("M-s g" . consult-grep)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)

   ;; Isearch integration
   ("M-s e" . consult-isearch-history)
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
   ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
   ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
   ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch

   ;; Minibuffer history
   :map minibuffer-local-map
   ("M-s" . consult-history)                 ;; orig. next-matching-history-element
   ("M-r" . consult-history)                 ;; orig. previous-
   )

  :config
  ;; Set narrow key
  (setq consult-narrow-key (kbd "<")
        consult-widen-key (kbd ">"))

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function 'consult-xref
        xref-show-definitions-function 'consult-xref))

(use-package consult-dir
  :ensure t
  :bind
  (("C-x C-d" . consult-dir)
   :map vertico-map
   ("C-x C-d" . consult-dir)
   ("C-x C-j" . consult-dir-jump-file)))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file . ((styles . (basic partial-completion))))
                                        (eglot . ((styles . (orderless))))))
  (setq orderless-component-separator "[ &]"))

(use-package cape
  :ensure t
  :hook
  (eshell-hist-mode . (lambda () (local-set-key (kbd "S-SPC") 'cape-history)))
  (comint-mode . (lambda () (local-set-key (kbd "S-SPC") 'cape-history))))

(use-package delight
  :ensure t)

(use-package recentf
  :init
  (recentf-mode)
  :config
  (setq recentf-max-saved-items 100)
  (setq recentf-exclude '(":[0-9],D?S")))

(use-package windmove
  :config
  (windmove-default-keybindings '(meta shift)))

(use-package engine-mode
  :ensure t
  :init
  (engine-mode)
  :config
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d")
  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "g")
  (defengine google-maps
    "http://maps.google.com/maps?q=%s"
    :keybinding "m")
  (defengine stack-overflow
    "https://stackoverflow.com/search?q=%s"
    :keybinding "s")
  (defengine wikipedia
    "http://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s"
    :keybinding "w")
  (defengine wiktionary
    (concat "https://www.wikipedia.org/search-redirect.php?"
            "family=wiktionary&language=en&go=Go&search=%s")
    :keybinding "t"))

(use-package calendar
  :config
  (setq calendar-week-start-day 1
        calendar-intermonth-text
        '(propertize
          (format "%2d"
                  (car
                   (calendar-iso-from-absolute
                    (calendar-absolute-from-gregorian (list month day year)))))
          'font-lock-face 'font-lock-warning-face)
        calendar-intermonth-header
        (propertize "Wk"
                    'font-lock-face 'font-lock-keyword-face)))

(use-package auth-source
  :config
  (setq auth-sources '("secrets:Login")))

(use-package ediff
  :config
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))

(use-package vterm
  :ensure t
  :config
  (setq vterm-buffer-name-string "*vterm %s*")
  (add-to-list 'vterm-tramp-shells '("ssh" "bash"))
  (add-to-list 'vterm-tramp-shells '("sudo" "bash")))

(use-package eshell
  :commands (spawn-eshell)
  :config
  (setq eshell-plain-echo-behavior t)
  (defun spawn-eshell (display)
    "Create a frame with a dedicated Eshell window."
    (select-frame (make-frame-on-display display))
    (let* ((default-directory "~")
           (buffer (eshell)))
      (set-window-dedicated-p (get-buffer-window buffer) t)))

  (dolist (module '(eshell-tramp eshell-elecslash))
    (add-to-list 'eshell-modules-list module))

  (setq eshell-history-size 10000)

  (defun dynamic-eshell-buffer-name ()
    (format "*eshell: %s*"
            (abbreviate-file-name (directory-file-name
                                   default-directory))))
  (defun rename-eshell-buffer ()
    (unless eshell-non-interactive-p
      (rename-buffer (dynamic-eshell-buffer-name) t)))

  (advice-add 'eshell :around
              (lambda (old-eshell &rest args)
                (let ((eshell-buffer-name (dynamic-eshell-buffer-name)))
                  (apply old-eshell args))))

  (setq eshell-destroy-buffer-when-process-dies t)

  :hook
  (eshell-mode . rename-eshell-buffer)
  (eshell-directory-change . rename-eshell-buffer)
  (eshell-expand-input . eshell-expand-history-references)
  (kill-emacs . eshell-save-some-history)

  :bind
  ("C-c e" . eshell))

(use-package pcmpl-args
  :ensure t
  :after (pcomplete))

(use-package bash-completion
  :ensure t
  :after (:any shell eshell)
  :config
  (add-to-list 'shell-dynamic-complete-functions 'bash-completion-dynamic-complete)

  (defun bash-completion-capf-nonexclusive ()
  "Bash completion function for `completion-at-point-functions'.

Returns the same list as the one returned by
`bash-completion-dynamic-complete-nocomint' appended with
\(:exclusive no) so that other completion functions are tried
when bash-completion fails to match the text at point."
  (let ((compl (bash-completion-dynamic-complete-nocomint
                (save-excursion (eshell-bol) (point))
                (point) t)))
    (when compl
      (append compl '(:exclusive no)))))

  :hook
  (eshell-mode
   . (lambda ()
       (add-hook 'completion-at-point-functions
                 #'bash-completion-capf-nonexclusive nil t))))

(use-package savehist
  :init
  (savehist-mode))

(use-package which-key
  :ensure t
  :delight
  :init
  (which-key-mode))

(use-package paren
  :init
  (show-paren-mode)
  :config
  (setq show-paren-delay 0))

(use-package elec-pair
  :init
  (electric-pair-mode))

(use-package delsel
  :init
  (delete-selection-mode))

(use-package ibuffer
  :config
  (add-hook 'ibuffer-mode-hook 'ibuffer-auto-mode)
  :bind
  (("C-x C-b" . ibuffer)))

(use-package imenu
  :config
  (setq imenu-auto-rescan t))

(use-package compile
  :bind
  (("C-c c" . compile)))

(use-package gdb-mi
  :config
  (setq gdb-many-windows t))

(use-package autorevert
  :config
  (global-auto-revert-mode))

(use-package lice
  :ensure t
  :demand)

(use-package license-templates
  :ensure t)

(use-package autoinsert
  :init
  (auto-insert-mode)

  :config
  (let ((insert-lice (lambda () (lice lice:default-license)
                       (insert "\n")))
        (c-header-condition
         '("\\.\\([Hh]\\|hh\\|hpp\\|hxx\\|h\\+\\+\\)\\'" . "C / C++ header"))
        (c-source-condition
         '("\\.\\([Cc]\\|cc\\|cpp\\|cxx\\|c\\+\\+\\)\\'" . "C / C++ program")))
    (define-auto-insert c-header-condition insert-lice)
    (define-auto-insert c-source-condition insert-lice)))

(use-package copyright
  :hook
  (before-save . copyright-update))

(use-package elide-head
  :hook
  (find-file . elide-head-mode))

(use-package org
  :commands
  (my-agenda)
  :config
  (setq org-export-with-author nil)
  (setq org-directory "~/Org")
  (setq org-template-directory (expand-file-name "templates" org-directory))
  (setq org-notes-directory (expand-file-name "notes" org-directory))
  (setq org-default-notes-file (expand-file-name "notes" org-notes-directory))
  (setq org-agenda-files (expand-file-name "agenda-file-list" org-directory))
  (setq org-babel-tangle-use-relative-file-links nil)
  (setq org-cite-global-bibliography
        (list (expand-file-name "ca.bib"
                                (expand-file-name "bib" org-directory))))

  (setq org-hide-emphasis-markers nil)
  (setq org-startup-folded 'nofold)
  (setq org-image-actual-width 800)
  (setq org-export-with-toc nil)
  (setq org-export-with-tags nil)

  (dolist (x '((latex biblatex "ieee" "ieee")
               (t csl "ieee.csl" "ieee.csl")))
    (add-to-list 'org-cite-export-processors x))

  (add-to-list 'org-link-frame-setup '(file . find-file))
  (setq org-refile-targets '((org-agenda-files . (:maxlevel . 2))))
  (setq org-clock-out-remove-zero-time-clocks t)
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-startup-indented t)
  (setq org-log-done 'time)
  (setq org-catch-invisible-edits 'smart)
  (setq org-attach-store-link-p 'attached)
  (setq org-attach-dir-relative t)
  (setq org-goto-interface 'outline-path-completion)
  (setq org-file-apps '(("\\.pdf\\'" . "xdg-open %s")
                        ("\\.doc\\'" . "xdg-open %s")))
  (setq org-tag-persistent-alist
        '(("research" . ?i)
          ("study" . ?s)
          ("teaching" . ?t)
          ("hobby" . ?h)
          ("programming" . ?p)
          ("writing" . ?w)
          ("reading" . ?r)
          ("meeting" . ?m)
          ("errand" . ?e)))
  (setq org-fast-tag-selection-single-key 'expert)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((shell . t)
     (haskell . t)
     (C . t)
     (python . t)
     (bibtex . nil)))
  (setq org-confirm-babel-evaluate nil)
  (setq org-babel-C++-compiler "g++ -O3 -std=c++20")
  (setq org-cite-csl-styles-dir "~/Repos/csl-styles")
  (dolist (module '(org-id org-attach oc-biblatex oc-csl ox-reveal))
    (add-to-list 'org-modules module))

  (defun my-agenda ()
    (interactive)
    (org-agenda nil "n"))

  (require 'ox-latex)
  (add-to-list 'org-latex-classes
               '("IEEEtran" "\\documentclass[conference,compsoc]{IEEEtran}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("ctexart" "\\documentclass{ctexart}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")))

  (require 'org-capture)
  (defun org-template-arg (name)
    (when name
      `(file ,(expand-file-name name org-template-directory))))
  (dolist (template (mapcar
                     (lambda (config)
                       `(,(plist-get config 'key)
                         ,(plist-get config 'description)
                         entry
                         (file ,(expand-file-name (plist-get config 'file)
                                                  org-notes-directory))
                         ,(org-template-arg (plist-get config 'template))
                         :empty-lines 1))
                     '(( key "t"
                         description "Task"
                         file "tasks.org"
                         template "task")
                       ( key "f"
                         description "Fleeting note"
                         file "notes.org"
                         template "note"))))
    (add-to-list 'org-capture-templates template))

  :bind
  ("C-c l" . org-store-link)
  ("C-c a" . my-agenda)
  ("C-c p" . org-capture))

(use-package citeproc
  :ensure t)

(use-package ox-reveal
  :ensure t
  :after org
  :config
  (setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js"))

(use-package org-roam
  :ensure t
  :config
  (setq org-roam-directory (expand-file-name "roam" org-directory))
  (setq org-roam-node-display-template
        (concat "${title:60*} "
                (propertize "${tags}" 'face 'org-tag)))
  (setq org-roam-db-node-include-function
        (lambda ()
          (not (member "ATTACH" (org-get-tags)))))
  (setq org-roam-capture-templates
        (mapcar
         (lambda (config)
           `(,(plist-get config 'key)
             ,(plist-get config 'description)
             plain
             ,(org-template-arg (plist-get config 'template))
             :target
             (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                        ,(format
                          (concat "#+title: ${title}\n"
                                  "#+filetags: :%s:\n")
                          (mapconcat 'identity
                                     (plist-get config 'tags)
                                     ":")))
             :unnarrowed t
             :empty-lines 1))
         `(( key "l"
             description "Literature note"
             template "literature"
             tags ("literature"))
           ( key "c"
             description "Permanent note"
             template nil
             tags ("permanent"))
           ( key "e"
             description "Entry point"
             template nil
             tags ("entry"))
           ( key "v"
             description "CIV4 game"
             template "civ"
             tags ("game")))))

  (org-roam-db-autosync-mode)
  :bind
  ("C-c r i" . org-roam-node-insert)
  ("C-c r f" . org-roam-node-find)
  ("C-c r p" . org-roam-capture)
  ("C-c r b" . org-roam-buffer-toggle))

(use-package org-roam-ui
  :ensure t
  :config
  (setq org-roam-ui-open-on-start nil))

(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package ffap
  :init
  (ffap-bindings))

(use-package tramp
  :config
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  (setq remote-file-name-inhibit-locks t)
  (remove-hook 'tramp-cleanup-connection-hook #'tramp-recentf-cleanup)
  (remove-hook 'tramp-cleanup-all-connections-hook #'tramp-recentf-cleanup-all))

(use-package flyspell
  :delight
  :bind
  ( :map flyspell-mode-map
    ("C-." . nil)
    ("C-M-i" . nil))
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-prog-mode))

(use-package flymake
  :bind
  ( :map flymake-mode-map
    ("M-g n" . flymake-goto-next-error)
    ("M-g p" . flymake-goto-prev-error))
  :hook
  (emacs-lisp-mode . flymake-mode))

(use-package eldoc
  :delight
  :config
  (eldoc-add-command 'c-electric-paren))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-delay 0)
  (corfu-auto-prefix 3)
  (corfu-separator ?\&)          ;; Orderless field separator
  (corfu-popupinfo-delay '(0 . 0))

  :init
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input))
      (setq-local corfu-auto nil
                  corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)

  (add-to-list 'savehist-additional-variables 'corfu-history)

  (global-corfu-mode)
  (corfu-popupinfo-mode)
  (corfu-history-mode)

  :bind
  ( :map corfu-map
    ("S-SPC" . corfu-insert-separator))

  :hook
  (eshell-mode . (lambda () (setq-local corfu-auto nil)))
  (comint-mode . (lambda () (setq-local corfu-auto nil))))

(use-package nerd-icons-corfu
  :ensure t
  :after (corfu)
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode)
  :bind
  ( :map minibuffer-local-map
    ("M-A" . marginalia-cycle)))

(use-package yasnippet
  :ensure t
  :delight yas-minor-mode
  :init
  (yas-global-mode))

(use-package hideshow
  :delight hs-minor-mode
  :hook
  (prog-mode . hs-minor-mode))

(use-package which-func
  :init
  (which-function-mode)
  :config
  (setq which-func-modes '(c-mode c++-mode)))

(use-package eglot
  :bind
  ( :map eglot-mode-map
    ("C-c s r" . eglot-rename)
    ("C-c s f" . eglot-format)
    ("C-c s a" . eglot-code-actions))
  :config
  (add-to-list 'eglot-server-programs
               '(cmake-mode . ("cmake-language-server")))

  (add-to-list 'eglot-server-programs
               '(haskell-mode
                 . ("haskell-language-server-wrapper" "--lsp"
                    :initializationOptions
                    (:haskell
                     ( :maxCompletions 50
                       :formattingProvider "fourmolu")))))
  (setq eglot-confirm-server-initiated-edits nil))

(use-package eldoc-box
  :ensure t
  :config
  (setq eldoc-box-max-pixel-width
        (lambda () (truncate (* 0.7 (frame-pixel-width)))))
  :hook
  (eglot-managed-mode . eldoc-box-hover-at-point-mode))

(use-package cc-mode
  :config
  (c-add-style "m5"
	       '((c-basic-offset . 4)
                 (indent-tabs-mode . nil)
	         (c-offsets-alist . ((substatement-open . 0)
				     (inline-open . 0)
				     (block-open . -4)
				     (case-label . 2)
				     (label . 2)
				     (statement-case-intro . 2)
				     (statement-case-open . 2)
				     (access-label . -2)
				     (innamespace . 0)))))
  (add-to-list 'safe-local-variable-values '(c-indent-style . "m5"))

  :hook
  (c-mode-common . (lambda ()
                     (setq-local fill-column 80)
                     (c-toggle-electric-state 1)
                     (c-toggle-comment-style 1)))
  (minizinc-mode . (lambda ()
                     (c-toggle-electric-state -1)))

  :bind
  ( :map c-mode-map
    ("C-c o" . ff-find-other-file)
    :map c++-mode-map
    ("C-c o" . ff-find-other-file)))

(use-package find-file
  :config
  (dolist (dir '("../include" "../inc" "../source" "../src"))
    (add-to-list 'cc-search-directories dir)))

(use-package minizinc-mode
  :ensure t
  :mode
  "\\.mzn\\'")

(use-package make-mode
  :mode
  ("makefile" . makefile-gmake-mode))

(use-package verilog-mode
  :hook
  (verilog-mode
   . (lambda ()
       (setq-default compilation-error-regexp-alist
                     (mapcar 'cdr verilog-error-regexp-emacs-alist))))
  :config
  (setq verilog-auto-newline nil)
  (setq verilog-linter "verilator --lint-only -Wall"))

(use-package haskell-mode
  :ensure t
  :bind
  ( :map haskell-mode-map
    ("C-c C" . haskell-compile)
    ("C-c L" . haskell-process-load-file)
    ("C-c H" . haskell-hoogle))
  :config
  (setq haskell-compile-command
        "ghc -O3 -dynamic -Wall -ferror-spans -fforce-recomp %s")
  (setq haskell-hoogle-command
        "hoogle -n 1024 --numbers"))

(use-package tex
  :ensure auctex
  :config
  (setq-default TeX-master nil)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-source-correlate-start-server t)
  (setq TeX-electric-math '("\\(" . "\\)"))
  (setq TeX-electric-sub-and-superscript t)
  (setq LaTeX-electric-left-right-brace t)
  (setq reftex-plug-into-AUCTeX t)
  (setq prettify-symbols-unprettify-at-point t)
  (setq-default TeX-command-extra-options "-shell-escape")

  (add-to-list 'TeX-view-program-selection '(output-pdf "xdg-open"))
  :bind
  ( :map TeX-mode-map
    ("C-c c" . (lambda ()
                 (interactive)
                 (save-buffer)
                 (TeX-command-run-all nil))))
  :hook
  (LaTeX-mode . (lambda ()
                  (turn-on-reftex)
                  (LaTeX-math-mode)
                  (prettify-symbols-mode)
                  (TeX-fold-mode)
                  (TeX-source-correlate-mode))))

(use-package vc
  :config
  (setq vc-follow-symlinks t))

(use-package magit
  :ensure t
  :config
  (put 'magit-clean 'disabled nil))

(use-package trashed
  :ensure t)

(use-package gnuplot
  :ensure t
  :mode ("\\.gpi?\\'" . gnuplot-mode)
  :interpreter ("gnuplot" . gnuplot-mode))

(use-package csv-mode
  :ensure t
  :hook
  (csv-mode . csv-align-mode)
  (csv-mode . csv-guess-set-separator))

(use-package nix-mode
  :ensure t
  :bind
  ("C-c f" . nix-flake))

(use-package envrc
  :ensure t
  :init
  (envrc-global-mode)
  :config
  (setq envrc-remote t))

(use-package org-ai
  :ensure t
  :hook
  (org-mode . org-ai-mode)
  :config
  (org-ai-install-yasnippets)
  (setq org-ai-auto-fill t)
  (setq org-ai-jump-to-end-of-block nil)
  :bind
  ( :map org-ai-mode-map
    ("C-c r" . nil)))

(use-package markdown-mode
  :ensure t
  :config
  (setq markdown-fontify-code-blocks-natively t))

(use-package cmake-mode
  :ensure t)

(use-package rust-mode
  :ensure t)

(use-package yaml-mode
  :ensure t)

(use-package mu4e
  :ensure t
  :bind
  (("C-c m" . mu4e)
   :map mu4e-main-mode-map
   ("q" . (lambda ()
            (interactive)
            (mu4e-context-switch nil "xchen")
            (bury-buffer))))

  :config
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
          (:maildir "/xchen/Inbox" :key ?x)))
  (setq mu4e-contexts
        `(,(make-mu4e-context
            :name "xchen"
            :match-func
            (lambda (msg)
              (when msg
                (string-match-p "^/xchen"
                                (mu4e-message-field msg :maildir))))
            :vars
            '((user-mail-address . "xchen@vvvu.org")
              (user-full-name . "Xiaoyue Chen")
              (mu4e-sent-folder . "/xchen/Sent")
              (mu4e-drafts-folder . "/xchen/Drafts")
              (mu4e-trash-folder . "/xchen/Trash")
              (mu4e-refile-folder . "/xchen/Archive")
              (mu4e-sent-messages-behavior . sent)
              (smtpmail-smtp-server . "mail.vvvu.org")
              (smtpmail-servers-requiring-authorization . "mail.vvvu.org")
              (smtpmail-smtp-service . 587)
              (mu4e-compose-signature . nil)))
          ,(make-mu4e-context
            :name "uu"
            :match-func
            (lambda (msg)
              (when msg
                (string-match-p "^/uu"
                                (mu4e-message-field msg :maildir))))
            :vars
            '((user-mail-address . "xiaoyue.chen@it.uu.se")
              (user-full-name . "Xiaoyue Chen")
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
  (mu4e-compose-mode . turn-on-orgtbl))

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
  ;; (mu4e-compose-mode . sign-mail)
  (dired-mode . turn-on-gnus-dired-mode)
  :config
  (defun sign-mail ()
    (let* ((ctx (mu4e-context-current))
           (name (if ctx (mu4e-context-name ctx))))
      (when name
        (cond
         ((member name '("xchen" "uu"))
          (mml-secure-sign))))))

  (setq mml-secure-openpgp-sign-with-sender t)
  (setq mm-verify-option 'known
        mm-decrypt-option 'known))

(use-package rmsbolt
  :ensure t)

(use-package pdf-tools
  :ensure t
  :init
  (pdf-loader-install))

(use-package go-mode
  :ensure t)

(use-package cuda-mode
  :ensure t)

;;; init.el ends here
