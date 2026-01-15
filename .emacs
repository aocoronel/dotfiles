;; === Custom File ===
(unless (file-exists-p "~/.emacs.d/custom.el")
  (make-directory (file-name-directory "~/.emacs.d/custom.el") t)
  (with-temp-buffer (write-file "~/.emacs.d/custom.el")))

(setq custom-file "~/.emacs.d/custom.el")

;; === Setup Package Manager ===
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/local/")

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

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
(require 'dash)

(require 'ansi-color)

(global-set-key (kbd "C-x C-g") 'find-file-at-point)
(global-set-key (kbd "C-c i m") 'imenu)

(setq-default inhibit-splash-screen t
              make-backup-files nil
              tab-width 4
              indent-tabs-mode nil
              compilation-scroll-output t
              default-input-method "russian-computer"
              visible-bell (equal system-type 'windows-nt))

(defun rc/colorize-compilation-buffer ()
  (read-only-mode 'toggle)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (read-only-mode 'toggle))
(add-hook 'compilation-filter-hook 'rc/colorize-compilation-buffer)

(defun rc/buffer-file-name ()
  (if (equal major-mode 'dired-mode)
      default-directory
    (buffer-file-name)))

;;; Taken from here:
;;; http://stackoverflow.com/questions/2416655/file-path-to-clipboard-in-emacs
(defun rc/put-file-name-on-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (rc/buffer-file-name)))
    (when filename
      (kill-new filename)
      (message filename))))

(defun rc/put-buffer-name-on-clipboard ()
  "Put the current buffer name on the clipboard"
  (interactive)
  (kill-new (buffer-name))
  (message (buffer-name)))

(defun rc/kill-autoloads-buffers ()
  (interactive)
  (dolist (buffer (buffer-list))
    (let ((name (buffer-name buffer)))
      (when (string-match-p "-autoloads.el" name)
        (kill-buffer buffer)
        (message "Killed autoloads buffer %s" name)))))

;;; Stolen from http://ergoemacs.org/emacs/emacs_unfill-paragraph.html
(defun rc/unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000)) ; 90002000 is just random. you can use `most-positive-fixnum'
    (fill-paragraph nil)))

(global-set-key (kbd "C-c M-q") 'rc/unfill-paragraph)
(global-set-key (kbd "H-f") 'find-file-at-point)

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

(global-set-key (kbd "C-,") 'rc/duplicate-line)

(defun rc/insert-timestamp ()
  (interactive)
  (insert (format-time-string "(%Y%m%d-%H%M%S)" nil t)))

(global-set-key (kbd "C-x p d") 'rc/insert-timestamp)

(defun rc/rgrep-selected (beg end)
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list (point-min) (point-min))))
  (rgrep (buffer-substring-no-properties beg end) "*" (pwd)))

(global-set-key (kbd "C-x p s") 'rc/rgrep-selected)

(setq x-alt-keysym 'meta)

(setq confirm-kill-emacs 'y-or-n-p)

(windmove-default-keybindings)

(setq org-directory "~/org/"
      org-default-notes-file (expand-file-name "notes.org" org-directory)
      org-ellipsis " ▼ "
      org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
      org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦))
      org-log-done 'time
      org-hide-emphasis-markers t
      org-link-abbrev-alist
      '(("google" . "http://www.google.com/search?q=")
        ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
        ("ddg" . "https://duckduckgo.com/?q=")
        ("wiki" . "https://en.wikipedia.org/wiki/"))
      org-table-convert-region-max-lines 20000
      org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d!)")))

;; Fix missing quote and parenthesis
(setq org-agenda-prefix-format '((agenda . "  %-12:i%?-12t% s")
                                (todo . " %i ")
                                (tags . " %i ")
                                (search . " %i ")))

(global-set-key (kbd "C-x a") 'org-agenda)
(global-set-key (kbd "C-c C-x j") #'org-clock-jump-to-current-clock)

(setq org-agenda-files (list "~/org/"))

(setq org-export-backends '(md))

;; Fix org-capture-templates
(setq org-capture-templates
      '(("p" "Capture task" entry
         (file "~/org/todo.org")
         "* TODO %?\n")))

;; Fix incomplete setq
(setq org-fancy-priorities-list '("[A]" "[B]" "[C]")
      org-priority-faces '((?A . (:foreground "#fc2020" :weight bold))
                           (?B . (:foreground "#fcae5f" :weight bold))
                           (?C . (:foreground "#f9fc5f" :weight bold)))
      org-agenda-block-separator 8411)

;; Fix org-agenda-custom-commands syntax
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

(setq org-startup-with-inline-images t
      org-image-actual-width nil)

(add-to-list 'default-frame-alist `(font . ,"JetBrainsMonoNL Nerd Font-12"))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

(when
  (file-readable-p "~/.emacs.d/elegantvagrant-theme.el") (load "~/.emacs.d/elegantvagrant-theme.el")
  (add-to-list 'custom-theme-load-path "~/.emacs.d/elegantvagrant-theme.el")
  (load-theme 'elegantvagrant t)
)

;;; ido
(rc/require 'smex 'ido-completing-read+)

(require 'ido-completing-read+)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; c-mode
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

;;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-j")
                            (quote eval-print-last-sexp))))

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode))

;;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode 'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'go-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'yaml-mode-hook 'rc/set-up-whitespace-handling)

;;; display-line-numbers-mode
(global-display-fill-column-indicator-mode)
(global-display-line-numbers-mode)
(setq whitespace-line-column 100)
(set-fill-column 100)

