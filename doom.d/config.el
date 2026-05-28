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
			org-directory "~/Documents/MyOrg/"
			org-agenda-files "~/Documents/MyOrg/my_agenda.org")

	(setq org-capture-templates
      '(("t" "Tasks" entry (file+headline "~/Documents/MyOrg/my_tasks.org" "Tasks")
         "* Tasks\n ** PROJ WriteHere\n *** TODO %?\n  %i\n  %a")

		 ("m" "Meetings" entry (file+headline "~/Documents/MyOrg/my_meetings.org" "Meetings")
         "* MEETINGS\n\n ** MEETING Write Here The Metting Context\n %?\n  %i\n  %a")

		 ("n" "Global Notes" entry (file+olp+datetree "~/Documents/MyOrg/my_notes.org" "Notes")
            "* %?\nEntered on %U\n  %i\n  %a")

        ("j" "Journal" entry (file+olp+datetree "~/Documents/MyOrg/my_journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
		 ))

	(setq org-todo-keywords
      '((sequence "TODO(t)" "MEETING(m)" "PROJ(p)" "IDEA(a)" "CHECK(h)" "INPROGRESS(i)" "FEATURE(f)" "ONHOLD(o)" "BUG(b)" "|" "DONE(d)" "CANCELED(c)" "FIXED(x)")))

	(setq org-todo-keyword-faces
      '(("TODO"      :inherit (org-todo region) :foreground "#A3BE8C" :weight bold)
		("MEETING"      :inherit (org-todo region) :foreground "#fbff00" :weight bold)
		("PROJ"      :inherit (org-todo region) :foreground "#00ff73" :weight bold)
		("FEATURE"      :inherit (org-todo region) :foreground "#88C0D0" :weight bold)
                ("BUG"      :inherit (org-todo region) :foreground "#e3a01b" :weight bold)
		("CHECK"     :inherit (org-todo region) :foreground "#ffffff" :weight bold)
		("DONE"     :inherit (org-todo region) :foreground "#35c932" :weight bold)
		("FIXED"     :inherit (org-todo region) :foreground "#58b056" :weight bold)
		("CANCELED"     :inherit (org-todo region) :foreground "#de3cd3" :weight bold)
		("IDEA"      :inherit (org-todo region) :foreground "#f7c052" :weight bold)
		("ONHOLD"      :inherit (org-todo region) :foreground "#d9d145" :weight bold)
		("INPROGRESS"      :inherit (org-todo region) :foreground "#5be3c5" :weight bold))))

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
   
(use-package docker
  :ensure t
  :bind ("C-c d" . docker))
  
  
