;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
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

(setq doom-theme 'modus-vivendi-tritanopia)

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

(with-eval-after-load 'doom-themes
  (doom-themes-treemacs-config))

(add-hook! reason-mode
  (add-hook 'before-save-hook #'refmt-before-save nil t))

(add-hook!
  js2-mode 'prettier-js-mode
  (add-hook 'before-save-hook #'refmt-before-save nil t))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Task and time tracking

(use-package! org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("HiGH" "MEDIUM" "LOW")))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(after! org
	(setq org-hide-leading-stars t)
	(add-hook 'org-mode-hook 'org-indent-mode)
	(setq org-agenda-skip-scheduled-if-done t
			org-priority-faces '((?A :foreground "#ff3e30")
								(?B :foreground "#ffaa00")
								(?C :foreground "#f1ff30"))
			org-bullets-bullet-list '("◄" "◉" "○" "◆" "◇")
			org-directory "~/Documents/MyOrg/"
			org-agenda-files "~/Documents/MyOrg/my_agenda.org")

	(setq org-capture-templates
      '(("t" "Tasks" entry (file+headline "~/Documents/MyOrg/my_tasks.org" "Tasks")
         "* TODO %?\n  %i\n  %a")

		 ("n" "Global Notes" entry (file+olp+datetree "~/Documents/MyOrg/my_notes.org" "Notes")
            "* %?\nEntered on %U\n  %i\n  %a")

        ("j" "Journal" entry (file+olp+datetree "~/Documents/MyOrg/my_journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
		 ))

	(setq org-todo-keywords
      '((sequence "TODO(t)" "PROJ(p)" "INPROGRESS(i)" "FEATURE(f)" "ONHOLD(o)" "BUG(b)" "|" "DONE(d)" "CANCELED(c)" "FIXED(x)")))

	(setq org-todo-keyword-faces
      '(("TODO"      :inherit (org-todo region) :foreground "#A3BE8C" :weight bold)
		("PROJ"      :inherit (org-todo region) :foreground "#00ff73" :weight bold)
		("FEATURE"      :inherit (org-todo region) :foreground "#88C0D0" :weight bold)
        ("BUG"      :inherit (org-todo region) :foreground "#e3a01b" :weight bold)
		("CHECK"     :inherit (org-todo region) :foreground "#ffffff" :weight bold)
		("DONE"     :inherit (org-todo region) :foreground "#35c932" :weight bold)
		("FIXED"     :inherit (org-todo region) :foreground "#58b056" :weight bold)
		("CANCELED"     :inherit (org-todo region) :foreground "#de3cd3" :weight bold)
		("IDEA"      :inherit (org-todo region) :foreground "#f7c052" :weight bold)
		("ONHOLD"      :inherit (org-todo region) :foreground "#d9d145" :weight bold)
		("INPROGRESS"      :inherit (org-todo region) :foreground "#5be3c5" :weight bold)))
)

(setq org-roam-directory "~/Documents/MyOrg")
(setq deft-directory "~/Documents/MyOrg"
		deft-extensions '("org" "txt")
		deft-recursive t)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Custom messages and menu

(remove-hook! '+doom-dashboard-functions
  #'doom-dashboard-widget-shortmenu
  #'doom-dashboard-widget-footer)


(defun my-weebery-is-always-greater ()
  (let* ((banner '("			"
"                    (`.         ,-,"
"                    ` `.    ,;' /"
"                     `.  ,'/ .'"
"                      `. X /.'	"
"            .-;--''--.._` ` (	"
"          .'            /   `	"
"         ,           ` '   Q '	"
"         ,         ,   `._    \ "
"      ,.|         '     `-.;_'	"
"      :  . `  ;    `  ` --,.._;"
"       ' `    ,   )   .'	"
"          `._ ,  '   /_	"
"             ; ,''-,;' ``-	"
"              ``-..__``--`	"))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'my-weebery-is-always-greater
      fancy-splash-image (file-name-concat doom-private-dir "images/logo.svg"))

(defcustom my/dashboard-footer-messages
  '("What is real? How do you define 'real'?"
    "I'm trying to free your mind, Neo. But I can only show you the door. You're the one that has to walk through it."
    "There is no spoon."
    "Remember... all I'm offering is the truth. Nothing more."
    "What if I told you... everything you know is a lie?"
    "Dodge this."
    "Free your mind."
    "The matrix cannot tell you who you are."
	"The Matrix is a system, Neo. That system is our enemy..."
	"Choice is an illusion created between those with power and those without.")
  "A list of messages, one of which dashboard chooses to display.")

(add-hook! '+doom-dashboard-functions :append
  (let* ((msg  (nth (random (length my/dashboard-footer-messages))
                    my/dashboard-footer-messages))
         (line msg))
    (insert "\n" (+doom-dashboard--center +doom-dashboard--width line) "\n"))

      (setq mode-line-format nil))

(setq-hook! '+doom-dashboard-mode-hook
   evil-normal-state-cursor (list nil))
