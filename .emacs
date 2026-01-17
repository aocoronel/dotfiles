(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

(add-to-list 'load-path "~/.emacs.d/local/")

(keymap-unset minibuffer-local-completion-map "SPC")

'(set-mark-command-repeat-pop t)

;; Isearch wraps the buffer
(setq isearch-wrap-pause 'no)

(setq x-alt-keysym 'meta)
(setq confirm-kill-emacs 'y-or-n-p)

(setq display-line-numbers-type 'relative)
(setq whitespace-line-column 100)
(set-fill-column 100)
(global-display-fill-column-indicator-mode)
(global-display-line-numbers-mode)

;; Smooth scrolling
(setq scroll-conservatively 101)
(setq hscroll-margin 10)
(setq scroll-margin 30)

;; Syntax highlighting
(setq flymake-no-changes-timeout 0.5
      flymake-start-on-save-buffer t
      flymake-start-on-flymake-mode t)

;; Spelling
(setq ispell-program-name "aspell"
      ispell-dictionary "en_US")
(add-hook 'org-mode-hook #'flyspell-mode)
(add-hook 'markdown-mode-hook #'flyspell-mode)
(setq flyspell-issue-message-flag nil)

(recentf-mode 1)

;; === Appearance ===

(require 'ansi-color)
(defun rc/colorize-compilation-buffer ()
  "Colorize the compilation buffer using ansi-color"
  (read-only-mode 'toggle)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (read-only-mode 'toggle))
(add-hook 'compilation-filter-hook 'rc/colorize-compilation-buffer)

(setq-default inhibit-splash-screen t
              compilation-scroll-output t
              indent-tabs-mode nil
              make-backup-files nil
              tab-width 8
              visible-bell nil)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

(add-to-list 'default-frame-alist `(font . ,"JetBrainsMonoNL Nerd Font-12"))

;; The theme is available at https://codeberg.org/aocoronel/elegantvagrant
(when
  (file-readable-p "~/.emacs.d/elegantvagrant-theme.el") (load "~/.emacs.d/elegantvagrant-theme.el")
  (add-to-list 'custom-theme-load-path "~/.emacs.d/elegantvagrant-theme.el")
  (load-theme 'elegantvagrant t))

;; === Custom Functions ===

(defun backward-mark-word (arg)
   "Similar to M-d, but backwards"
   (interactive "p")
   (unless (eq last-command this-command)
    (set-mark (point)))
   (backward-word arg)
   (setq deactivate-mark nil))

(winner-mode 1)
(defun toggle-max-window ()
  "Maximize window"
  (interactive)
  (if (> (count-windows) 1)
      (progn (window-configuration-to-register :max)
             (delete-other-windows))
    (jump-to-register :max)))

(require 'compile)
compilation-error-regexp-alist-alist
(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-use-notify t)

;; Word wrapping for markdown & org-mode
(defun rc/enable-word-wrap ()
  (interactive)
  (toggle-word-wrap 1))
(add-hook 'markdown-mode-hook 'rc/enable-word-wrap)
(add-hook 'org-mode-hook 'rc/enable-word-wrap)

;; http://stackoverflow.com/questions/13794433/how-to-disable-autosave-for-tramp-buffers-in-emacs
(setq tramp-auto-save-directory "/tmp")

(defun rc/turn-on-eldoc-mode ()
  (interactive)
  (eldoc-mode 1))
(add-hook 'elisp-mode-hook 'rc/turn-on-eldoc-mode)

;; Delete trailing whitespaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; http://stackoverflow.com/questions/2416655/file-path-to-clipboard-in-emacs
(defun rc/put-file-name-on-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
      default-directory
    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message filename))))

(defun rc/put-buffer-name-on-clipboard ()
  "Put the current buffer name on the clipboard"
  (interactive)
  (kill-new (buffer-name))
  (message (buffer-name)))

(defun rc/kill-buffers-matching (pattern)
  "Kill all buffers whose names match the given regexp PATTERN."
  (interactive "sBuffers to kill (regexp): ")
  (dolist (buffer (buffer-list))
    (let ((name (buffer-name buffer)))
      (when (and name (string-match-p pattern name))
        (kill-buffer buffer)
        (message "Killed buffer %s" name))))
  (message "Killed buffers matching %s" pattern))

;; http://ergoemacs.org/emacs/emacs_unfill-paragraph.html
(defun rc/unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000))
    (fill-paragraph nil)))

(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "%Y%m%d-%H%M%S" nil t)))

(defun rc/rgrep-selected (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-min))))
  (rgrep (buffer-substring-no-properties beg end) "*" (pwd)))

;; === Org Mode ===

(setq org-export-backends '(md))
(setq org-agenda-files (list "~/org/"))
(setq org-directory "~/org/"
      org-default-notes-file (expand-file-name "notes.org" org-directory)
      org-ellipsis " ▾" ;; Folding symbol
      org-log-done nil
      org-startup-folded 'content
      org-hide-emphasis-markers t
      org-table-convert-region-max-lines 20000
      org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d!)")))

(setq org-startup-with-inline-images t
      org-image-actual-width nil)

(setq org-agenda-prefix-format '((agenda . "  %-12:i%?-12t% s")
                                (todo . " %i ")
                                (tags . " %i ")
                                (search . " %i ")))

(setq org-capture-templates
      '(("p" "Capture task" entry
         (file "~/org/todo.org")
         "* TODO %?\n")))

