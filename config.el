;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;;Emacs window manager (EXWM)
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)
(require 'exwm-randr)

(setq exwm-randr-workspace-output-plist '(0 "LVDS-1"))
(add-hook 'exwm-randr-screen-change-hook
          (lambda()
            (start-process-shell-command
             "xrandr" nil "xrandr --output LVDS-1 --mode 1024x768 --pos 0x0 --rotate normal")))
(exwm-randr-enable)
(require 'exwm-systemtray)
(exwm-systemtray-enable)


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'light-blue)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
(after! org
        (setq org-roam-directory "~/org-roam")
        (setq org-roam-index-file "~/org-roam/index.org"))

;; mapping out key bindings for org-roam
(map! :leader
      (:prefix-map ("j" . "journal")
       :desc "Capture new journal entry" "n" #'org-roam-dailies-capture-today
       :desc "Go to today's journal entry" "t" #'org-roam-dailies-find-today
       :desc "Go to yesterday's journal entry" "y" #'org-roam-dailies-find-yesterday
       :desc "Go to tomorrow's journal entry" "o" #'org-roam-dailies-find-tomorrow
       :desc "Find date" "f" #'org-roam-dailies-find-date))


;; Enabling the ability to render images on startup.
(setq org-startup-with-inline-images t)

(defvar current-time-format "%H:%M"
  "Format of date to insert with `insert-current-time' func.
Note the weekly scope of the command's precision.")

(defun insert-current-time ()
  "insert the current time (1-week scope) into the current buffer."
       (interactive)
       (insert (format-time-string current-time-format (current-time)))
       )


;; Fix the org-roam buffer not rendering links
(defun my/preview-fetcher ()
  (let* ((elem (org-element-context))
         (parent (org-element-property :parent elem)))
    ;; TODO: alt handling for non-paragraph elements
    (string-trim-right (buffer-substring-no-properties
                        (org-element-property :begin parent)
                        (org-element-property :end parent)))))

(setq org-roam-preview-function #'my/preview-fetcher)


;; Something required for setting up email
(setq sendmail-program "/usr/bin/msmtp"
      send-mail-function #'smtpmail-send-it
      message-sendmail-f-is-evil t
      message-sendmail-extra-arguments '("--read-envelope-from")
      message-send-mail-function #'message-send-mail-with-sendmail)

;; Fix link display in org-roam backlinks buffer.
(setq org-fold-core-style "overlays")

(setq org-alert-interval 300
      org-alert-notify-cutoff 10
      org-alert-notify-after-event-cutoff 10)

;;Change the TODO sequence.
(setq org-todo-keywords
    (quote ((sequence "TODO(t)" "EVENT(e)" "|" "DONE(d)")
            (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))

(setq-default org-enforce-todo-dependencies t)



(setq org-todo-keyword-faces
    (quote (("TODO" :foreground "red" :weight bold)
            ("EVENT" :foreground "blue" :weight bold)
            ("DONE" :foreground "forest green" :weight bold)
            ("WAITING" :foreground "orange" :weight bold)
            ("HOLD" :foreground "magenta" :weight bold)
            ("CANCELLED" :foreground "forest green" :weight bold)
            ("MEETING" :foreground "forest green" :weight bold)
            ("PHONE" :foreground "forest green" :weight bold))))
;; I don't wan't the keywords in my exports by default
(setq-default org-export-with-todo-keywords nil)
