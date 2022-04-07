;;; config.el -*- lexical-binding: t; -*-
;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "lguedes"
      user-mail-address "lguedes@student.42.rio")

;; Better Defaults
(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
      evil-want-fine-undo t                       ; By default while in insert all changes are one big blob. Be more granular
      auto-save-default t                         ; Nobody likes to loose work, I certainly don't
      truncate-string-ellipsis "…"                ; Unicode ellispis are nicer than "...", and also save /precious/ space
      password-cache-expiry nil                   ; I can trust my computers ... can't I?
      scroll-margin 7)

(display-time-mode 1)                             ; Show current time on modeline

;; (unless (string-match-p "^Power N/A" (battery))   ; On laptops... For knowing how much power left
;;   (display-battery-mode 1))

(global-subword-mode 1)                           ; Iterate Through CammelCase

;; TODO Documentate later
;; (add-to-list 'default-frame-alist '(height . 24))
;; (add-to-list 'default-frame-alist '(width . 80))

;; Prompt for which buffer to open on a window.
(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))


;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;; Setting Fonts like a chad:
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-big-font (font-spec :family "JetBrainsMono Nerd Font" :size 16)
      doom-variable-pitch-font (font-spec :family "Overpass Nerd Font" :size 14)
      doom-unicode-font (font-spec :family "JuliaMono Nerd Font")
      doom-serif-font (font-spec :family "BlexMono Nerd Font" :weight 'light))
;; Asking if they exist (please do not breake your fav editor)
(defvar required-fonts '("JetBrainsMono Nerd Font",
                         "Overpass Nerd Font",
                         "JuliaMono Nerd Font",
                         "BlexMono Nerd Font"))
;; Credits to TECOCSAUR
(defvar available-fonts
  (delete-dups (or (font-family-list)
                   (split-string (shell-command-to-string "fc-list : family")
                                 "[,\n]"))))

(defvar missing-fonts
  (delq nil (mapcar
             (lambda (font)
               (unless (delq nil (mapcar (lambda (f)
                                           (string-match-p (format "^%s$" font) f))
                                         available-fonts))
                 font))
             required-fonts)))