;; Restclient package for Org Mode!
(require 'restclient)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((restclient . t)))
 
 
 ;; Dirvish Configuration (Like MC)
 
 (use-package! dirvish
  :init
  (dirvish-override-dired-mode)

  :config
  ;; Nice defaults
  (setq dirvish-attributes
        '(vc-state subtree-state all-the-icons
          file-time file-size collapse))

  ;; Open dirs in same buffer
  (setq dired-kill-when-opening-new-dired-buffer t)

  ;; Copy/move between split panes like MC
  (setq dired-dwim-target t)

  ;; Reuse buffers
  (setq dirvish-reuse-session t)
  
  ;; Use V-Split
  (setq split-width-threshold 0)

  ;; Quick access bookmarks
  (setq dirvish-quick-access-entries
        '(("d" "~/Downloads/"               "Downloads")
          ("p" "~/Documents/MyWork/MyProjects"                "My Projects")
	  ("h" "~/"               "Home")))

  ;; Evil-style navigation
  (map! :map dirvish-mode-map
        :n "h" #'dired-up-directory
        :n "l" #'dired-find-file
        :n "TAB" #'dirvish-subtree-toggle
        :n "q" #'quit-window))


;; copy/move between panes automatically

(after! dired
  (setq dired-dwim-target t))
  
;; 2 pane Dirvish

(defun dirvish-mc-pane ()
  (interactive)
  (delete-other-windows)
  (let ((left (read-directory-name "Left: "))
        (right (read-directory-name "Right: ")))
    (dired left)
    (split-window-right)
    (other-window 1)
    (dired right)))
	
;; Open Dirvish with leader key
(map! :leader
      :desc "Dirvish"
      "o d" #'dirvish-mc-pane)
	  

(after! dirvish
  ;; disable preview system completely
  (setq dirvish-use-preview nil
        dirvish-preview-dispatchers nil)
		
  (setq dirvish-attributes nil) ;; optional cleanup
  
  (setq split-width-threshold 0
        split-height-threshold nil)
  (map! :map dirvish-mode-map
        :n "a" #'dirvish-quick-access)
		;; Disable all previews
		(setq dirvish-preview-dispatchers nil))


;; Elfeed
(use-package elfeed
  :ensure t
  :config
  (setq elfeed-search-filter "@2-week-ago +unread")
  (setf url-queue-timeout 20)
  (setq elfeed-curl-max-connections 5)
  :bind (:map elfeed-search-mode-map
			  ("R" . elfeed-update)
			  ("Q" . elfeed-kill-buffer)))
			  
(keymap-global-set "C-x w" #'elfeed)

(require 'elfeed)
(require 'elfeed-goodies)
(elfeed-goodies/setup)

;; Load elfeed-org
(require 'elfeed-org)

;; Initialize elfeed-org
;; This hooks up elfeed-org to read the configuration when elfeed
;; is started with =M-x elfeed=
(elfeed-org)

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

;; Configure Elfeed with org mode

(use-package elfeed-org
  :ensure t
  :after elfeed
  :config
  (setq rmh-elfeed-org-files '("~/Documents/MyOrg/elfeed.org")))

;; (with-eval-after-load 'elfeed (elfeed-org))

;; Emmet Mode Configuration

(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(setq emmet-move-cursor-between-quotes t) ;; default nil

(map! :leader
      :desc "Emmet Expand"
      "e" #'emmet-expand-line)
	  
	  
;;; ------------------------------------------------------
;;; ORG SUPER AGENDA
;;; ------------------------------------------------------

(use-package! org-super-agenda
  :after org-agenda
  :config
  (org-super-agenda-mode))

(after! org-agenda
  ;; Cleaner agenda
  (setq org-agenda-start-with-log-mode nil
        org-agenda-span 1
        org-agenda-start-on-weekday nil
        org-agenda-window-setup 'current-window
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-start-day nil
		org-agenda-sticky t
		org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t% s")
        (todo   . " %i %-12:c")
        (tags   . " %i %-12:c")
        (search . " %i %-12:c")))
	
	;; Time grid
	(setq org-agenda-use-time-grid t
      org-agenda-show-all-dates t
      org-agenda-time-grid
      '((daily today require-timed)
        (800 1000 1200 1400 1600 1800 2000)
        " ┄┄┄┄┄ "
        ""))
		
   ;; Vertical line to seperate the sections for better reading
   (setq org-super-agenda-separator
      (propertize
       "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
       'face
       'shadow))
	   
  ;; Org itself adds another separator and it can look cluttered alongside
  (setq org-agenda-block-separator nil)

  ;; MAIN DASHBOARD
  (setq org-agenda-custom-commands
        '(("d" "Developer Dashboard"
           (;; DAILY AGENDA
            (agenda ""
                    ((org-agenda-span 1)
                     (org-super-agenda-groups

                      '((:name "🔥 Today"
                         :time-grid t
                         :date today
                         :scheduled today
                         :order 1)

                        (:name "⚠️ Overdue"
                         :deadline past
                         :order 3)

                        (:name "📅 Due Soon"
                         :deadline future
                         :order 4)

                        (:name "⏳ Upcoming"
                         :deadline future
						 :time-grid t
                         :order 5)
			 ))))
			 
			 ;; -------------------------------------------------
			;; 🤝 MEETINGS (UPCOMING + PAST)
			;; -------------------------------------------------

			(alltodo ""
				((org-agenda-overriding-header "\n\n🤝 MEETINGS QUEUE\n")

				(org-super-agenda-groups
					'((:name "🕐 Today Meetings"
						:time-grid t
						:and (:todo "MEETING"
						:scheduled today)
						:order 1)
			   
					  (:name "📅 Upcoming Meetings"
						:and (:todo "MEETING"
						:scheduled future)
						:order 2)

					  (:name "🗂 Last Meetings"
						:and (:todo "MEETING"
							:scheduled past)
						:order 3)
					(:discard (:anything t))))))

            ;; TASK VIEW
            (alltodo ""
                     ((org-agenda-overriding-header "\n\n⚙️ WORK QUEUE\n")

                      (org-super-agenda-groups

                       '((:name "⚡ High Priority"
							:priority<= "A"
							:order 1)
					   
					   (:name "🔥 In Progress"
                          :todo "INPROGRESS"
                          :order 2)
						  
						(:name "🎯 Quick Picks"
						  :effort< "0:15"
						  :order 3)

                         (:name "🐞 Bugs"
                          :todo "BUG"
                          :order 4)

                         (:name "✨ Features"
                          :todo "FEATURE"
                          :order 5)

                         (:name "📦 Projects"
                          :todo "PROJ"
                          :order 6)

                         (:name "📋 General Tasks"
                          :todo "TODO"
                          :order 7)

                         (:name "🧪 Needs Checking"
                          :todo "CHECK"
                          :order 8)

                         (:name "⏸ On Hold"
                          :todo "ONHOLD"
                          :order 9)
						  
						(:name "💡 My Ideas"
                            :todo "IDEA"
                            :order 10)
							
						 (:name "✅ Habits"
							:habit t
							:time-grid t
							:order 11)
							
                         (:discard
                          (:todo "DONE"))
						  
						 (:discard
                          (:todo "MEETING"))

                         (:discard
                          (:todo "CANCELED"))

                         (:discard
                          (:todo "FIXED"))))))
						  
						  )))))

;;; ------------------------------------------------------
;;; OPTIONAL NICE-TO-HAVES
;;; ------------------------------------------------------

;;; Looks very good with Doom themes
(custom-set-faces!
  '(org-priority
    :foreground "#fa332f"
    :weight bold))

;; Better logging
(setq org-log-done 'time)

;; Save all org buffers automatically
(add-hook 'auto-save-hook 'org-save-all-org-buffers)


;;; ------------------------------------------------------
;;; ORG MODERN
;;; ------------------------------------------------------

(use-package! org-modern
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)

  :config
  ;; pretty tables
  (setq org-modern-table nil)

  ;; modern todo keywords
  (setq org-modern-todo t)

  ;; modern tags
  (setq org-modern-tag t)

  ;; modern priorities
  (setq org-modern-priority t)

  ;; star styling
  (setq org-modern-star 'replace)

  ;; folded ellipsis
  (setq org-ellipsis " ▾")

  ;; optional: nicer bullets
  (setq org-modern-list
        '((?- . "◄")
          (?* . "○")
          (?+ . "◇"))))
		  

		  