(setq org-fancy-priorities-list '("[A]" "[B]" "[C]")
      org-priority-faces '((?A . (:foreground "#fc2020" :weight bold))
                           (?B . (:foreground "#fcae5f" :weight bold))
                           (?C . (:foreground "#f9fc5f" :weight bold)))
      org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("p" "Personal"
         ((agenda ""
                  ((org-agenda-tag-filter-preset '("+personal"))))))
        ("w" "Work"
         ((agenda ""
                  ((org-agenda-tag-filter-preset '("+work"))))))
        ("u" "Unscheduled"
         tags-todo "-SCHEDULED={.+}-DEADLINE={.+}"
         ((org-agenda-sorting-strategy '(priority-down))))))

;; === Packages ===

(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; Tsoding's rc/require (https://github.com/rexim/dotfiles/)
(defvar rc/package-contents-refreshed nil)

(defun rc/package-refresh-contents-once ()
  (when (not rc/package-contents-refreshed)
    (setq rc/package-contents-refreshed t)
    (package-refresh-contents)))

(defun rc/require-one-package (package)
  (when (not (package-installed-p package))
    (rc/package-refresh-contents-once)
    (package-install package)))

(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))

(rc/require 'dash)

;; === IDO ===

(rc/require 'smex 'ido-completing-read+)
(require 'ido-completing-read+)

(setq ido-enable-flex-matching t)
(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

;; === God Mode ===

(rc/require'god-mode)
(god-mode)
(global-set-key (kbd "<escape>") #'god-local-mode)
(require 'god-mode-isearch)

;; === Programming Major Modes ===

;; c-mode
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode))
(add-hook 'simpc-mode-hook
          (lambda ()
            (interactive)
            (setq-local fill-paragraph-function 'astyle-buffer)))

;; elisp-mode

(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-j")
                            (quote eval-print-last-sexp))))

(rc/require 'markdown-mode)
(rc/require 'zig-mode)

;; === Formatter ===

(rc/require 'format-all)
(setq format-all-show-errors 'warnings)
(add-hook 'prog-mode-hook #'format-all-mode)

;; === Magit ===

(cond
  ((eq system-type 'windows-nt) (rc/require 'cl-lib)))

(rc/require 'magit)

(setq magit-auto-revert-mode nil)

(rc/require 'magit-todos)
(magit-todos-mode 1)
(setq magit-todos-keywords
      '("TODO" "FIXME" "BUG" "HACK" "NOTE"))

;; === Multiple Cursors ===

(rc/require 'multiple-cursors)

;; === Dired ===

(rc/require 'dired-preview)
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq dired-mouse-drag-files t)
;; https://stackoverflow.com/questions/23207938/in-emacs-how-to-enable-automatic-hiding-of-dired-details
(add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1)))

;; === Yasnippet ===

(rc/require 'yasnippet)
(setq yas/triggers-in-field nil)
(setq yas-snippet-dirs '("~/.emacs.d/snippets/"))
(yas-global-mode 1)

;; === Move Text ===

(rc/require 'move-text)

;; === LSP ===

(rc/require 'eglot)
(setq eglot-autoshutdown t
      eglot-send-changes-idle-time 0.5
      eglot-sync-connect nil)
(setq eglot-events-buffer-size 0)
(setq jsonrpc-default-request-timeout 5)
(setq eglot-report-progress nil)

(add-hook 'zig-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(markdown-mode . ("harper-ls" "--stdio"))))

(setq eglot-ignored-server-capabilities
         '(:hoverProvider
;;         :completionProvider
;;         :signatureHelpProvider
;;         :definitionProvider
;;         :typeDefinitionProvider
;;         :implementationProvider
;;         :declarationProvider
;;         :referencesProvider
         :documentHighlightProvider
;;         :documentSymbolProvider
;;         :workspaceSymbolProvider
         :codeActionProvider
         :codeLensProvider
;;         :documentFormattingProvider
         :documentRangeFormattingProvider
         :documentOnTypeFormattingProvider
         :renameProvider
         :documentLinkProvider
;;         :colorProvider
         :foldingRangeProvider
         :executeCommandProvider
         :inlayHintProvider))

;; === Projectile ===

(rc/require 'rg)
(rc/require 'projectile)

;; === Company ===

(rc/require 'company)

(setq company-idle-delay 0.1
      company-minimum-prefix-length 1
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      company-auto-complete nil
      company-tooltip-margin 1)

(global-company-mode)


;; === Orderless ===

(rc/require 'orderless)
(setq orderless-matching-styles '(orderless-literal orderless-flex))
(setq orderless-component-separator "[ &]")

;; Completion

(setq completion-styles '(basic orderless)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

(setq completion-at-point-functions
      '( elisp-completion-at-point
        ; eglot-completion-at-point
        company-completion-at-point))

;; === Zoxide ===

(rc/require 'zoxide)
(setq zoxide-use-cache t)
(setq zoxide-completion-function #'completing-read)

(defun my/zoxide-find-file ()
  "Jump to a zoxide directory and open dired."
  (interactive)
  (dired (zoxide-find-file)))

(defun my/zoxide-cd ()
  "Jump to a zoxide directory."
  (interactive)
  (cd (zoxide-find-file)))

;; === Rainbow ===

;; Allows to see the colors from a hex #FFFFFF
(rc/require 'rainbow-mode)
(add-hook 'css-mode-hook #'rainbow-mode)
(add-hook 'markdown-mode-hook #'rainbow-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-mode)

;; === Avy ===

;; Jump to anything in the buffer
(rc/require 'avy)

;; === Keybindings ===

(global-set-key (kbd "C-c M-q") 'rc/unfill-paragraph)
(global-set-key (kbd "C-,") 'rc/duplicate-line)
(global-set-key (kbd "C-x p d") 'rc/insert-timestamp)
(global-set-key (kbd "C-x p s") 'rc/rgrep-selected)

;; Window Flow
(windmove-default-keybindings)
(global-set-key (kbd "H-m") 'toggle-max-window)
(global-set-key (kbd "H-h") 'windmove-left)
(global-set-key (kbd "H-l") 'windmove-right)
(global-set-key (kbd "H-j") 'windmove-down)
(global-set-key (kbd "H-k") 'windmove-up)
(global-set-key (kbd "H-q a") 'delete-other-windows)
(global-set-key (kbd "H-q m") 'delete-window)
(global-set-key (kbd "H-]") 'split-window-right)
(global-set-key (kbd "H-\\") 'split-window-below)

(global-set-key (kbd "C-x C-g") 'find-file-at-point)
(global-set-key (kbd "C-c i m") 'imenu)
(global-set-key (kbd "H-f") 'find-file-at-point)

(global-set-key (kbd "C-x a") 'org-agenda)
(global-set-key (kbd "C-c C-x j") #'org-clock-jump-to-current-clock)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(global-set-key (kbd "H-z f") #'zoxide-find-file)
(global-set-key (kbd "H-z c") #'my/zoxide-cd)

(global-set-key (kbd "C-c M-q") 'rc/unfill-paragraph)

(global-set-key (kbd "C-:") 'avy-goto-word-0)

(global-set-key (kbd "S-M-<backspace>") 'backward-mark-word)

(define-key isearch-mode-map (kbd "<escape>") #'god-mode-isearch-activate)
(define-key god-mode-isearch-map (kbd "<escape>") #'god-mode-isearch-disable)

(define-key dired-mode-map (kbd "b") #'dired-up-directory)

(keymap-global-unset "C-x f") ;; unmaps set-fill-column

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load-file custom-file))
;; EOF