(if missing-fonts
    (pp-to-string
     `(unless noninteractive
        (add-hook! 'doom-init-ui-hook
          (run-at-time nil nil
                       (lambda ()
                         (message "%s missing the following fonts: %s"
                                  (propertize "Warning!" 'face '(bold warning))
                                  (mapconcat (lambda (font)
                                               (propertize font 'face 'font-lock-variable-name-face))
                                             ',missing-fonts
                                             ", "))
                         (sleep-for 0.5))))))
  ";; No missing fonts detected")


;; Setting theme + Changing the default collor on the modeline (for better)
(setq doom-theme 'doom-vibrant)
(remove-hook 'window-setup-hook #'doom-init-theme-h)
(add-hook 'after-init-hook #'doom-init-theme-h 'append)
(delq! t custom-theme-load-path)

(custom-set-faces!
  '(doom-modeline-buffer-modified :foreground "orange"))

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))
(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

;; Treemacs with actual icons.
(setq doom-themes-treemacs-theme "doom-colors")

;; Line numbers (I do not relative most of the time but I might change this later on)
;; You can toggle this on & off by doing SPC - t - l
(setq display-line-numbers-type 'nil)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Norminette better Defaults ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Better Showing of whitespaces so I don't forget them at the end of the line or in a blank line ( norminette fuck you. )
(global-whitespace-mode)
(setq whitespace-style '(face tabs tab-mark trailing))
(custom-set-faces
 '(whitespace-tab ((t (:foreground "#636363")))))
(setq whitespace-display-mappings
  '((tab-mark 9 [124 9] [92 9])))

;; Tabs for C... again fuck norminette.
(setq custom-tab-width 4)
(defun disable-tabs () (setq indent-tabs-mode nil))
(defun enable-tabs  () ; I Guess this would be a function which I should find on my M-x right?
  (local-set-key (kbd "TAB") 'tab-to-tab-stop)
  (setq indent-tabs-mode t)
  (setq tab-width custom-tab-width))
;; Hooks to Enable Tabs
(add-hook 'c-mode-hook 'enable-tabs)

;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; ORG MODE ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Setting org, org-agenda, org-roam directories
(setq org-directory "~/MyOrg")
(after! org-roam
  (setq org-roam-directory "~/MyOrg/Roam")
  (setq org-agenda-files "~/MyOrg/Agenda"))


(after! org
  (after! org-superstar
    (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✿" "✤" "✜" "◆" "▶")
          org-superstar-prettify-item-bullets t ))

  (setq org-ellipsis " ▾ "
        org-hide-leading-stars t
        org-priority-highest ?A
        org-priority-lowest ?E
        org-priority-faces
        '((?A . 'all-the-icons-red)
          (?B . 'all-the-icons-orange)
          (?C . 'all-the-icons-yellow)
          (?D . 'all-the-icons-green)
          (?E . 'all-the-icons-blue)))
        (appendq! +ligatures-extra-symbols
                `(:checkbox      "☐"
                :pending       "◼"
                :checkedbox    "☑"
                :list_property "∷"
                :em_dash       "—"
                :ellipses      "…"
                :arrow_right   "→"
                :arrow_left    "←"
                :title         "𝙏"
                :subtitle      "𝙩"
                :author        "𝘼"
                :date          "𝘿"
                :property      "☸"
                :options       "⌥"
                :startup       "⏻"
                :macro         "𝓜"
                :html_head     "🅷"
                :html          "🅗"
                :latex_class   "🄻"
                :latex_header  "🅻"
                :beamer_header "🅑"
                :latex         "🅛"
                :attr_latex    "🄛"
                :attr_html     "🄗"
                :attr_org      "⒪"
                :begin_quote   "❝"
                :end_quote     "❞"
                :caption       "☰"
                :header        "›"
                :results       "🠶"
                :begin_export  "⏩"
                :end_export    "⏪"
                :properties    "⚙"
                :end           "∎"
                :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
                :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
                :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
                :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
                :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)))
        (set-ligatures! 'org-mode
        :merge t
        :checkbox      "[ ]"
        :pending       "[-]"
        :checkedbox    "[X]"
        :list_property "::"
        :em_dash       "---"
        :ellipsis      "..."
        :arrow_right   "->"
        :arrow_left    "<-"
        :title         "#+title:"
        :subtitle      "#+subtitle:"
        :author        "#+author:"
        :date          "#+date:"
        :property      "#+property:"
        :options       "#+options:"
        :startup       "#+startup:"
        :macro         "#+macro:"
        :html_head     "#+html_head:"
        :html          "#+html:"
        :latex_class   "#+latex_class:"
        :latex_header  "#+latex_header:"
        :beamer_header "#+beamer_header:"
        :latex         "#+latex:"
        :attr_latex    "#+attr_latex:"
        :attr_html     "#+attr_html:"
        :attr_org      "#+attr_org:"
        :begin_quote   "#+begin_quote"
        :end_quote     "#+end_quote"
        :caption       "#+caption:"
        :header        "#+header:"
        :begin_export  "#+begin_export"
        :end_export    "#+end_export"
        :results       "#+RESULTS:"
        :property      ":PROPERTIES:"
        :end           ":END:"
        :priority_a    "[#A]"
        :priority_b    "[#B]"
        :priority_c    "[#C]"
        :priority_d    "[#D]"
        :priority_e    "[#E]")
        (plist-put +ligatures-extra-symbols :name "⁍")

        ;; Font Display  - Mixed pitch
        (add-hook 'org-mode-hook #'+org-pretty-mode)
        (custom-set-faces!
          '(outline-1 :weight extra-bold :height 1.25)
          '(outline-2 :weight bold :height 1.15)
          '(outline-3 :weight bold :height 1.12)
          '(outline-4 :weight semi-bold :height 1.09)
          '(outline-5 :weight semi-bold :height 1.06)
          '(outline-6 :weight semi-bold :height 1.03)
          '(outline-8 :weight semi-bold)
          '(outline-9 :weight semi-bold))
        (custom-set-faces!
          '(org-document-title :height 1.2))
)