;;; magit
;; magit requres this lib, but it is not installed automatically on
;; Windows.
(rc/require 'cl-lib)
(rc/require 'magit)

(setq magit-auto-revert-mode nil)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;;; multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;;; dired
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq dired-mouse-drag-files t)

;;; yasnippet
(rc/require 'yasnippet)

(require 'yasnippet)

(setq yas/triggers-in-field nil)
(setq yas-snippet-dirs '("~/.emacs.d/snippets/"))

(yas-global-mode 1)

;;; word-wrap
(defun rc/enable-word-wrap ()
  (interactive)
  (toggle-word-wrap 1))

(add-hook 'markdown-mode-hook 'rc/enable-word-wrap)

;;; tramp
;;; http://stackoverflow.com/questions/13794433/how-to-disable-autosave-for-tramp-buffers-in-emacs
(setq tramp-auto-save-directory "/tmp")

;;; eldoc mode
(defun rc/turn-on-eldoc-mode ()
  (interactive)
  (eldoc-mode 1))

(add-hook 'emacs-lisp-mode-hook 'rc/turn-on-eldoc-mode)

;;; Company
; (rc/require 'company)
; (require 'company)
; (global-company-mode)

;;; Proof general
(rc/require 'proof-general)
(add-hook 'coq-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-q C-n")
                            (quote proof-assert-until-point-interactive))))

;;; Move Text
(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(add-hook 'simpc-mode-hook
          (lambda ()
            (interactive)
            (setq-local fill-paragraph-function 'astyle-buffer)))

(require 'compile)

compilation-error-regexp-alist-alist

(rc/require 'markdown-mode)
(rc/require 'zig-mode)

(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-use-notify t)

(rc/require 'eglot)

(setq eglot-autoshutdown t
      eglot-send-changes-idle-time 0.5
      eglot-sync-connect nil)

;; corfu
(rc/require 'corfu)
(rc/require 'orderless)

(setq corfu-auto t
      corfu-auto-delay 0.1
      corfu-auto-prefix 1
      corfu-cycle t
      corfu-preselect 'prompt
      corfu-quit-no-match t)

(global-corfu-mode)

(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles basic partial-completion))))

(setq completion-at-point-functions
      '(eglot-completion-at-point
        elisp-completion-at-point))

(setq eglot-events-buffer-size 0)
(setq jsonrpc-default-request-timeout 5)
(setq eglot-report-progress nil)

(add-hook 'zig-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(markdown-mode . ("harper-ls" "--stdio"))
               '(simpc-mode . ("clangd"))))

(setq flymake-no-changes-timeout 0.5
      flymake-start-on-save-buffer t
      flymake-start-on-flymake-mode t)

(setq scroll-conservatively 101)
(setq hscroll-margin 10)
(setq scroll-margin 30)

(setq ispell-program-name "aspell"
      ispell-dictionary "en_US")

(setq flyspell-issue-message-flag nil)

(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'markdown-mode-hook #'flyspell-mode)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)

(rc/require 'format-all)

(setq format-all-show-errors 'warnings)

(add-hook 'c-mode-hook #'format-all-mode)
(add-hook 'zig-mode-hook #'format-all-mode)

(rc/require 'magit-todos)
(magit-todos-mode 1)
(setq magit-todos-keywords
      '("TODO" "FIXME" "BUG" "HACK" "NOTE"))

(rc/require 'zoxide)

(setq zoxide-use-cache t)

(setq zoxide-completion-function #'completing-read)

(defun my/zoxide-find-file ()
  "Jump to a zoxide directory and open dired."
  (interactive)
  (dired (zoxide-find-file)))

(global-set-key (kbd "H-z f") #'zoxide-find-file)

(defun my/zoxide-cd ()
  "Jump to a zoxide directory."
  (interactive)
  (cd (zoxide-find-file)))

(global-set-key (kbd "H-z c") #'my/zoxide-cd)

(rc/require 'rainbow-mode)

(add-hook 'css-mode-hook #'rainbow-mode)
(add-hook 'markdown-mode-hook #'rainbow-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-mode)

(rc/require 'avy)
(global-set-key (kbd "C-:") 'avy-goto-word-0)

(setq isearch-wrap-pause 'no)

(winner-mode 1)
(defun toggle-max-window ()
  (interactive)
  (if (> (count-windows) 1)
      (progn (window-configuration-to-register :max)
             (delete-other-windows))
    (jump-to-register :max))
)

(keymap-unset minibuffer-local-completion-map "SPC")

(defun backward-mark-word (arg)
   (interactive "p")
   (unless (eq last-command this-command)
    (set-mark (point)))
   (backward-word arg)
   (setq deactivate-mark nil))

(global-set-key (kbd "S-M-<backspace>") 'backward-mark-word)

'(vc-follow-symlinks nil)
'(set-mark-command-repeat-pop t)

;;; Stolen from http://ergoemacs.org/emacs/emacs_unfill-paragraph.html
(defun rc/unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000)) ; 90002000 is just random. you can use `most-positive-fixnum'
    (fill-paragraph nil)))

(global-set-key (kbd "C-c M-q") 'rc/unfill-paragraph)

;; Window Flow
(global-set-key (kbd "H-m") 'toggle-max-window)
(global-set-key (kbd "H-h") 'windmove-left)
(global-set-key (kbd "H-l") 'windmove-right)
(global-set-key (kbd "H-j") 'windmove-down)
(global-set-key (kbd "H-k") 'windmove-up)
(global-set-key (kbd "H-q a") 'delete-other-windows)
(global-set-key (kbd "H-q m") 'delete-window)
(global-set-key (kbd "H-]") 'split-window-right)
(global-set-key (kbd "H-\\") 'split-window-below)
(load-file custom-file)
